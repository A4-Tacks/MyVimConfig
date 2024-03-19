" 当vim无指定文件时自动打开项目目录树
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in")
"            \| NERDTree
"            \| if g:autoBigWinEnabled == 0
"                \| execute "vertical resize ".&columns / 5
"                \| endif
"            \| endif

" 不显示下述文件
let NERDTreeIgnore=[] "ignore files in NERDTree
" let NERDTreeIgnore=['\.pyc$', '\~$', 'node_modules'] "ignore files in NERDTree

" 显示隐藏文件
let NERDTreeShowHidden=1

" 不显示项目树上额外的信息，例如帮助、提示什么的
let NERDTreeMinimalUI=1

" 更改默认箭头
let g:NERDTreeDirArrowExpandable = '▶'
let g:NERDTreeDirArrowCollapsible = '▼'

" g + T: 切换到前一个tab
" g + t: 切换到后一个tab
" ctrl + p: 模糊搜索文件
