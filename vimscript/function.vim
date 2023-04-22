function! Translate(...) " {{{1
    return py3eval('translate.main("", *vim.eval("a:000"))')
endfunction
function! Appends(line, str) " {{{
    " 解决换行无法被追加的问题
    let n = a:line
    for line in split(a:str, "\n")
        call append(n, line)
        let n += 1
    endfor
endfunction
function! Py3Call(name, ...) " {{{1
    " py3eval 有一个很坑的坑, int和float会变成str
    return py3eval('parse_to_vim(' . a:name . '(*vim.eval("a:000")))')
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
        return a:string[:l:l - 1] . "..."
    endif
    return a:string
endfunction
function! BuildShellArgs(args) " {{{1
    let l:res = a:args[:]
    call map(l:res, {k, v -> fnameescape(v)})
    return join(l:res, " ")
endfunction
function! ShlexSplit(str, ...) " -> list {{{1
    echomsg a:str
    echomsg a:000
    return py3eval('shlex.split(vim.eval("a:str"))')
endfunction
function! ReversedStr(string) " {{{1
    return list2str(reverse(str2list(a:string)))
endfunction
function! GetCursorWord() " {{{1
    let l:col = col(".") - 1
    let l:line = line(".")
    let l:line_text = getline(l:line) . ' '
    let l:index = matchend(ReversedStr(l:line_text[:col]), '^.\{-0,}\>')
    if l:index == -1
        return ''
    endif
    let l:l = l:col - l:index + 1
    let l:index = matchend(line_text[l:l:], '^.\{-0,}\>')
    let l:r = l:index + l:l - 1 " 坑人的开区间 slice 要减 1
    if l:index == -1 || l:r < l:col - 1
        return ''
    endif
    return l:line_text[l:l:l:r]
endfunction
function! FileNameToShell(name) " {{{1
    " 将 vim 中的文件名转义至shell不会有其它含义的字符, 且不会被vim的expand转义
    return substitute(fnameescape(a:name),
                \'\([();&>]\)', {x -> '\' . x[1]}, 'g')
endfunction
function! VarInit(name, default) " {{{1
    if ! exists(a:name)
        execute "let " . a:name . " = a:default"
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
            let l:res .= l:char
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
" }}}1
