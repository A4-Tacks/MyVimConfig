" 杂项 {{{1
command Bd :bp|bd #

command Vimrc :sp ~/.vimrc
command Wq :wq
command WQ :wq

" syntax or tag fold {{{1
command Fold :exec 'set foldmethod=' . (&foldmethod == 'marker' ? 'syntax' : 'marker')
" Running code {{{1
command Run :call CompileRun()
command SetDefaultFileTypeOptions :call SetDefaultFileTypeOptions() " {{{1
" }}}1
