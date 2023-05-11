" 杂项 {{{1
command! -bang Bd bp|bd<bang> #

command! Vimrc :sp ~/.vimrc
command! -bang Wq wq<bang>
command! -bang WQ wq<bang>

" syntax or tag fold {{{1
command! Fold exec 'set foldmethod=' .
            \(&foldmethod == b:lang_fold_method
            \? 'marker' : b:lang_fold_method)
" Running code {{{1
command! -nargs=* -complete=file Run call CompileRun(<q-args>)
command! SetDefaultFileTypeOptions :call SetDefaultFileTypeOptions() " {{{1
" }}}1
