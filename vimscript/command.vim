" 杂项 {{{1
command! Bd :bp|bd #

command! Vimrc :sp ~/.vimrc
command! Wq :wq
command! WQ :wq

" syntax or tag fold {{{1
command! Fold :exec 'set foldmethod=' .
            \(&foldmethod == b:lang_fold_method
            \? 'marker' : b:lang_fold_method)
" Running code {{{1
command! -nargs=* -complete=file Run :call CompileRun(<q-args>)
command! SetDefaultFileTypeOptions :call SetDefaultFileTypeOptions() " {{{1
" }}}1
