" 符号转换 {{{1
noremap! #x \
noremap! #& \|
inoremap #' ''<Left>
inoremap #_ ~
inoremap #" `
" 可视模式下使用退格键即可删除选中内容 {{{1
vnoremap <Bs> <Del>
" 全角转半角 {{{1
nnoremap ： :

" [nore]map! is insert and command mode
noremap! ～ ~
noremap! “ "
noremap! ” "
noremap! ， ,
noremap! ： :
noremap! ； ;
noremap! 。 .
noremap! （ (
noremap! ） )
noremap! 【 [
noremap! 】 ]
noremap! ｛ {
noremap! ｝ }
noremap! 《 <
noremap! 》 >
noremap! ？ ?
noremap! ！ !
" 括号类 {{{1
noremap! #kq [
noremap! #kw {
noremap! #ke <

noremap! #lq ]
noremap! #lw }
noremap! #le >

noremap! #q []<Left>
noremap! #w {}<Left>
noremap! #e <><Left>
noremap! #< <><Left>

noremap! ( ()<Left>
noremap! [ []<Left>
noremap! { {}<Left>
noremap! " ""<Left>
" 快捷符号映射 {{{1
noremap! #lk ->
noremap! #Lk ->
noremap! #LK ->

noremap! #kl =>
noremap! #Kl =>
noremap! #KL =>

noremap! #i ""<Left>
noremap! #o ''<Left>
noremap! #n +
noremap! #u =

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

" next or prev buffer {{{
command! -count -bar BufferNext execute "bnext " .. (<range> ? <line2>-<line1> + 1 : "")
command! -count -bar BufferPrev execute "bprevious " .. (<range> ? <line2>-<line1> + 1 : "")
nnoremap <silent> gb :BufferNext<Cr>
nnoremap <silent> gB :BufferPrev<Cr>
" }}}

" 范围选择 {{{1
function! RangeMapDefine(key, str)
    execute 'omap a' .. a:key .. ' a' .. a:str
    execute 'xmap a' .. a:key .. ' a' .. a:str
    execute 'omap i' .. a:key .. ' i' .. a:str
    execute 'xmap i' .. a:key .. ' i' .. a:str
endfunction

call RangeMapDefine('k', '(')
call RangeMapDefine('q', '[')
call RangeMapDefine('w', '{')
call RangeMapDefine('e', 'e')
call RangeMapDefine('i', '"')
call RangeMapDefine('o', "'")

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
    function! s:lua(args) dict " -> str {{{2
        let args = SplitLevelsArgs(2, a:args)
        return "time lua " .. join(args[0])
                    \.. " -- " .. expand("%:p") .. " " .. join(args[1])
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
                \"lua": funcref("s:lua"),
                \}
    " }}}2
endfunction
nnoremap <silent> <F5> :if &modified \| write \| else \| call CompileRun(input("args> ")) \| endif<CR>

let g:runer = Runer()

function! CompileRun(args_text) " {{{
    if index(keys(g:runer), &filetype) == -1
        echo &filetype .. " not in lang config. " .. string(keys(g:runer))
        return v:none
    endif
    let args = map(ShlexSplit(a:args_text),
                \{ _, x -> FileNameToShell(x) })
    execute "!set -x;" .. 'echo -ne "\e[0m\e[' .. &lines .. 'S\e[H";'
                \.. g:runer[&filetype](args)
    " execute "terminal bash -c " .. FileNameToShell("set -x;" .. 'echo -ne "\e[0m\e[' .. &lines .. 'S\e[H";'
    "             \.. g:runer[&filetype](args))
endfunction " }}}

" Translate {{{1
nnoremap <F7> yy:call Appends(line("."), Translate("c", @@))<Cr>
xnoremap <F7> y:call Appends(line("."), Translate("c", @@))<Cr>
xnoremap <F8> :%!mybaidufanyiapireadinput a<Cr>

" Tab map {{{1
function TabGoTu() " {{{2
    if foldclosed(line(".")) != -1
        return "\<C-o>zo"
    endif 
    let text=getline(".")[col(".")-1]
    let column=col(".")
    return "\<Tab>"
endfunction
function! Completion_start() " {{{2
    let result = 0
    try
        let result = result || coc#pum#visible()
    catch /.*/
    endtry
    return pumvisible() || result
endfunction " }}}2

noremap! #<Tab> <Tab>

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
endfunction 
nnoremap <expr> <Cr> NEnterInsert()
" }}}2
" Commands {{{1
let g:commands_list = [
            \['SelectLineNumber', funcref('SelectLineNumberDisplay')],
            \['Wrap', { -> execute('set ' .. (&wrap ? 'no' : '') .. 'wrap')}],
            \]
nnoremap <leader><leader> :call Commands()<Cr>
function Commands(page = 0)
    if a:page < 0
        return
    endif
    redrawstatus " 重绘状态行来避免输出堆积到一起
    let fmtter = '{}: {}'
    let page_max = 10
    let page_count = len(g:commands_list) / page_max
    let start = page_max * a:page
    let end = start + (page_max - 1) " last some idx
    let line_buf = ["page: " .. a:page]
    let idx = 0
    for item in g:commands_list[start:end]
        call add(line_buf, StrFmt(fmtter, idx - start, item[0]))
        let idx += 1
    endfor
    let [pgup_idx, pgdn_idx, pggoto_idx] = [idx + 0, idx + 1, idx + 2]
    call add(line_buf, StrFmt(fmtter, pgup_idx, 'page up'))
    call add(line_buf, StrFmt(fmtter, pgdn_idx, 'page down'))
    call add(line_buf, StrFmt(fmtter, pggoto_idx, 'page goto'))
    echon join(line_buf, "\n")
    let input_number = InputRangeNumber("select number> ", 0, pggoto_idx)
    echon "\n"
    if input_number == pgup_idx
        call Commands(a:page - 1)
    elseif input_number == pgdn_idx
        call Commands(a:page + 1)
    elseif input_number == pggoto_idx
        call Commands(InputRangeNumber("goto page> ", 0, page_count))
    else
        call g:commands_list[input_number + start][1]()
    endif
endfunction
" End {{{1
" }}}
