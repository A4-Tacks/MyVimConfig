" 符号转换 {{{1
inoremap #x \
inoremap #& \|
inoremap #' ''<Left>
inoremap #_ ~
inoremap #" `
" 可视模式下使用退格键即可删除选中内容 {{{1
vnoremap <Bs> <Del>
" 全角转半角 {{{1
nnoremap ： :

cnoremap ！ !
cnoremap ？ ?
cnoremap ， ,
cnoremap ～ ~
cnoremap ； ;

inoremap “ "
inoremap ” "
inoremap ， ,
inoremap ： :
inoremap ； ;
inoremap 。 .
inoremap （ (
inoremap ） )
inoremap 【 [
inoremap 】 ]
inoremap ｛ {
inoremap ｝ }
inoremap 《 <
inoremap 》 >
inoremap ？ ?
inoremap ！ !
" 括号类 {{{1
inoremap #kq [
inoremap #kw {
inoremap #ke <

inoremap #lq ]
inoremap #lw }
inoremap #le >

inoremap #q []<Left>
inoremap #w {}<Left>
inoremap #e <><Left>
inoremap #< <><Left>

inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>
inoremap " ""<Left>
" 快捷符号映射 {{{1
inoremap #lk ->
inoremap #Lk ->
inoremap #LK ->

inoremap #kl =>
inoremap #Kl =>
inoremap #KL =>

inoremap #i ""<Left>
inoremap #o ''<Left>
inoremap #n +
inoremap #u =

" Fold
inoremap #zk {{{
inoremap #zl }}}
" 辅助按键 {{{1
inoremap <silent> jk <Esc>

" terminal
" term 回 vim
tnoremap jk <C-\><C-n>

" del
inoremap <C-l> <Del>
" paste start
inoremap <expr> #cf execute("set paste")

" line end ;
inoremap #; <End>;
inoremap #, <End>,
" Disable Empty Search {{{1
nnoremap <expr> n strlen(@/) > 0 ? "n" : ""
nnoremap <expr> N strlen(@/) > 0 ? "N" : ""
" Leader maps {{{1
nnoremap <leader>t :NERDTreeToggle<Cr>
nnoremap <leader>T :NERDTreeClose<Cr>
" Window control {{{1
nmap <silent> <Space> <C-w>
nnoremap <silent> <Space><Space> <C-w><C-w>
nnoremap <silent> <Space>M :res<Cr>:vertical res<Cr>
nnoremap <silent> <Space>= :res+3<Cr>
nnoremap <silent> <Space>- :res-3<Cr>
nnoremap <silent> <Space>_ :vertical res-6<Cr>
nnoremap <silent> <Space>+ :vertical res+6<Cr>
nnoremap <Space>m <C-w>=
" Space B 开关自动最大化
nnoremap <silent><expr> <Space>B g:autoBigWinEnabled ? BigWin(0) : BigWin(1)

" open terminal
nnoremap <silent> <Space>t :terminal<Cr>

" Select Clipboard Paste {{{1
function Clipboard()
    let l:display_width = float2nr(&columns * 0.8) - 6
    let l:lines = []
    let l:Format = {name -> 
                \add(l:lines, "@" . name . ": ["
                \. SplitLongStr(
                \substitute(eval('@' . name), '\n', '\\n', 'g'),
                \l:display_width) . "];")}
    call add(l:lines, "-*- Clipboard -*-")
    call l:Format('"')
    call l:Format('+')
    for l:i in range(10)
        call l:Format(l:i)
    endfor
    echo join(l:lines, "\n")
    let l:input = input("select paste id> ")
    if strlen(l:input) == 0
        return ""
    endif
    set paste
    return "\<C-r>" . l:input
endfunction
inoremap <expr> #@ Clipboard() . "\<Esc>"
" Running or save source code {{{1
" filetype : command
let s:v =<< EOF
c:              gcc % -o %:t:r.out
sh:             bash % $$
vim:            vim -u % $$
awk:            awk -f % $$
rust:           cargo run $$
python:         python % $$
javascript:     node % $$
EOF

" to map
python3 << EOF
lines = vim.eval("s:v")
res = {}
old = None
for line in lines:
    line = line.lstrip()
    if line[0] == "\\":
        res[old] += " " + line[1:]
    else:
        type_, cmd = re.split(r":\s*", line, 1)
        old = type_
        res[old] = cmd
EOF
let g:lang_run_command = py3eval("res")

nnoremap <F5> :call CompileRun()<CR>

func! CompileRun() " {{{
    if &modified
        " 编辑后仅保存
        exec "w"
        return v:false
    endif
    if index(keys(g:lang_run_command), &filetype) == -1
        echo "file not in lang config. " . string(keys(g:lang_run_command))
        return v:none
    endif
    let l:F = {_, x -> substitute(fnameescape(x), 
                        \'\([();&>]\)', {x -> '\' . x[1]}, 'g')}
    let l:command = ShlexSplit(g:lang_run_command[&filetype])
    let l:args = map(ShlexSplit(input("args> ")),
                \l:F)
    for l:i in range(len(l:command))
        let l:token = l:command[l:i]
        if l:token[0] == '%'
            let l:command[l:i] = F(0, expandcmd(l:token))
        elseif l:token == '$$'
            let l:command[l:i] = join(l:args)
        else
            let l:command[l:i] = shellescape(l:token, 1)
        endif
    endfor
    execute "!set -x;" . 'echo -ne "\e[0m\e[' . &lines . 'S\e[H";time ' . join(l:command)
endfunc " }}}

" Translate {{{1
nnoremap <F7> yy:call Appends(line("."), Translate("c", @@))<Cr>
vnoremap <F7> y:call Appends(line("."), Translate("c", @@))<Cr>
vnoremap <F8> :%!mybaidufanyiapireadinput a<Cr>

" Tab map {{{1
func TabGoTu() " {{{2
    if foldclosed(line(".")) != -1
        return "\<C-o>zo"
    endif 
    let text=getline(".")[col(".")-1]
    let column=col(".")
    return "\<Tab>"
endfunc
function Completion_start() " {{{2
    let result = 0
    try
        let result = result || coc#pum#visible()
    catch /.*/
    endtry
    return pumvisible() || result
endfunction " }}}2

inoremap #<Tab> <Tab>

imap <expr><silent> <Tab> Completion_start() ? "\<C-n>" : TabGoTu()
imap <expr><silent> <S-Tab> Completion_start() ? "\<C-p>" : "\<Tab>"
imap <expr><silent> <Up> Completion_start() ? "\<C-p>" : "\<Up>"
imap <expr><silent> <Down> Completion_start() ? "\<C-n>" : "\<Down>"

" Enter map {{{1
" Insert mode Enter {{{2
function EnterInsert()
    if Completion_start()
        " 补全菜单展开则直接选择
        return "\<C-p>\<C-n>\<Esc>a"
    endif
    let l:COL = col(".")
    let l:LINE = getline(".")
    if index(["()", "[]", "{}"], l:LINE[l:COL-2:l:COL-1]) != -1
        " 展开括号
        return "\<Cr>\<C-o>%\<C-o>o"
    endif
    return "\<Cr>"
endfunction
inoremap #<Cr> <Cr>
" imap <expr> <Cr> EnterInsert()

" Normal Enter open fold " {{{2
function NEnterInsert()
    if foldclosed(line(".")) != -1
        return "zo"
    else 
        return "\<Cr>"
    endif 
endfunction 
nnoremap <expr> <Cr> NEnterInsert()
" }}}2
" }}}1
