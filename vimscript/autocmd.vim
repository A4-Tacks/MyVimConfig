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
" Enter normal disbale paste {{{1
function ClosePaste()
    if &paste
        set nopaste
    endif
endfunction
autocmd InsertLeave * if &paste | set nopaste eventignore= | endif
" 回到上次查看文件的位置 {{{1
" last-position-jump

function! LastPositionJump()
    if &filetype =~# 'commit'
        return
    endif

    let line = line("'\"")
    if line >= 1 && line <= line("$")
        execute "normal! '\""
    else
        execute "normal! $"
    endif
endfunction


autocmd BufReadPost * call LastPositionJump()

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
autocmd InsertEnter * if !empty(@/) | let g:prev_search = @/ | en | let @/ = ""
" Clear search buffer {{{1
autocmd VimEnter * let @/ = ""
" In cmd line tag variable {{{1
" init
let g:in_cmd_line = v:false
autocmd CmdlineEnter * let g:in_cmd_line = v:true
autocmd CmdlineLeave * let g:in_cmd_line = v:false
" Auto Light word {{{1
function AutoLightWordTimer(time)
    let [g:cursor_word, g:cursor_word_str] = ['', '']
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
        if type(l:word) == type(g:cursor_word) && l:word == g:cursor_word
            return
        endif
        let g:cursor_word = l:word
        let g:cursor_word_str = type(l:word) == v:t_list ? l:word[0] : l:word
        let g:cursor_word_regex = ''
        if type(l:word) == v:t_list
            if l:word[0]->match('^\s*$') == -1
                let g:cursor_word_regex = '\V'
                            \ . l:word[0]->substitute('[/\\]', '\\\0', 'g')
            endif
        elseif strlen(l:word)
            let g:cursor_word_regex = '\V\<'
                        \ . l:word->substitute('[/\\]', '\\\0', 'g')
                        \ . '\>'
        endif
        execute 'match WordLight /' . g:cursor_word_regex . '/'
    endfunction

    call timer_start(a:time, 'AutoLightWordTimerF', {'repeat': -1})
endfunction

call AutoLightWordTimer(135)
" Auto open fold for Insert mode {{{1
" 从默认行为来说, 这是本来就有的. 但是代码片段插件并不会触发这个, 所以增加这个
autocmd TextChangedI * if foldclosed('.') != -1 | foldopen! | en
" Load plugged {{{1
autocmd Syntax * call SetDefaultFileTypeOptions()
function SetDefaultFileTypeOptions()
    " 设置映射 属性 参数 及启动插件
    let l:type = &filetype
    if l:type == 'python'
        setlocal foldmethod=expr
        setlocal foldexpr=HeadLineIndentFunction(v:lnum)

    elseif l:type == 'rust'
        setlocal foldmethod=syntax

    elseif l:type == 'sh'
        setlocal foldmethod=marker

    elseif l:type == 'java'
    "    JCEnable
    "    CocEnable
    "    setlocal omnifunc=javacomplete#Complete
    "    inoremap <buffer> <C-b> <C-x><C-o>
        setlocal foldmethod=syntax

    elseif l:type == 'vim'
        setlocal foldmethod=marker

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
        setlocal foldmethod=syntax

    elseif l:type == 'ocaml'
        setlocal shiftwidth=2
        setlocal foldmethod=syntax

    elseif ['javascript', 'typescript']->index(l:type) != -1
        setlocal shiftwidth=2
        setlocal foldmethod=syntax

    endif

    if &foldmethod ==# 'manual'
        setlocal foldmethod=syntax
    endif
endfunction
" TabAutoToEnd {{{1
autocmd TabNew * tabmove $
" Auto input completion {{{1
" 这将可以在启用时有多个补全结果时自动展开补全菜单, 没用coc等的时候用
" 美中不足的是输入过快因为使用的timer实时性不够可能出现问题
if exists('enable_builtin_completion_auto_popup')
    function s:complete_first(word, timer)
        if !s:complete_first_wait | return | endif
        let s:complete_first_wait = v:false
        let info = complete_info()
        if info.pum_visible || info.items->len() != 1
            if info.pum_visible && info.selected == -1
                call feedkeys("\<down>")
            en
            return
        en
        call complete(col('.')-strlen(a:word), [a:word, info.items[0].word])
    endfunction
    au InsertCharPre *  if !pumvisible() && v:char =~# '\<.\>'
                    \ |     call feedkeys("\<c-n>\<c-p>")
                    \ |     let s:complete_first_wait = v:true
                    \ |     call timer_start(0, funcref(
                    \           's:complete_first',
                    \           [
                    \               (getline('.')[:col('.')-1].v:char)->matchstr('\<\%(.\<\@!\)\+$'),
                    \           ],
                    \       ))
                    \ | en
endif
" 语法文件注册 {{{1
augroup filetypedetect
    autocmd BufNewFile,BufRead *.mdtlbl setfiletype mdtlbl
    autocmd BufNewFile,BufRead *.mtsx setfiletype mtsyntax
augroup END
" END {{{1
" }}}1
