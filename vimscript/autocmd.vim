scriptencoding utf-8
autocmd BufNewFile * call SetTitle() " {{{1
function SetTitle()
    if     &l:filetype == "python"
        call Appends(0, [
                    \"#!/usr/bin/python3",
                    \"# -*- coding: " . &l:encoding . "; -*-",
                    \'"""new file"""',
                    \"",
                    \])

    elseif &l:filetype == "java"
        call setline(1, "public class " . expand("%:t:r") . " {}")

    elseif &l:filetype == "vim"
        call append(0, 'scriptencoding utf-8')
        call append(1, 'if &compatible | set nocompatible | endif')

    elseif &l:filetype == "sh"
        let script =<< trim EOF
        #!/usr/bin/bash
        set -o nounset
        set -o errtrace
        function catch_error {
            local LEC=$? name i line file
            echo "Traceback (most recent call last):" >&2
            for ((i = ${#FUNCNAME[@]} - 1; i >= 0; --i)); do
                name="${FUNCNAME[$i]}"
                line="${BASH_LINENO[$i]}"
                file="${BASH_SOURCE[$i]}"
                echo "  File ${file@Q}, line ${line}, in ${name@Q}" >&2
            done
            echo "Error: [ExitCode: ${LEC}]" >&2
            exit "${LEC}"
        }
        trap catch_error ERR
        EOF
        call Appends(0, script)

    elseif &l:filetype == 'fish'
        call append(0, '#!/usr/bin/env fish')

    elseif &l:filetype == 'awk'
        call append(0, "#!/usr/bin/awk -f")

    elseif &l:filetype == 'lua'
        call append(0, "#!/usr/bin/lua --")

    endif
    " goto end
    normal G$
endfunction
" 进入常规模式关闭粘贴模式 {{{1
function ClosePaste()
    if &paste
        set nopaste
    endif
endfunction
autocmd InsertLeave * call ClosePaste()
" 回到上次查看文件的位置 {{{1
autocmd BufReadPost *
            \   if line("'\"") > 0
            \|      if line("'\"") <= line("$")
            \|          execute "normal! '\""
            \|      else
            \|          execute "normal! $"
            \|      endif
            \|  endif

" Auto Maxsize Window {{{1
function! BigWin(open)
    augroup BigWin
        " delete this group all autocmd
        autocmd!
        let g:autoBigWinEnabled = a:open != 0 ? 1 : 0
        if a:open
            autocmd BufEnter * execute "res|vertical res"
        endif
    augroup END
endfunction
call BigWin(v:false)
" InsertEnter Clear search info {{{1
autocmd InsertEnter * exec 'let @/ = ""'
" Clear search buffer {{{1
autocmd VimEnter * let @/ = ""
" In cmd line tag variable {{{1
" init
let g:in_cmd_line = v:false
autocmd CmdlineEnter * let g:in_cmd_line = v:true
autocmd CmdlineLeave * let g:in_cmd_line = v:false
" Auto Light word {{{1
function AutoLightWordTimer(time)
    let g:cursor_word = ''
    let l:oldmode = g:in_cmd_line

    function AutoLightWordTimerF(timer) closure
        let l:word = GetCursorWord()
        if g:in_cmd_line " enter command mode no light word {{{
            if l:oldmode == g:in_cmd_line
                return
            else
                let l:word = ''
            endif
        endif " }}}
        let l:oldmode = g:in_cmd_line
        if l:word == g:cursor_word
            return
        endif
        let g:cursor_word = l:word
        let g:cursor_word_regex = '//'
        if strlen(l:word)
            let g:cursor_word_regex = StrFmt('/\<{}\>/', substitute(l:word,
                        \ '\([\/~.\[\]]\)', '\\\1', 'g'))
        endif
        execute 'match WordLight ' . g:cursor_word_regex
    endfunction

    call timer_start(a:time, 'AutoLightWordTimerF', {'repeat': -1})
endfunction
call AutoLightWordTimer(143)
" Load plugged {{{1
autocmd BufNewFile,BufRead * call SetDefaultFileTypeOptions()
function SetDefaultFileTypeOptions()
    " 设置映射 属性 参数 及启动插件
    let b:lang_fold_method = 'syntax'
    let l:type = &filetype
    if l:type == 'python'
        let b:lang_fold_method = "indent"

    elseif l:type == 'rust'
        let b:lang_fold_method = "syntax"

    elseif l:type == 'sh'
        let b:lang_fold_method = "marker"

    elseif l:type == 'java'
    "    JCEnable
    "    CocEnable
    "    setlocal omnifunc=javacomplete#Complete
    "    inoremap <buffer> <C-b> <C-x><C-o>
        let b:lang_fold_method = "syntax"

    elseif l:type == 'awk'
        let b:lang_fold_method = "marker"
        setlocal foldmarker={,}

    elseif l:type == 'vim'
        let b:lang_fold_method = "marker"

    elseif l:type == 'c'
        function! CEditType(str = '', select = 0)
            let ColMove = {col -> col < 2 ? "" : (col - 1) .. "l"}
            if a:select
                let control = StrFmt("{}G0{}v{}G0{}p",
                            \ line("'<"), ColMove(col("'<")),
                            \ line("'>"), ColMove(col("'>")))
            else
                let control = StrFmt("{}G0{}p",
                            \ line("."), ColMove(col(".")))
            endif
            if strlen(a:str) != 0
                try
                    let text = CType(0, a:str)
                catch /.*/
                    echoerr v:exception
                    throw "CTypeToRsError"
                endtry
                enew
                call setline(1, text)
            else
                enew
            endif
            imap <buffer> <F9> <Esc><F9>
            execute 'nnoremap <buffer><silent> <F9> :'
                        \.  ':let text=join(getline("^","$"))'
                        \.  '\|if strlen(text)'
                        \.      '\|try'
                        \.          '\|let @@=CType(1,text)'
                        \.      '\|catch /.*/'
                        \.          '\|echoerr v:exception'
                        \.          '\|throw "RsToCTypeError"'
                        \.      '\|endtry'
                        \.      '\|if @@==#"syntax error"'
                        \.          '\|echoerr "SyntaxError"'
                        \.      '\|else'
                        \.          '\|bp\|bd!#'
                        \.          '\|execute "normal! ' . control . '"'
                        \.      '\|endif'
                        \.  '\|else'
                        \.      '\|bp\|bd!#'
                        \.  '\|endif'
                        \.  "\<cr>"
        endfunction
        xnoremap <buffer><silent> <F9> y:call CEditType(@@, 1)<Cr>
        nnoremap <buffer><silent> <F9> :call CEditType()<Cr>

    endif
    execute "setlocal foldmethod=" .. b:lang_fold_method
endfunction
" TabAutoToEnd {{{1
autocmd TabNew * tabmove $
" END {{{1
" }}}1
