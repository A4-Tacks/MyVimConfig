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
function! Clipboard()
    let l:display_width = float2nr(&columns * 0.8) - 6
    let l:lines = []
    let l:Format = {name -> 
                \add(l:lines, "@" .. name .. ": ["
                \.. SplitLongStr(
                \substitute(eval('@' .. name), '\n', '\\n', 'g'),
                \l:display_width) .. "];")}
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
    return "\<C-r>" .. l:input
endfunction
inoremap <expr> #@ Clipboard() .. "\<Esc>"
" Running or save source code {{{1
function! Runer() " -> dict
    function! s:python(args) dict " -> str {{{2
        return "time python3 " .. FileNameToShell(expand("%:p")) .. " " .. join(a:args)
    endfunction
    function! s:clang(args) dict " -> str {{{2
        let args = SplitLevelsArgs(2, a:args)
        let outf = FileNameToShell(expand("%:p:r") .. ".out")
        return "time gcc " .. FileNameToShell(expand("%:p")) .. " -o "
                    \.. outf .. " " .. join(args[0])
                    \.. "&& time " .. outf .. " " .. join(args[1])
    endfunction
    function! s:sh(args) dict " -> str {{{2
        let args = SplitLevelsArgs(2, a:args)
        return "time bash " .. join(args[0])
                    \.. " " .. expand("%:p") .. " " .. join(args[1])
    endfunction
    function! s:vim(args) dict " -> str {{{2
        let args = SplitLevelsArgs(2, a:args)
        return "time vim " .. join(args[0])
                    \.. " -u " .. expand("%:p") .. " " .. join(args[1])
    endfunction
    function! s:rust(args) dict " -> str {{{2
        let args = SplitLevelsArgs(2, a:args)
        if expand("%:t") == "main.rs"
            return "time cargo run " .. join(args[0])
                        \.. " -- " .. join(args[1])
        else
            return "time cargo test " .. join(args[0])
                        \.. " -- " .. join(args[1])
        endif
    endfunction
    function! s:awk(args) dict " -> str {{{2
        let args = SplitLevelsArgs(2, a:args)
        return "time awk " .. join(args[0])
                    \.. " -f " .. expand("%:p") .. " " .. join(args[1])
    endfunction
    function! s:js(args) dict " -> str {{{2
        let args = SplitLevelsArgs(2, a:args)
        return "time node " .. join(args[0])
                    \.. " " .. expand("%:p") .. " " .. join(args[1])
    endfunction
    " result dict functions {{{2
    return
                \{
                \"python": funcref("s:python"),
                \"c": funcref("s:clang"),
                \"sh": funcref("s:sh"),
                \"vim": funcref("s:vim"),
                \"rust": funcref("s:rust"),
                \"awk": funcref("s:awk"),
                \"javascript": funcref("s:js"),
                \}
    " }}}2
endfunction
nnoremap <F5> :call CompileRun()<CR>

let g:runer = Runer()

function! CompileRun() " {{{
    if &modified
        " 编辑后仅保存
        write
        return v:false
    endif
    if index(keys(g:runer), &filetype) == -1
        echo &filetype .. " not in lang config. " .. string(keys(g:runer))
        return v:none
    endif
    let args = map(ShlexSplit(input("args> ")),
                \{ _, x -> FileNameToShell(x) })
    execute "!set -x;" .. 'echo -ne "\e[0m\e[' .. &lines .. 'S\e[H";'
                \.. g:runer[&filetype](args)
    " execute "terminal bash -c " .. FileNameToShell("set -x;" .. 'echo -ne "\e[0m\e[' .. &lines .. 'S\e[H";'
    "             \.. g:runer[&filetype](args))
    return v:true
endfunction " }}}

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
function! Completion_start() " {{{2
    let result = 0
    try
        let result = result || coc#pum#visible()
    catch /.*/
    endtry
    return pumvisible() || result
endfunction! " }}}2

inoremap #<Tab> <Tab>

" from coc
"imap <expr><silent> <Tab> Completion_start() ? "\<C-n>" : TabGoTu()
"imap <expr><silent> <S-Tab> Completion_start() ? "\<C-p>" : "\<Tab>"
"imap <expr><silent> <Up> Completion_start() ? "\<C-p>" : "\<Up>"
"imap <expr><silent> <Down> Completion_start() ? "\<C-n>" : "\<Down>"

" Enter map {{{1
" Insert mode Enter {{{2
function! EnterInsert()
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
function! NEnterInsert()
    if foldclosed(line(".")) != -1
        return "zo"
    else 
        return "\<Cr>"
    endif 
endfunction! 
nnoremap <expr> <Cr> NEnterInsert()
" }}}2
" }}}1
