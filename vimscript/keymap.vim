" 符号转换 {{{1
noremap! #x \
noremap! #& \|
noremap! #h \|
noremap! <expr> #a '\|\| '
map! #A #a
noremap! #H \|
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

imap #q [
imap #w {
imap #Q [
imap #W {
cnoremap #q []<Left>
cnoremap #w {}<Left>
cnoremap #Q []<Left>
cnoremap #W {}<Left>
noremap! #e <><Left>
noremap! #E <><Left>
noremap! #< <><Left>
noremap! #> <><Left>
imap #B #b

inoremap ( ()<Left>
inoremap [ <cmd>call <SID>insert_pair('[]')<cr>
inoremap { <cmd>call <SID>insert_pair('{}', 1)<cr>
function! s:insert_pair(pair, indent = v:false)
    let line = getline('.')
    let i = col('.') - 1
    let eol = col('$')
    let left = i ? line[:i-1] : ''
    let right = line[i:]
    call setline(line('.'), left.a:pair.right)
    let pos = getpos('.')
    if a:indent | exe 'norm!==' | endif
    let offset = col('$') - eol - 1
    let pos[2] += offset
    call setpos('.', pos)
endfunction
function! s:double_quote()
    let col = col('.')-1
    let pos = getpos('.')
    let line = getline('.')

    let pos[2] += 1

    let left = col ? line[:col-1] : ''
    let right = line[col:]

    if left =~ '\v%(^|[^\\])%(\\\\)*\\$' || &filetype == 'vim' && left =~ '^ *$'
        call setline(line('.'), left.'"'.right)
        call setpos('.', pos)
        return
    endif

    if line[col:] =~ '^"'
        call setpos('.', pos)
        return
    endif

    if col >= 2 && line[col-2:] =~ '^""'
        call setline(line('.'), left.'""""'.right)
        call setpos('.', pos)
        return
    endif

    call setline(line('.'), left.'""'.right)
    call setpos('.', pos)
endfunction
inoremap " <cmd>call <SID>double_quote()<cr>
" 快捷符号映射 {{{1
noremap! #lk ->
noremap! #Lk ->
noremap! #LK ->

noremap! #kl =>
noremap! #Kl =>
noremap! #KL =>

cnoremap #i ""<Left>
cnoremap #I ""<Left>
cnoremap #o ''<Left>
cnoremap #O ''<Left>
cnoremap #m ``<Left>
cnoremap #M ``<Left>
imap #i "
inoremap #I <cmd>call <SID>insert_pair('""')<cr>
inoremap #o <cmd>call <SID>insert_pair("''")<cr>
inoremap #O <cmd>call <SID>insert_pair("''")<cr>
inoremap #m <cmd>call <SID>insert_pair('``')<cr>
inoremap #M <cmd>call <SID>insert_pair('``')<cr>
noremap! #n +
noremap! #u =
noremap! #N +
noremap! #U =

nmap Q A
xmap Q A

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

snoremap <cr> <esc>
smap <c-n> <bs><c-n>
smap <c-p> <bs><c-p>
smap <tab> <bs><tab>
smap <S-tab> <bs><S-tab>
smap <c-b> <esc>i
smap <c-f> <esc>a

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
noremap! <C-x> <Del>
" paste start
noremap! <silent> #cf <C-o>:set paste eventignore=TextChangedI,TextChangedP,InsertChange,InsertCharPre<cr>

nnoremap <c-h> %
onoremap <c-h> %
xnoremap <c-h> %
onoremap m %
xnoremap m %

" 快速普通回车新行
inoremap <expr> <c-o> (col('.')>=col('$')?'':'<end>').'<c-g>u<cr>'

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
xnoremap & @@

nnoremap <leader>g :registers<cr>

nnoremap <expr> <leader> ''

" 省的每次列插入还要按一下块选择
xnoremap <expr> I mode()!~#'<c-v>' ? '<c-v>I' : 'I'
xnoremap <expr> A mode()!~#'<c-v>' ? '<c-v>A' : 'A'

" 交换两行, 省的多按一次d
nnoremap <expr> dp &diff?'dp':'ddp'
" 重复行, 省的多按一次y
nnoremap yp yyp

nnoremap <expr> gl &wrap?':<c-u>set nowrap<cr>':':<c-u>set wrap<cr>'

" 快速括号
exe 'xnoremap <leader>( c()<Left><esc>p'
exe 'xnoremap <leader>[ c[]<Left><esc>p'
exe 'xnoremap <leader>{ c{}<Left><esc>p'
exe 'xnoremap <leader><lt> c<lt>><Left><esc>p'

" I-Mode M-Fn {{{
imap <M-F1>  <c-g>u<esc><F1>
imap <M-F2>  <c-g>u<esc><F2>
imap <M-F3>  <c-g>u<esc><F3>
imap <M-F4>  <c-g>u<esc><F4>
imap <M-F5>  <c-g>u<esc><F5>
imap <M-F6>  <c-g>u<esc><F6>
imap <M-F7>  <c-g>u<esc><F7>
imap <M-F8>  <c-g>u<esc><F8>
imap <M-F9>  <c-g>u<esc><F9>
imap <M-F10> <c-g>u<esc><F10>
imap <M-F11> <c-g>u<esc><F11>
imap <M-F12> <c-g>u<esc><F12>
" }}}
" 驼峰蛇形转换 {{{
" remap to object mode
xmap gs <esc>gsgv
xmap gS <esc>gSgv
xmap gc <esc>gcgv
xmap gC <esc>gCgv

nnoremap <expr> gs <SID>snake_and_camel_object('Camel2snake', 0)
nnoremap <expr> gS <SID>snake_and_camel_object('Camel2snake', 1)
nnoremap <expr> gc <SID>snake_and_camel_object('Snake2Camel', 0)
nnoremap <expr> gC <SID>snake_and_camel_object('Snake2Camel', 1)

onoremap gs _
onoremap gS _
onoremap gc _
onoremap gC _

function! s:snake_and_camel_object(name, upper)
    let g:snake_and_camel_object_name = a:name
    let g:snake_and_camel_object_upper = a:upper
    set opfunc=<SID>snake_and_camel_post_object
    return 'g@'
endfunction

function! s:snake_and_camel_post_object(type)
    let F = funcref(g:snake_and_camel_object_name)
    let F1 = {line, start -> F(line, g:snake_and_camel_object_upper, start)}
    let bg = [line("'["), col("'[")-1]
    let ed = [line("']"), col("']")-1]

    if a:type == "line"
        for line in range(bg[0], ed[0])
            call setline(line, F1(getline(line), 0))
        endfor
    elseif a:type == "block"
        let [bgi, edi] = sort([bg[1], ed[1]])
        for line in range(bg[0], ed[0])
            let text = getline(line)
            call setline(line, F1(text[:edi], bgi) . text[edi+1:])
        endfor
    elseif a:type == "char"
        if bg[0]+1 <= ed[0]-1
            for line in range(bg[0]+1, ed[0]-1)
                call setline(line, F1(getline(line), 0))
            endfor
        endif

        let text = getline(bg[0])
        if bg[0] == ed[0]
            call setline(bg[0], F1(text[:ed[1]], bg[1]) . text[ed[1]+1:])
        else
            call setline(bg[0], F1(text, bg[1]))
            let text = getline(ed[0])
            call setline(ed[0], F1(text[:ed[1]], 0) . text[ed[1]+1:])
        endif
    endif
endfunction
" }}}
" Swap visual from last changed or yanked {{{
function s:swap_last_changed_or_yanked_object()
    let g:swap_last_changed_or_yanked_plin = line("'[")
    let g:swap_last_changed_or_yanked_pcol = charcol("'[")
    set opfunc=<SID>swap_last_changed_or_yanked_post_object
    return 'g@'
endfunction
function! s:swap_last_changed_or_yanked_post_object(type)
    let [clin, ccol] = [line("'["), charcol("'[")]
    let [elin, ecol] = [line("']"), charcol("']")]
    let plin = g:swap_last_changed_or_yanked_plin
    let pcol = g:swap_last_changed_or_yanked_pcol
    let L = { n -> n>1 ? $'0{n-1}l' : '0' }

    if a:type == "line"
        let yanks = split(@", '\n')
        let lines = getline(clin, elin)
        call append(elin, yanks)
        call deletebufline("", clin, elin)
        if plin > clin | let plin += len(yanks)-len(lines) | endif
        call append(plin-1, lines)
    else
        if clin < plin && a:type != "block"
            let plin += count(@", "\n") - (elin-clin)
        endif

        let cp = pcol < charcol([plin, '$']) ? 'P' : 'p'
        let v = a:type == "block" ? "\<c-v>" : 'v'

        if clin == plin && ccol < pcol
            let pcol += strcharlen(@") - (ecol-ccol+1)
        endif
        exe $"norm!{clin}G{L(ccol)}{v}{elin}G{L(ecol)}p{plin}G{L(pcol)}{cp}\<c-o>"
        return
    endif
endfunction
nnoremap <expr> <c-p> <SID>swap_last_changed_or_yanked_object()
xmap <c-p> <esc><c-p>gv
" }}}
" next or prev buffer {{{
command! -count -bar BufferNext execute "bnext " .. (<range> ? <line2>-<line1> + 1 : "")
command! -count -bar BufferPrev execute "bprevious " .. (<range> ? <line2>-<line1> + 1 : "")
nnoremap <silent> gb :BufferNext<Cr>
nnoremap <silent> gB :BufferPrev<Cr>
" }}}
" 在底行模式下, 也就是`normal_:`下, 输入当前文件的目录{{{
cnoremap <C-s> <C-r>=empty(expand("%:h"))?".":fnameescape(expand("%:h"))<CR>/
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
    echo "fenc={} ff={} ft={} {}eol{}"->StrFmt(
                \   &fenc->strlen() ? &fenc : 'NONE',
                \   &ff,
                \   &ft,
                \   &eol  ? '' : 'no',
                \   &bomb ? ' bomb' : '',
                \   )
    echo ">"
    exe "norm!g\<c-g>"
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
" 扩展z系列键 {{{
nnoremap z; zzg_
xnoremap z; zzg_
nmap zn z;
xmap zn z;
omap zn z;
" }}}
" 可视模式边缘跳转 {{{
function! s:visual_side_jump_col()
    let [_,      vnum, col, off] = getpos('v')
    let [bufnum, lnum, _,   _] = getpos('.')
    call setpos('.', [bufnum, lnum, col+off, 0, col+off])
endfunction
function! s:visual_side_jump_line()
    let [_,      lnum, _,   _] = getpos('v')
    let [bufnum, _,    col, off] = getpos('.')
    call setpos('.', [bufnum, lnum, col+off, 0])
endfunction
xnoremap <c-r> <cmd>call <SID>visual_side_jump_col()<cr>
xnoremap <c-t> <cmd>call <SID>visual_side_jump_line()<cr>
" }}}
" 退出键 {{{
function! s:confirm_exit_all()
    echon "Input Tab,#,',\",c,q to exit all:"
    let result = getcharstr()
    if result =~? "[\<tab>'\"cq]"
        qa!
    endif
endfunction
nnoremap <F12> <cmd>call <SID>confirm_exit_all()<cr>
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

xnoremap . ^
onoremap z. ^
onoremap z; g_
"}}}
" 选区文本对象 {{{
onoremap gv :<c-u>norm!gv<cr>
"}}}
" 缩进文本对象 {{{
function! TextObjectIndentBlock(out, rev=v:false, goto=v:false)
    let Mov = {n -> n..'G'}
    let [bg, ed, sbg, sed] = [line('.'), line('v')]
                \ ->sort({a, b -> a-b})
                \ ->repeat(2)
    let meta = a:rev ? ed : bg
    let tail = (line('.') != meta) != a:rev
    let eof = line('$')
    let Check = {n -> n >= 1 && n <= eof}

    let ranged = bg != ed && !a:out
    if !a:rev
        let indent = indent(nextnonblank(bg))
        let eed = nextnonblank(ed + ranged)
        if indent(eed) == indent | let ed = eed | en
    else
        let indent = indent(prevnonblank(ed))
        let ebg = prevnonblank(bg - ranged)
        if indent(ebg) == indent | let bg = ebg | en
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
            while Check(ed+1)
                let n = ed+1
                if getline(n) =~# '^\s*$'
                    let ed += 1
                elseif indent(n) == indent
                    let ed = n
                    if a:out | let sed = n | endif
                endif
                break
            endwhile
        else
            while Check(bg-1)
                let n = bg-1
                if getline(n) =~# '^\s*$'
                    let bg -= 1
                elseif indent(n) == indent
                    let bg = n
                    if a:out | let sbg = n | endif
                endif
                break
            endwhile
        endif
    endfor

    if a:goto
        return ":\<C-u>norm!"
                    \ . (a:rev ? Mov(sbg) . '_' : Mov(sed) . 'g_')
                    \ . "\<CR>"
    endif
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
nnoremap <silent><expr> gin TextObjectIndentBlock(v:false, v:false, v:true)
nnoremap <silent><expr> gan TextObjectIndentBlock(v:true , v:false, v:true)
nnoremap <silent><expr> gim TextObjectIndentBlock(v:false, v:true , v:true)
nnoremap <silent><expr> gam TextObjectIndentBlock(v:true , v:true , v:true)
nmap <silent> g2in 2gin
nmap <silent> g2an 2gan
nmap <silent> g2im 2gim
nmap <silent> g2am 2gam

nmap <silent> g3in 3gin
nmap <silent> g3an 3gan
nmap <silent> g3im 3gim
nmap <silent> g3am 3gam

nmap <silent> g4in 4gin
nmap <silent> g4an 4gan
nmap <silent> g4im 4gim
nmap <silent> g4am 4gam
" }}}
" 缩进列对象 {{{
function! s:indent_top()
    let col = min([indent('.'), col('.')-1])
    let line = line('.')
    while line > 1
        let line -= 1
        if indent(line) <= col
            return $'{line}G'
        endif
    endwhile
    return ''
endfunction
nnoremap <expr> <c-n> <SID>indent_top()
xnoremap <expr> <c-n> <SID>indent_top()
" }}}
" Disable Empty Search And Prev Search {{{1
"nnoremap <expr> n strlen(@/) > 0 ? "n" : execute('let@/=get(g:,"prev_search","")\|let v:searchforward=get(g:,"prev_search_forward",1)').(@/->strlen()?'n':'')
"nnoremap <expr> N strlen(@/) > 0 ? "N" : execute('let@/=get(g:,"prev_search","")\|let v:searchforward=get(g:,"prev_search_forward",1)').(@/->strlen()?'N':'')
" Leader maps {{{1

" open terminal or update NERDTree
nnoremap <leader>t :if&ft!=#'nerdtree'\|exe'terminal'\|el\|exe'NERDTreeRefreshRoot'\|en<cr>
" NERDTree Toggle
nnoremap <leader>T :if&ft!=#'nerdtree'\|NERDTreeCWD\|el\|exe'NERDTreeToggle'\|en<cr>

" Windows control {{{1
nnoremap <silent> <leader><leader> <C-w><C-w>

" moves{{{
nnoremap <silent> <leader>H <C-w>h
nnoremap <silent> <leader>j <C-w>j
nnoremap <silent> <leader>k <C-w>k
nnoremap <silent> <leader>l <C-w>l
nnoremap <silent> <leader>p <C-w>p
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
        let opts = '-Wall -Wextra'
        return ['time gcc %s %p -o %f %F && time %f %F', opts, outf, a, outf, b]
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
        if expand("%:t") ==# "main.rs" || expand("%:p:h") =~# 'src/bin$'
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
xnoremap <expr> <cr> foldclosed('.') != -1
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
"inoremap <nowait><silent><expr><C-k> <SID>snippet_jump(v:false,{-> ''}, "\<lt>C-r>=")
"inoremap <nowait><silent><expr><C-j> <SID>snippet_jump(v:true, {-> ''}, "\<lt>C-r>=")
"snoremap <nowait><silent><expr><C-k> <SID>snippet_jump(v:false,{-> ''}, "\<lt>esc>")
"snoremap <nowait><silent><expr><C-j> <SID>snippet_jump(v:true, {-> ''}, "\<lt>esc>")
"xnoremap <nowait><silent><expr><C-k> <SID>snippet_jump(v:false,{-> ''}, "\<lt>esc>")
"xnoremap <nowait><silent><expr><C-j> <SID>snippet_jump(v:true, {-> ''}, "\<lt>esc>")

" End {{{1
" }}}
