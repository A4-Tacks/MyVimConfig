function! Translate(text, args) " {{{1
    return CliStdIn(a:text, ["baidu_fanyi"] + a:args)
endfunction
function! CliStdIn(text, args) " {{{1
    " text, cli args
    " text to stdin
    return system('echo ' . SystemString(a:text)
                \ . '|' . join(map(a:args[:], {k, v -> SystemString(v)})))
endfunction
function! Appends(line, tgt) " {{{1
    " 解决换行无法被追加的问题
    " 传入列表则追加每一行, 传入字符串则将行分割
    let type = type(a:tgt)
    let n = a:line
    if type == v:t_list
        for line in a:tgt
            call append(n, line)
            let n += 1
        endfor
    elseif type == v:t_string
        for line in split(a:tgt, "\n")
            call append(n, line)
            let n += 1
        endfor
    else
        echoerr "type " .. type .. " is not str or list"
    endif
endfunction
function! Py3Call(name, ...) " {{{1
    " py3eval 有一个很坑的坑, int和float会变成str
    return py3eval(a:name .. '(*vim.eval("a:000"))')
endfunction
function! SplitLongStr(string, len) " {{{1
    " len > 0
    let l:l = a:len - 3
    if l:l <= 0
        if strlen(a:string) > a:len
            return "..."[:a:len-1]
        else
            return a:string
        endif
    endif
    if strlen(a:string) > a:len
        return a:string[:l:l - 1] .. "..."
    endif
    return a:string
endfunction
function! BuildShellArgs(args) " {{{1
    let l:res = a:args[:]
    call map(l:res, {k, v -> FileNameToShell(v)})
    return join(l:res, " ")
endfunction
function! ShlexSplit(str, ...) " -> list {{{1
    return py3eval('shlex.split(vim.eval("a:str"))')
endfunction
function! GetCursorWord() " {{{1
    if mode() =~# "[vV\<C-v>]"
        let [_, vbgl, vbgc, _] = getpos('v')
        let [_, vedl, vedc, _] = getpos('.')
        if vbgl != vedl | return '' | endif
        if mode() =~# 'V'
            return [getline(vbgl), 'V']
        else
            if vbgc > vedc | let [vedc, vbgc] = [vbgc, vedc] | endif
            let line = getline(vbgl)
            let chw = line[vedc-1:]->matchend('.')
            let ed = chw == -1 ? "\n" : ''
            let vedc = max([1, chw]) + vedc - 1
            return [line[vbgc-1:vedc-1] . ed, 'v']
        endif
    endif
    let [ccol, line] = [charcol("."), line(".")]
    let bcol_idx = col(".") - 1 " byte column (cursor) index
    let line_text = getline(line)
    let to_col_text = reverse(strcharpart(line_text, 0, ccol))
    let idx = matchend(to_col_text, '^.\{-0,}\>')
    if idx == -1
        return ''
    endif
    let start = strlen(to_col_text) - idx
    let from_start_text = line_text[start:]
    let lend = matchend(from_start_text, '^.\{-0,}\>')
    if start + lend < bcol_idx
        " start + lend 为匹配词的末尾字符+1
        " 如果词末尾小于(光标位置-1) 则失配
        return ''
    endif
    return from_start_text[:lend - 1]
endfunction
function! FileNameToShell(name) " {{{1
    " 将 vim 中的文件名转义至shell不会有其它含义的字符, 且不会被vim的expand转义
    return substitute(fnameescape(a:name),
                \'\([();&>]\)', {x -> '\' .. x[1]}, 'g')
endfunction
function! VarInit(name, default) " {{{1
    if ! exists(a:name)
        execute "let " .. a:name .. " = a:default"
    endif
endfunction
function! SplitLevelsArgs(args) " -> list[list[str]; 2] {{{1
    " 切分两段参数, 如果没有给出段分割符`--`则默认最后一段
    let idx = index(a:args, "--")
    if idx == -1
        return [[], copy(a:args)]
    endif
    return [slice(a:args, 0, idx), a:args[idx+1:]]
endfunction
function! StrFmt(fmtter, ...) " {{{1
    return py3eval('str(vim.eval("a:fmtter")).format(*vim.eval("a:000"))')
endfunction
function! Assert(expr, msg = "assert field") " {{{1
    if ! a:expr
        echoerr a:msg .. ': ' .. a:expr
    endif
endfunction
function! InputRangeNumber(msg, ...) " {{{1
    " input number in [start, stop]
    if len(a:000) == 0
        return input(a:msg) + 0
    elseif len(a:000) == 1
        call Assert(0 <= a:1)
        return min([input(a:msg) + 0, a:1])
    elseif len(a:000) == 2
        call Assert(a:1 <= a:2)
        return min([max([input(a:msg) + 0, a:1]), a:2])
    else
        echoerr 'args length error: ' .. len(a:000)
    endif
endfunction
function! SelectLineNumberDisplay() " {{{1
    let lines_buf = []
    for i in range(4)
        let [nu, rnu] = [and(i, 1), i >> 1]
        call add(lines_buf, StrFmt("{}: number: {}, relativenumber: {}", i, nu, rnu))
    endfor
    echon join(lines_buf, "\n")
    let input_number = InputRangeNumber("select number> ", 3)
    let [&number, &relativenumber] = [and(input_number, 1), input_number >> 1]
endfunction
function! SystemString(x) " {{{1
    return "'" . substitute(a:x, "'", "'\\\\''", 'g') . "'"
endfunction
function! CType(mode, str) " {{{1
    " 将 c 类型 和 rs 类型转换
    " mode(0) c -> rs
    " mode(1) rs -> c
    if a:mode
        " rs to c
        return systemlist('cdecl-to-rsdecl -ac', a:str)
    else
        " c to rs
        return systemlist('cdecl-to-rsdecl -a', a:str)
    endif
endfunction
function! UpdateIndentLine() " {{{1
    let g:indentLine_ws = get(g:, 'indentLine_ws', ' ')
    let g:indentLine_char = get(g:, 'indentLine_char', '|')
    let g:indentLine_indentLevel = get(g:, 'indentLine_indentLevel', 20)
    let w:indentLine_matchsid = get(w:, 'indentLine_matchsid', [])

    if !w:indentLine_matchsid->empty()
        for id in w:indentLine_matchsid
            try
                call matchdelete(id)
            catch /^Vim\%((\a\+)\)\=:E80[23]/
            endtry
        endfor
        let w:indentLine_matchsid = []
    endif

    let sw = &sw ? &sw : &tabstop
    let ws = g:indentLine_ws
    for i in range(sw+1, sw*g:indentLine_indentLevel+1, sw)
        let pat = '^'.ws.'\+\zs\%'.i.'v'.ws
        let id = matchadd('Conceal', pat, 0, -1, {'conceal': g:indentLine_char})
        let _ = w:indentLine_matchsid->add(id)
    endfor
endfunction
function! UpdateUserMatches() " {{{1
    call UpdateIndentLine()

    let g:eol_ws_light_id = get(g:, 'eol_ws_light_id', -1)
    if g:eol_ws_light_id != -1
        try
            call matchdelete(g:eol_ws_light_id)
        catch /^Vim\%((\a\+)\)\=:E80[23]/
        endtry
    endif
    let g:eol_ws_light_id = matchadd('EOLWhiteSpace', '\v\s+$|\S\zs\s{50,}\ze\S', 0, -1)
endfunction
function! SetUserColors() " {{{1
    " Vim 原生补全菜单
    hi! Pmenu ctermbg=237
    " Vim 原生补全菜单选中项
    hi! PmenuSel ctermfg=35 ctermbg=238
    " 词匹配颜色
    hi! default WordLight term=nocombine cterm=underline

    " 行高亮
    hi! CursorLine term=none cterm=none ctermbg=235

    " 语法隐藏颜色
    hi! Conceal ctermfg=244 ctermbg=NONE guifg=Grey30 guibg=NONE

    hi! User1 cterm=none ctermfg=15 ctermbg=29

    " 背景
    "hi! Normal term=none cterm=none gui=none ctermfg=15 ctermbg=none guifg=White guibg=Black

    hi! NonText term=bold cterm=none gui=bold ctermfg=12 ctermbg=none guifg=Blue guibg=Black

    hi! link EndOfBuffer NonText

    " 左侧边栏
    hi! SignColumn term=standout cterm=none gui=bold
                \ ctermfg=14 ctermbg=242 guifg=Cyan guibg=Grey

    hi! CocInlayHint cterm=none ctermfg=252 ctermbg=236

    hi! CocFloating ctermbg=237
    " Coc 搜索匹配项
    hi! CocSearch ctermfg=35
    " Coc 搜索匹配项背景
    hi! CocMenuSel ctermbg=238 guibg=#494949
    " 警告侧标
    hi! CocWarningSign ctermfg=0 ctermbg=3

    " 行号颜色
    "hi! LineNr term=bold cterm=none gui=none
    "            \ ctermfg=11 ctermbg=none guifg=Yellow guibg=Black

    " 光标所在行行号颜色
    "hi! CursorLineNr term=underline cterm=underline gui=underline
    "            \ ctermfg=11 ctermbg=none guifg=Yellow guibg=Black

    hi def EOLWhiteSpace ctermfg=NONE ctermbg=236 guifg=NONE guibg=#3A3A3A

    let g:indentLine_char = '│'
    augroup UserMatches
        autocmd!
        autocmd OptionSet shiftwidth,tabstop call UpdateUserMatches()
        autocmd BufRead,BufNewFile,WinEnter,Syntax * call UpdateUserMatches()
    augroup end
    doautocmd UserMatches Syntax
endfunction
function! SizeFmt(num, suffix,)
    let num = a:num + 0.0
    if num < 1<<10
        let t = ''
    elseif num < 1<<20
        let t = 'K'
        let num /= 1 << 10
    elseif num < 1<<30
        let t = 'M'
        let num /= 1 << 20
    elseif num < 1<<40
        let t = 'G'
        let num /= 1 << 30
    elseif num < 1<<50
        let t = 'T'
        let num /= 1 << 40
    else
        let t = '^'
    endif
    return (float2nr(num*10)/10.0)->string().t.(t->strlen()?'i':'').a:suffix
endfunction
function! HeadLineIndentFunction(lnum) " {{{1
    let next = nextnonblank(a:lnum+1)
    let [cind, nind] = [
                \   indent(a:lnum) / &shiftwidth,
                 \   indent(next) / &shiftwidth,
                  \]

    if getline(a:lnum) =~# '^[[:blank:]]*$'
        return nind
    elseif nind > cind
        return '>'.nind
    endif
    return cind
endfunction
function! FunExists(name) " {{{1
    try
        call funcref(a:name)
        return v:true
    catch /^Vim\%((\a\+)\)\=:E700:/
        return v:false
    endtry
endfunction
function! Camel2snake(word, upper = 0, start = 0) " {{{1
    let prefix = a:start ? a:word[:a:start-1] : ''
    let rest = substitute(a:word[a:start:], '\v%(<_*)@<!\u', '_&', 'g')
    return prefix . (a:upper ? toupper(rest) : tolower(rest))
endfunction
function! Snake2Camel(word, upper = 1, start = 0) " {{{1
    let prefix = a:start ? a:word[:a:start-1] : ''
    let pat = $'\v(<_{a:upper ? '*\l=' : '+'})|_(\l)'
    return prefix . substitute(a:word[a:start:], pat, '\U\1\2', 'g')
endfunction
function! MatchAll(expr, pat) " {{{1
    let rem = a:expr
    let res = []
    while v:true
        let [str, _, end] = matchstrpos(rem, a:pat)
        if end == -1 | break | endif
        call add(res, str)
        let rem = rem[end:]
    endwhile
    return res
endfunction
function! ShCmdFmt(format, ...) " {{{1
    let cmd = ''
    let i = 0
    let list = MatchAll(a:format, '\v[^%]+|\%.')
    let actions = #{
                \s: {s -> s},
                \f: function('FileNameToShell'),
                \S: {args -> join(args)},
                \F: {args -> join(map(args, {_, s -> FileNameToShell(s)}))},
                \}
    let hards = {
                \'%': {-> '%'},
                \'p': {-> FileNameToShell(expand('%:p'))},
                \}
    for arg in list
        if arg =~# '^%'
            let F = get(hards, arg[1:], v:none)
            if !empty(F)
                let cmd .= F()
            else
                let F = actions[arg[1:]]
                let cmd .= F(a:000[i])
                let i += 1
            endif
        else
            let cmd .= arg
        endif
    endfor
    return cmd
endfunction
" End {{{1
" }}}1
