" 杂项 {{{1
command! -bar -bang Bd bp|bd<bang> #

command! Vimrc :sp ~/.vimrc
command! -bar -bang -complete=file -nargs=* W  w<bang> <args>
command! -bar -bang -complete=file -nargs=* Wq wq<bang> <args>
command! -bar -bang -complete=file -nargs=* WQ wq<bang> <args>
command! -bar -bang Q  q<bang>
command! -bar -bang Qa qa<bang>
command! -bar -bang QA qa<bang>

function! FColor()
    set notermguicolors
    set t_Co=256
    colorscheme ron
    call SetUserColors()
endfunction
command! FColor call FColor()

command! -bar -register -range ReverseLines
            \ call setline("<line1>", getline("<line1>", "<line2>")->reverse())

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
            \ "rust": '!rustfmt --config match_block_trailing_comma=true,struct_lit_single_line=false,max_width=78,where_single_line=true',
            \ "json": "!jq . --indent 4",
            \ "c": "!clang-format --style='{BasedOnStyle: llvm, IndentWidth: 4}'",
            \ "cpp": "!clang-format --style='{BasedOnStyle: llvm, IndentWidth: 4}'",
            \ }
function! Fmt(line1, line2)
    let var_name = 'g:code_format_buffer_commands'
    let indent = indent(a:line1)
    let ft = &filetype
    let endl = line('$')
    if index(keys(eval(var_name)), ft) != -1
        execute StrFmt('{},{} {}', a:line1, a:line2, eval(var_name)[ft])
        let offset = line('$') - endl
        silent execute $'{a:line1},{a:line2+offset} s/^/{repeat(" ", indent)}'
    else
        echoerr "filetype" .. ft .. " not in " .. string(keys(eval(var_name)))
    endif
endfunction
" END {{{1
" }}}1
