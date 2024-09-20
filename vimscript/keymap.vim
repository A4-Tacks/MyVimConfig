" 符号转换 {{{1
noremap! #x \
noremap! #& \|
noremap! #h \|
noremap! #a \|\|
noremap! #H \|
noremap! #A \|\|
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
noremap! #Q []<Left>
noremap! #W {}<Left>
noremap! #E <><Left>
noremap! #< <><Left>
noremap! #> <><Left>

inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>
inoremap " ""<Left>
" 快捷符号映射 {{{1
noremap! #lk ->
noremap! #Lk ->
noremap! #LK ->

noremap! #kl =>
noremap! #Kl =>
noremap! #KL =>

noremap! #i ""<Left>
noremap! #I ""<Left>
noremap! #o ''<Left>
noremap! #O ''<Left>
noremap! #m ``<Left>
noremap! #M ``<Left>
noremap! #n +
noremap! #u =
noremap! #I ""<Left>
noremap! #I ""<Left>
noremap! #O ''<Left>
noremap! #O ''<Left>
noremap! #M ``<Left>
noremap! #M ``<Left>
noremap! #N +
noremap! #U =

" Fold
inoremap #zk {{{
inoremap #zl }}}
inoremap #Zk {{{
inoremap #Zl }}}
inoremap #zK {{{
inoremap #zL }}}
inoremap #ZK {{{
inoremap #ZL }}}
" 辅助按键 {{{1
inoremap <silent> jk <Esc>
snoremap <silent> jk <Esc>

" terminal
" term 回 vim
tnoremap <C-w>e <C-\><C-n>
tnoremap <C-w><C-e> <C-\><C-n>

" 按末尾相对行数而不是合并行数来计范围的行合并 {{{
command -range -bang -bar SilentRelativeJoin
            \ if <range> | sil <line1>,<line2> RelativeJoin<bang>
            \ | el | sil RelativeJoin<bang>
            \ | en
command -range -bang -bar RelativeJoin
            \ | execute 'norm!'.(<range>?<line2>-<line1>+2:'')
            \   .(<bang>0?'gJ':'J')

nnoremap <silent> J  :SilentRelativeJoin<cr>
nnoremap <silent> gJ :SilentRelativeJoin!<cr>
" }}}

" fix term keymap{{{
tnoremap <kHome> <Home>
tnoremap <kEnd> <End>
tnoremap <kPageUp> <PageUp>
tnoremap <kPageDown> <PageDown>
"}}}

" del
inoremap <C-l> <Del>
" paste start
noremap! <silent> #cf <C-o>:set paste eventignore=TextChangedI,TextChangedP,InsertChange,InsertCharPre<cr>

" emacs{{{
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
"}}}
" line end input{{{
inoremap #; <End>;
inoremap #: <End>;
inoremap #, <End>,
inoremap #. <End>,
"}}}
nnoremap & @@

nnoremap <leader>g :registers<cr>

" 省的每次列插入还要按一下块选择
xnoremap <expr> I (mode()=~#'V' ? '0' : '').(mode()!~#'<c-v>' ? '<c-v>I' : 'I')
xnoremap <expr> A (mode()=~#'V' ? '$' : '').(mode()!~#'<c-v>' ? '<c-v>A' : 'A')

" next or prev buffer {{{
command! -count -bar BufferNext execute "bnext " .. (<range> ? <line2>-<line1> + 1 : "")
command! -count -bar BufferPrev execute "bprevious " .. (<range> ? <line2>-<line1> + 1 : "")
nnoremap <silent> gb :BufferNext<Cr>
nnoremap <silent> gB :BufferPrev<Cr>
" }}}
" 在底行模式下, 也就是`normal_:`下, 输入当前文件的目录{{{
cnoremap <C-s> <C-r>=fnameescape(expand("%:h"))<CR>/
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
"}}}
" 可视模式下快捷搜索{{{
xnoremap g/ y/<c-r>"
"}}}
" 缓冲区信息键强化 {{{
function! ShowBufferInfo()
    let fname = buffer_name()
    let flag = (&modified||!&modifiable?' ['.(&modified?'+':'').(&modifiable?'':'-').']':'')
                \.(&readonly?' [RO]':'')
    echo "FileName: {!r}{}"->StrFmt(fname, flag)
    if fname->filereadable() || fname->filewritable()
        echo "{}{} {}B {} {}"->StrFmt(
                    \ fname->getftype()[0],
                    \ fname->getfperm(),
                    \ fname->getfsize(),
                    \ fname->getfsize()->SizeFmt('B'),
                    \ "%Y-%m-%d %H:%M:%S"->strftime(fname->getftime()),
                    \ )
    endif
    echo "Line: {}/{} --{}%--"->StrFmt(
                \   line('.'), line('$'),
                \   float2nr((line('.')+0.0) / line('$') * 100))
    echo "fenc:{} ff:{} eol:{} ft:{}"->StrFmt(
                \   &fenc->strlen() ? &fenc : 'NONE',
                \   &ff,
                \   &eol,
                \   &ft,
                \   )
endfunction
nnoremap <C-g> :call ShowBufferInfo()<cr>
" }}}
" 快速buffer切换 {{{
function! s:goto_selected_buffer()
    let id = input('input buffer id> ')
    if !id | return | endif
    execute 'buffer'.id
endfunction
nnoremap <silent> <leader>b :ls \|call <SID>goto_selected_buffer()<cr>
nnoremap <silent> <leader>B :ls!\|call <SID>goto_selected_buffer()<cr>
" }}}
" 在非fFtT情况下, 分号可以表示冒号 {{{
"nnoremap <expr> ; AlphaGotoNext(';')
"nnoremap <expr> , AlphaGotoNext(',', 1)
"
"xnoremap <expr> ; AlphaGotoNext(';')
"xnoremap <expr> , AlphaGotoNext(',', 1)
"
"
"nnoremap <expr> f AlphaGoto('f')
"nnoremap <expr> F AlphaGoto('F')
"nnoremap <expr> t AlphaGoto('t')
"nnoremap <expr> T AlphaGoto('T')
"
"xnoremap <expr> f AlphaGoto('f')
"xnoremap <expr> F AlphaGoto('F')
"xnoremap <expr> t AlphaGoto('t')
"xnoremap <expr> T AlphaGoto('T')


let g:after_alpha_goto_do = 0

aug AlphaGoto
    au!
    au CursorMoved *
                \   if g:after_alpha_goto_do == 2
                \           && reltimefloat(reltime())
                \               - g:after_alpha_goto_time
                \               > 0.3
                \ |     let g:after_alpha_goto_do = 0
                \ | el
                \ |     let g:after_alpha_goto_do -= g:after_alpha_goto_do > 0
                \ | en
aug end

function! AlphaGoto(cmd)
    while v:true
        redraw
        echon "\r" . a:cmd . '> '
        let ch = getcharstr()
        if ch != "\<CursorHold>"
            break
        endif
    endwhile
    echon ch
    let g:after_alpha_goto_do = 2
    let g:after_alpha_goto_time = reltimefloat(reltime())
    return a:cmd .. ch
endfunction
function! AlphaGotoNext(cmd, always = 0)
    if !get(g:, 'after_alpha_goto_do') && !a:always
        return ':'
    endif

    let g:after_alpha_goto_do = 2
    let g:after_alpha_goto_time = reltimefloat(reltime())
    return a:cmd
endfunction
" }}}
" 代替原本的井号星号配合高亮搜索 {{{
function! s:search_cursor(next, to_norm = '')
    if !exists('g:cursor_word_regex') | return a:next ? '*' : '#' | endif
    let @/ = g:cursor_word_regex
    return empty(@/) ? '' : a:to_norm.(a:next ? '/' : '?')."\<cr>"
endfunction

nnoremap <expr> # <SID>search_cursor(v:false)
nnoremap <expr> * <SID>search_cursor(v:true)
xnoremap <expr> # <SID>search_cursor(v:false,"\<lt>esc>")
xnoremap <expr> * <SID>search_cursor(v:true,"\<lt>esc>")
" }}}

" 范围选择 {{{1
function! RangeMapDefine(key, str) " {{{
    execute 'onoremap <silent> a' .. a:key .. ' a' .. a:str
    execute 'xnoremap <silent> a' .. a:key .. ' a' .. a:str
    execute 'onoremap <silent> i' .. a:key .. ' i' .. a:str
    execute 'xnoremap <silent> i' .. a:key .. ' i' .. a:str
endfunction " }}}
" 一些快捷习惯性映射{{{
call RangeMapDefine('k', '(')
call RangeMapDefine('q', '[')
call RangeMapDefine('w', '{')
call RangeMapDefine('e', '<')
call RangeMapDefine('i', '"')
call RangeMapDefine('o', "'")
call RangeMapDefine('m', '`')
call RangeMapDefine('M', '`')
call RangeMapDefine('Q', 'W') " 原本的WORD
call RangeMapDefine('E', 'w')
"}}}
" 软行文本对象 {{{
xnoremap <silent> iv :<C-u>norm! v_og_<CR>
onoremap <silent> iv :<C-u>norm! v_og_<CR>
xnoremap <silent> av :<C-u>norm! v0og_<CR>
onoremap <silent> av :<C-u>norm! v0og_<CR>
"}}}
" 缩进文本对象 {{{
function! TextObjectIndentBlock(out, rev = v:false)
    let Mov = {n -> n..'G'}
    let [bg, ed, sbg, sed] = [line('.'), line('v')]
                \ ->sort({a, b -> a-b})
                \ ->repeat(2)
    let meta = a:rev ? ed : bg
    let tail = (line('.') != meta) != a:rev
    let eof = line('$')
    let Check = {n -> n >= 1 && n <= eof}

    if !a:rev
        let indent = indent(nextnonblank(bg))
        if bg == ed | let ed = nextnonblank(ed) | endif
    else
        let indent = indent(prevnonblank(ed))
        if bg == ed | let bg = prevnonblank(bg) | endif
    endif

    for _ in range(v:count1)
        if !a:rev
            while Check(ed+1)
                let n = ed+1
                if getline(n) =~# '^\s*$'
                    let ed = n
                elseif indent(n) > indent
                    let [ed, sed] = [n, n]
                else | break | endif
            endwhile
        else
            while Check(bg-1)
                let n = bg-1
                if getline(n) =~# '^\s*$'
                    let bg = n
                elseif indent(n) > indent
                    let [bg, sbg] = [n, n]
                else | break | endif
            endwhile
        endif

        if !a:rev
            if a:out
                while Check(ed+1)
                    let n = ed+1
                    if getline(n) =~# '^\s*$'
                        let ed += 1
                    elseif indent(n) == indent
                        let [ed, sed] = [n, n]
                    endif
                    break
                endwhile
            endif
        else
            if a:out
                while Check(bg-1)
                    let n = bg-1
                    if getline(n) =~# '^\s*$'
                        let bg -= 1
                    elseif indent(n) == indent
                        let [bg, sbg] = [n, n]
                    endif
                    break
                endwhile
            endif
        endif
    endfor

    return ":\<C-u>norm! V".Mov(sbg).'o'.Mov(sed)
                \.(tail?'g_':'g_o')."\<CR>"
endfunction
xnoremap <silent><expr> in TextObjectIndentBlock(v:false)
onoremap <silent><expr> in TextObjectIndentBlock(v:false)
xnoremap <silent><expr> an TextObjectIndentBlock(v:true)
onoremap <silent><expr> an TextObjectIndentBlock(v:true)
xnoremap <silent><expr> im TextObjectIndentBlock(v:false, v:true)
onoremap <silent><expr> im TextObjectIndentBlock(v:false, v:true)
xnoremap <silent><expr> am TextObjectIndentBlock(v:true , v:true)
onoremap <silent><expr> am TextObjectIndentBlock(v:true , v:true)
"}}}
" Disable Empty Search And Prev Search {{{1
nnoremap <expr> n strlen(@/) > 0 ? "n" : execute('let@/=get(g:,"prev_search","")\|let v:searchforward=get(g:,"prev_search_forward",1)').(@/->strlen()?'n':'')
nnoremap <expr> N strlen(@/) > 0 ? "N" : execute('let@/=get(g:,"prev_search","")\|let v:searchforward=get(g:,"prev_search_forward",1)').(@/->strlen()?'N':'')
" Leader maps {{{1

" open terminal or update NERDTree
nnoremap <leader>t :if&ft!=#'nerdtree'\|exe'terminal'\|el\|exe'NERDTreeRefreshRoot'\|en<cr>
" NERDTree Toggle
nnoremap <leader>T :if&ft!=#'nerdtree'\|NERDTreeCWD\|el\|exe'NERDTreeToggle'\|en<cr>

" Windows control {{{1
nnoremap <silent> <leader><leader> <C-w><C-w>

" moves{{{
nnoremap <silent> <leader>h <C-w>h
nnoremap <silent> <leader>j <C-w>j
nnoremap <silent> <leader>k <C-w>k
nnoremap <silent> <leader>l <C-w>l
"}}}
" split{{{
nnoremap <silent> <leader>s <C-w>s
nnoremap <silent> <leader>v <C-w>v
"}}}
" Old windows control {{{
nnoremap <silent> <leader>M <c-w>_<c-w>\|
nnoremap <silent> <leader>m <c-w>=
nnoremap <silent> <leader>= <c-w>3+
nnoremap <silent> <leader>- <c-w>3-
nnoremap <silent> <leader>+ <c-w>6>
nnoremap <silent> <leader>_ <c-w>6<
"}}}
" windows control mode {{{
nnoremap <silent> m :call StartWindowControl()<cr>
nnoremap <silent> <c-w>m :call StartWindowControl()<cr>
nnoremap <silent> <c-w><c-m> :call StartWindowControl()<cr>
tnoremap <silent> <c-w>m <cmd>call StartWindowControl()<cr>
tnoremap <silent> <c-w><c-m> <cmd>call StartWindowControl()<cr>
function! StartWindowControl()
    let extra_cmd = {
                \ 'M': "norm!\<c-w>_\<c-w>|",
                \ 'm': "norm!\<c-w>=",
                \ "'": 'exe"norm!m".getcharstr()',
                \ ':': 'cal feedkeys(" :")',
                \ 'gb': 'bn',
                \ 'gB': 'bp',
                \ }
    let num = ''
    let oprefix = ''
    while v:true
        let ch = getcharstr()
        if ch =~# "[\<C-w>\<esc>\<c-m> ia]"
            return
        elseif num != '' && ch =~# '\d'
            let num *= 10
            let num += ch->str2nr()
        elseif ch =~# '\d'
            let num = ch->str2nr()
        elseif oprefix->empty() && ch ==# 'g'
            let oprefix = 'g'
        else
            if extra_cmd->has_key(oprefix.ch)
                let cmd = extra_cmd[oprefix.ch]
            else
                let cmd = "norm \<C-w>".num.oprefix.ch
            endif
            execute cmd
            echo cmd
            redraw
            let num = ''
            let oprefix = ''
        endif
    endwhile
endfunction
" }}}

" quit
nnoremap <silent> <leader>q <C-w>q

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
        return ['time python3 %p %S', a:args]
    endfunction
    function! s:clang(args) dict " -> str {{{2
        let [a, b] = SplitLevelsArgs(a:args)
        let outf = expand("%:p:r") .. ".out"
        return ['time gcc %p -o %f %F && time %f %F', outf, a, outf, b]
    endfunction
    function! s:sh(args) dict " -> str {{{2
        let [a, b] = SplitLevelsArgs(a:args)
        return ['time bash %F %p %F', a, b]
    endfunction
    function! s:vim(args) dict " -> str {{{2
        let [a, b] = SplitLevelsArgs(a:args)
        return ['time vim %F -u %p %F', a, b]
    endfunction
    function! s:rust(args) dict " -> str {{{2
        let [a, b] = SplitLevelsArgs(a:args)
        if expand("%:t") ==# "main.rs"
            return ['time cargo run %F -- %F', a, b]
        else
            return ['time cargo test %F -- %F', a, b]
        endif
    endfunction
    function! s:awk(args) dict " -> str {{{2
        let [a, b] = SplitLevelsArgs(a:args)
        return ['time awk %F -f %p %F', a, b]
    endfunction
    function! s:js(args) dict " -> str {{{2
        let [a, b] = SplitLevelsArgs(a:args)
        return ['time node %F %p %F', a, b]
    endfunction
    function! s:ts(args) dict " -> str {{{2
        let [a, b] = SplitLevelsArgs(a:args)
        return ['time ts-node %F -- %p %F', a, b]
    endfunction
    function! s:lua(args) dict " -> str {{{2
        let [a, b] = SplitLevelsArgs(a:args)
        return ['time lua %F -- %p %F', a, b]
    endfunction
    function! s:fish(args) dict " -> str {{{2
        let [a, b] = SplitLevelsArgs(a:args)
        return ['time fish %F -- %p %F', a, b]
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
                \"typescript": funcref("s:ts"),
                \"lua": funcref("s:lua"),
                \"fish": funcref("s:fish"),
                \}
    " }}}2
endfunction
nnoremap <silent> <F5> :if &modified \|\| !filewritable(expand('%')) \| write \| else \| call CompileRun(input("args> ")) \| endif<CR>

let g:runer = Runer()

function! CompileRun(args_text) " {{{
    if index(keys(g:runer), &filetype) == -1
        echo &filetype .. " not in lang config. " .. string(keys(g:runer))
        return v:none
    endif
    let args = ShlexSplit(a:args_text)
    execute "!set -x;" .. 'echo -ne "\e[0m\e[' .. &lines .. 'S\e[H";'
                \.. funcref('ShCmdFmt', g:runer[&filetype](args))()
endfunction " }}}

" Translate {{{1
nnoremap <F7> yy:call Appends(line(".")-1, Translate(@@, ["-t", "zh", "-m", "%s%n", "-"]))<Cr>
nnoremap <C-F7> yy:call Appends(line(".")-1, Translate(@@, ["-t", "en", "-m", "%s%n", "-"]))<Cr>
xnoremap <F7> y:call Appends(line(".")-1, Translate(@@, ["-t", "zh", "-m", "%s%n", "-"]))<Cr>
xnoremap <C-F7> y:call Appends(line(".")-1, Translate(@@, ["-t", "en", "-m", "%s%n", "-"]))<Cr>
xnoremap <F8> :%!baidu_fanyi -t zh -m \%1s\%n\%0s\%n -<Cr>
xnoremap <C-F8> :%!baidu_fanyi -t en -m \%1s\%n\%0s\%n -<Cr>
" 反复翻译
xnoremap <A-F8> :%!baidu_fanyi -t en -m \%0s\%n -\|baidu_fanyi -t zh -m \%1s\%n\%0s\%n -<Cr>

" Tab map {{{1

noremap! #<Tab> <Tab>

" 如果启用了coc, 那这个应该会被覆盖
inoremap <expr><silent> <Tab> pumvisible() ? "\<C-n>"
            \ : col('.') == 1 \|\| match(getline('.')[col('.')-2:], '^\s') != -1
            \     ? "\<tab>"
            \     : getline('.')
            \           ->strcharpart(charcol('.')-2, 1)
            \           ->match('^\<.\>') != -1
            \             ? "\<c-n>"
            \             : "\<tab>"
inoremap <expr><silent> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Enter map {{{1
" Insert mode Enter {{{2
function! EnterInsert()
    if pumvisible()
        if complete_info().selected == -1
            " 没有选中项目时, 直接选择首个项目
            return "\<c-n>\<esc>a"
        endif
        " 补全菜单展开则直接选择
        return "\<c-p>\<c-n>\<esc>a"
    endif
    let l:COL = col(".")
    let l:LINE = getline(".")
    if index(["()", "[]", "{}"], l:LINE[l:COL-2:l:COL-1]) != -1
        " 展开括号
        return "\<cr>\<esc>==ko"
    endif
    return "\<Cr>"
endfunction
inoremap #<Cr> <Cr>
inoremap <expr> <Cr> EnterInsert()

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
vnoremap <expr> <cr> foldclosed('.') != -1
            \ ? execute('foldopen!')
            \ : "\<cr>"

" snippets jump and skip out of braces {{{1
let s:braces = #{next: '^.\{-}[)\]}>"'']', back: '^.\{-}[([{<)\]}>"'']'}

function! s:snippet_jump(is_next, raw, enter)
    if FunExists('coc#jumpable') && coc#jumpable()
        let c = a:is_next ? a:enter."coc#snippet#jump(1,0)\<CR>"
                        \ : a:enter."coc#snippet#jump(0,0)\<CR>"
        return c
    endif

    let vis = mode() =~? '^[vs]'
    if a:is_next
        let str = strcharpart(getline('.'), charcol('.')-1+vis)
        let str = matchstr(str, s:braces.next)
        if !empty(str)
            return repeat("\<Right>", strcharlen(str))
        endif
    else
        let str = strcharpart(getline('.'), 0, charcol('.')-1)
        let str = matchstr(reverse(str), s:braces.back)
        if !empty(str)
            return repeat("\<Left>", strcharlen(str))
        endif
    endif

    return a:raw()
endfunction
inoremap <nowait><silent><expr><C-k> <SID>snippet_jump(v:false,{-> ''}, "\<lt>C-r>=")
inoremap <nowait><silent><expr><C-j> <SID>snippet_jump(v:true, {-> ''}, "\<lt>C-r>=")
snoremap <nowait><silent><expr><C-k> <SID>snippet_jump(v:false,{-> ''}, "\<lt>esc>")
snoremap <nowait><silent><expr><C-j> <SID>snippet_jump(v:true, {-> ''}, "\<lt>esc>")
xnoremap <nowait><silent><expr><C-k> <SID>snippet_jump(v:false,{-> ''}, "\<lt>esc>")
xnoremap <nowait><silent><expr><C-j> <SID>snippet_jump(v:true, {-> ''}, "\<lt>esc>")

" End {{{1
" }}}
