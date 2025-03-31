call plug#begin('~/.vim/plugged') " {{{1
" NerdTree
Plug 'preservim/nerdtree'

" coc.nvim
Plug 'neoclide/coc.nvim'

" java补全插件
"Plug 'artur-shaik/vim-javacomplete2' , { 'on': 'JCEnable' }

" py 船新补全
"Plug 'maralla/completor.vim' , { 'on': 'CompletorEnable' }

" ale
Plug 'w0rp/ale', " { 'on': 'ALEEnable' }

" 彩虹括号
"Plug 'luochen1990/rainbow'

" 窗口控制模式
Plug 'A4-Tacks/winmode.vim'

call plug#end() " Plug配置文件

filetype plugin indent on
" }}}1
