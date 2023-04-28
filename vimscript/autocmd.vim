autocmd BufNewFile * call SetTitle() " {{{1
function SetTitle()
    if     &l:filetype == "python"
        call setline(1, "# -*- coding: " .. &l:encoding .. "; -*-")
        call append(line(".")+0, "")
        call append(line(".")+1, "")

    elseif &l:filetype == "java"
        call setline(1, "public class " .. expand("%:t:r") .. " {}")

    elseif &l:filetype == "sh"
        call setline(1, "#!/usr/bin/bash")
    endif
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
            \if line("'\"") > 1 && line("'\"") <= line("$") 
            \| execute "normal! g'\"" 
            \| endif
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
let g:in_cmd_line = v:false  " init
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
        execute 'match WordLight /\<'
                    \.. substitute(l:word, '\([\/~.\[\]]\)', '\\\1', 'g') .. '\>/'
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
        inoremap <buffer> !main if __name__ == '__main__':<Cr>
        inoremap <buffer> !self def (self):<Left><Left><Left><Left><Left><Left><Left>
        let b:lang_fold_method = "indent"

    elseif l:type == 'rust'
        let b:lang_fold_method = "syntax"

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

    endif
    execute "setlocal foldmethod=" .. b:lang_fold_method
endfunction
" }}}1
