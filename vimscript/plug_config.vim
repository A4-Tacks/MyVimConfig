call plug#begin('~/.vim/plugged') " {{{1
" NerdTree
Plug 'preservim/nerdtree'

" 缩进参考线插件
Plug 'Yggdroot/indentLine'

" coc.nvim
Plug 'neoclide/coc.nvim'

" java补全插件
"Plug 'artur-shaik/vim-javacomplete2' , { 'on': 'JCEnable' } 

" py 船新补全
"Plug 'maralla/completor.vim' , { 'on': 'CompletorEnable' }

" ale
Plug 'https://github.com/w0rp/ale', " { 'on': 'ALEEnable' }

" 彩虹括号
"Plug 'luochen1990/rainbow'

call plug#end() " Plug配置文件

filetype plugin indent on
" }}}1
