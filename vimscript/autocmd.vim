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
        #set -o pipefail
        function CATCH_ERROR {
            local __LEC=$? __i __j
            echo "Traceback (most recent call last):" >&2
            for ((__i = ${#FUNCNAME[@]} - 1; __i >= 0; --__i)); do
                printf '  File %q line %s in %q\n' >&2 \
                    "${BASH_SOURCE[__i]}" \
                    "${BASH_LINENO[__i]}" \
                    "${FUNCNAME[__i]}"
                if ((BASH_LINENO[__i])) && [ -f "${BASH_SOURCE[__i]}" ]; then
                    for ((__j = 0; __j < BASH_LINENO[__i]; ++__j)); do
                        read -r REPLY
                    done < "${BASH_SOURCE[__i]}"
                    printf '    %s\n' "$REPLY" >&2
                fi
            done
            echo "Error: [ExitCode: ${__LEC}]" >&2
            exit "${__LEC}"
        }
        trap CATCH_ERROR ERR
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
autocmd InsertEnter *
            \   if !empty(@/)
            \ |     let g:prev_search = @/
            \ |     let g:prev_search_forward = v:searchforward
            \ | en
            \ | let @/ = ""
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
        if g:cursor_word_regex->slice(-1) ==# "\n"
            let g:cursor_word_regex = g:cursor_word_regex->slice(0, -1) . '\n'
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
function! s:set(tbl)
    for [k, v] in items(a:tbl)
        execute 'setlocal '.k..'='.v
        silent execute 'do OptionSet '.k
    endfor
endfunction
function SetDefaultFileTypeOptions()
    " 设置映射 属性 参数 及启动插件

    " define literals {{{
    let expr = 'expr'
    let syntax = 'syntax'
    let indent = 'indent'
    let marker = 'marker'
    " }}}

    let l:type = &filetype
    if l:type == 'python'
        call s:set(#{foldmethod: expr, foldexpr: 'HeadLineIndentFunction(v:lnum)'})

    elseif l:type == 'rust'
        call s:set(#{foldmethod: syntax})

    elseif l:type == 'sh'
        call s:set(#{foldmethod: marker})

    elseif l:type == 'java'
    "    JCEnable
    "    CocEnable
    "    setlocal omnifunc=javacomplete#Complete
    "    call s:set(#{omnifunc: 'javacomplete#Complete'})
    "    inoremap <buffer> <C-b> <C-x><C-o>
        call s:set(#{foldmethod: syntax})

    elseif l:type == 'vim'
        call s:set(#{foldmethod: marker})

    elseif l:type == 'c'
        xnoremap <buffer><silent> <F9>   y:<c-u>let@@=join(CType(0,@@),"\n")<cr>gvp
        xnoremap <buffer><silent> <C-F9> y:<c-u>let@@=join(CType(1,@@),"\n")<cr>gvp
        nmap <buffer><silent> <F9>   _vg_<F9>
        nmap <buffer><silent> <C-F9> _vg_<C-F9>
        imap <buffer><silent> <F9>   <esc><F9>
        imap <buffer><silent> <C-F9> <esc><C-F9>
        call s:set(#{foldmethod: syntax})

    elseif l:type == 'ocaml'
        call s:set(#{foldmethod: syntax, shiftwidth: 2})

    elseif l:type == 'jq'
        call s:set(#{foldmethod: indent, shiftwidth: 2})

    elseif ['javascript', 'typescript']->index(l:type) != -1
        call s:set(#{foldmethod: syntax, shiftwidth: 2})

    endif

    if &foldmethod ==# 'manual'
        call s:set(#{foldmethod: syntax})
    endif
endfunction
" TabAutoToEnd {{{1
autocmd TabNew * tabmove $
" Auto input completion {{{1
" 这将可以在启用时有多个补全结果时自动展开补全菜单, 没用coc等的时候用
" 美中不足的是输入过快因为使用的timer实时性不够可能出现问题
if exists('enable_builtin_completion_auto_popup')
    function s:complete_first(word, timer)
        if !empty(reg_recording()) || !empty(reg_executing())
            return
        endif
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
    au InsertCharPre *  if empty(reg_recording()) && empty(reg_executing())
                    \           && !pumvisible() && v:char =~# '\<.\>'
                    \ |     call feedkeys("\<c-n>\<c-p>")
                    \ |     let s:complete_first_wait = v:true
                    \ |     call timer_start(0, funcref(
                    \           's:complete_first',
                    \           [
                    \               (getline('.')[:col('.')-2].v:char)->matchstr('\<\%(.\<\@!\)\+$'),
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
