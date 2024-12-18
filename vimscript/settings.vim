scriptencoding utf-8
" 关闭兼容模式, 也就是去除vi一致性
if &compatible
    set nocompatible
endif

" 语法高亮
syntax on

" 开启行号与相对行号
set number
set relativenumber

" 编程耻辱线
set colorcolumn=79

" color
set t_Co=256

" 高亮当前行
set cursorline

" Mouse enable
set mouse=a

" 显示光标位置
set ruler

" 使用空格来替换Tab
set expandtab

" Tab 显示长度
set tabstop=4

" 退格与Tab缩进长度, 跟随shiftwidth
set softtabstop=-1

" 每一级缩进长度, 同时也代表了代码折叠判定
set shiftwidth=4


" 禁用连续注释 每次切换缓冲区都执行一次 详见: `fo-table`
"autocmd BufEnter * set formatoptions-=cro
" /: 仅当注释位于行开头时进行续行
" o: 进行例如 norm_o 时插入注释
" m: 断行时对于扩展 Ascii 之外的字符视为一个完整词
" B: 合并行时, 不要在两个扩展 Ascii 之外的字符之间插入空格 (被M选项覆盖)
autocmd BufEnter * set formatoptions+=/mBrj formatoptions-=o

" AutoIndent and 智能缩进
set autoindent smartindent

" Backspace detele range
" start:old char, eol:line,
set backspace=indent,start,eol

" 开启实时搜索功能
set incsearch

" 关闭搜索忽略大小写
set noignorecase

" vim 命令自动补全
set wildmenu wildoptions=fuzzy

" 文件自动更新
set autoread

" GUI - 禁止光标闪烁
set guicursor=a:block-blinkon0

" 高亮显示搜索结果
set hlsearch

" Split line
set wrap

" 不在单词内部换行
set showbreak=> linebreak

" 垂直滚动阈值
set scrolloff=3

" 水平滚动阈值
set sidescrolloff=22

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
call system('mkdir -p -- ' . join(
            \map([&backupdir, &undodir, &directory, g:temp_directory],
            \{_, x -> FileNameToShell(x)})))

" 不操作多久会将 swp 交换文件写入(ms), 这个参数也影响CursorHold事件
set updatetime=4500
" 每输入多少次字符写入一次交换文件
set updatecount=50

" Encoding
set encoding=utf-8
set fileencodings=utf-8
set fileencodings+=gb18030,gbk,gb2312,cp936
set fileencodings+=ucs-bom,shift-jis,utf-16-be,utf-16-le,utf-32-be,utf-32-le

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
set display+=uhex

" 按键映射序列延迟与终端控制序列延迟
set timeoutlen=500
set ttimeoutlen=0

" Default code fold mode
set foldmethod=marker

" Display tab char
set listchars=tab:──┤, list

" Disabled Fix EndOfLine. Auto EOL
set nofixeol

" 底部行格式
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

" 显示正在输入的命令
set showcmd showcmdloc=last


" 语法隐藏级别 (0:关 1:透明 2:不存在)
set conceallevel=2
" 语法隐藏在什么模式下生效 (在光标行)
set concealcursor=nc


" 预设填充字符们
"   item name	default		Used for ~
"   stl		' ' or '^'	statusline of the current window
"   stlnc		' ' or '='	statusline of the non-current windows
"   vert		'|'		vertical separators |:vsplit|
"   fold		'-'		filling 'foldtext'
"   foldopen	'-'		mark the beginning of a fold
"   foldclose	'+'		show a closed fold
"   foldsep	'|'		open fold middle character
"   diff		'-'		deleted lines of the 'diff' option
"   eob		'~'		empty lines below the end of a buffer
"   lastline	'@'		'display' contains lastline/truncate
set fillchars=vert:│,fold:─,foldopen:─,foldclose:+,foldsep:│
set fillchars+=diff:─,eob:~,lastline:@



" Moust mode shape(形状)
let &t_SI.="\e[6 q" " SI = INSERT mode
let &t_SR.="\e[4 q" " SR = REPLACE mode
let &t_EI.="\e[2 q" " EI = NORMAL mode (ELSE)

" 粘贴模式快捷键
set pastetoggle=#cf

" leader
let mapleader = ' '

" shell running options
" let &shellcmdflag = "-x -c"

" awk is gawk
let g:awk_is_gawk = 1

" c headers
let g:c_syntax_for_h = 1

" ocamlformat indent
set runtimepath^=~/.opam/default/share/ocp-indent/vim
