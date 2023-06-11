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
function! ReversedStr(string) " {{{1
    return list2str(reverse(str2list(a:string)))
endfunction
function! GetCursorWord() " {{{1
    let [ccol, line] = [charcol("."), line(".")]
    let bcol_idx = col(".") - 1 " byte column (cursor) index
    let line_text = getline(line)
    let to_col_text = ReversedStr(strcharpart(line_text, 0, ccol))
    let idx = matchend(to_col_text,
                \ '^.\{-0,}\>')
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
function! ToSnake(name, big_start = v:true) " {{{1
    " 转换为驼峰命名法
    let l:res = ""
    let l:upper_tag = a:big_start
    for l:char in a:name
        if match(l:char, '[ _]') != -1
            let l:upper_tag = v:true
        else
            if l:upper_tag
                let l:upper_tag = v:false
                let l:char = toupper(l:char)
            endif
            let l:res ..= l:char
        endif
    endfor
    return l:res
endfunction
function! SplitLevelsArgs(level, args) " -> list[list[str]] {{{1
    " level > 0
    " res.len == level
    if a:level <= 0
        return []
    endif
    let res = [[]]
    for _ in range(a:level)
        let res += []
    endfor
    for arg in a:args
        if len(res) < a:level && arg == '--'
            call add(res, [])
        else
            call add(res[-1], arg)
        endif
    endfor
    for _ in range(a:level - len(res))
        call add(res, [])
    endfor
    return res
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
    let Rename = {x -> substitute(x, '\<func\>', 'func_', 'g')}
    let URename = {x -> substitute(x, '\<func_\>', 'func', 'g')}
    let Strip = {x -> substitute(x, '^\(\n\|\s\)\+\|\(\n\|\s\)\+$', '', 'g')}
    let str = Rename(a:str)
    if a:mode
        " rs to c
        let cdecl_expr = Py3Call("rs_to_cdecl", str)
        return Strip(URename(system("echo " . SystemString(cdecl_expr) . '| cdecl')))
    else
        " c to rs
        let tmp_file = expand("~/") . ".vim_ctype_out_tmp_" . rand()
        let sys_res = system("echo explain " . SystemString(str)
                    \. '| cdecl 2> ' . SystemString(tmp_file))
        for line in readfile(tmp_file)
            30 echowindow line
        endfor
        call Py3Call('os.remove', tmp_file)
        return Strip(URename(Py3Call("cdecl_to_rs", sys_res)))
    endif
endfunction
" End {{{1
" }}}1
