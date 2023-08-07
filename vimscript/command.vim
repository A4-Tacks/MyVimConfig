" 杂项 {{{1
command! -bang Bd bp|bd<bang> #

command! Vimrc :sp ~/.vimrc
command! -bang Wq wq<bang>
command! -bang WQ wq<bang>

function! FColor()
    set notermguicolors
    set t_Co=256
    colorscheme ron
    call SetUserColors()
endfunction
command! FColor call FColor()

" syntax or tag fold {{{1
command! Fold exec 'set foldmethod=' .
            \(&foldmethod == b:lang_fold_method
            \? 'marker' : b:lang_fold_method)
" Running code {{{1
command! -nargs=* -complete=file Run call CompileRun(<q-args>)
command! SetDefaultFileTypeOptions :call SetDefaultFileTypeOptions() " {{{1
" MyFmt {{{1
command! -range Fmt call Fmt(<line1>, <line2>)
let g:code_format_buffer_commands = {
            \ "python": '!black -q -- -',
            \ "sh": '!shfmt -ci -sr -i 4 -s -',
            \ "rust": '!rustfmt',
            \ "json": "!jq .|sed -E 's/^( *)/\\1\\1/g'",
            \ }
function! Fmt(line1, line2)
    let var_name = 'g:code_format_buffer_commands'
    let ft = &filetype
    if index(keys(eval(var_name)), ft) != -1
        execute StrFmt('{},{} {}', a:line1, a:line2, eval(var_name)[ft])
    else
        echoerr "filetype" .. ft .. " not in " .. string(keys(eval(var_name)))
    endif
endfunction
" END {{{1
" }}}1
