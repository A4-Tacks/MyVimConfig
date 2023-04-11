" 关闭兼容模式, 也就是去除vi一致性
set nocompatible 

" 语法高亮
syntax on

" 开启行号与相对行号
set number
set relativenumber

" 编程耻辱线
set colorcolumn=79

" color
set t_Co=16

" 高亮当前行
hi CursorLine term=nocombine cterm=nocombine ctermbg=235
set cursorline

" Mouse enable
set mouse=a

" 显示光标位置
set ruler 

" 使用空格来替换Tab
set expandtab

" Tab 显示长度
set tabstop=4

" 退格缩进长度
set softtabstop=4

" 每一级缩进长度, 同时也代表了代码折叠判定
set shiftwidth=4

" 禁用连续注释 每次切换缓冲区都执行一次
autocmd BufEnter * set formatoptions-=c formatoptions-=r formatoptions-=o

" AutoIndent and 智能缩进
set autoindent smartindent

" Backspace Detele range
" start:old char, eol:line, 
set backspace=indent,start,eol

" 开启实时搜索功能
set incsearch

" 关闭搜索忽略大小写
set noignorecase 

" vim 命令自动补全
set wildmenu

" 文件自动更新
set autoread 

" GUI - 禁止光标闪烁
set gcr=a:block-blinkon0 

" 高亮显示搜索结果
set hlsearch 

" Split line
set wrap 

" 不在单词内部换行
set linebreak

" 垂直滚动阈值
execute " set scrolloff=" .&lines / 16

" 水平滚动阈值
execute " set sidescrolloff=" .&columns / 8

" if display panel. 0:Disabled, 1:Windows, 2:Enabled
set laststatus=2

" window min width and height
" This window
set winwidth=5
set winheight=2
" Other windows
set winminwidth=5
set winminheight=2

" 历史操作记录数
set history=500

" 打开文件监视. 如果在编辑过程中文件发生外部改变, 就会发出提示
set autoread

" 编辑文件时进行备份
set backup
set backupdir=~/.vim/.backup//
set backupext=.bak

" 保存撤销/编辑记录文件到一个指定目录
set undofile
set undodir=~/.vim/.undodir

" 保存交换文件至指定目录
set swapfile
set directory=~/.vim/.vimswap//


let g:temp_directory = expand('$HOME/.vim/.tempfile')


" 创建必要的文件夹
call system('mkdir -p ' . join(
            \map([&backupdir, &undodir, &directory, g:temp_directory],
            \{_, x -> FileNameToShell(x)})))

" 不操作多久会将 swp 交换文件写入(ms)
set updatetime=750
" 每输入多少次字符写入一次交换文件
set updatecount=50

" Encoding
set encoding=utf-8
set fileencodings=utf-8,ucs-bom,shift-jis,
set fileencodings+=gb18030,gbk,gb2312,cp936,
set fileencodings+=utf-16-be,utf-16-le,utf-32-be,utf-32-le,

" Allow unsaved to other buffer
set hidden

" 留出更多空间来显示消息。(底行高度)
set cmdheight=1

" 不要将消息传递到| ins-completion-menu |。
set shortmess+=c

" reload display outtime
set redrawtime=5000

" Fold control column width
" set foldcolumn=3

" 使用 hex 查看不可显示字符
" 调成空为默认
set display=uhex

" 按键映射序列延迟与终端控制序列延迟
set timeoutlen=500
set ttimeoutlen=0

" Default code fold mode
set foldmethod=marker

" Display tab char
set listchars=tab:<=>
set list

" Disabled Fix EndOfLine. Auto EOL
set nofixeol

" 底部行格式
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P


" Moust mode shape(形状)
let &t_SI.="\e[6 q" " SI = INSERT mode
let &t_SR.="\e[4 q" " SR = REPLACE mode
let &t_EI.="\e[2 q" " EI = NORMAL mode (ELSE)

" 粘贴模式快捷键
set pastetoggle=#cf

" leader
let mapleader = "#"

" shell running options
" let &shellcmdflag = "-x -c"
