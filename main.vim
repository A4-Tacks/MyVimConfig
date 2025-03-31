" add `execute "source " . fnameescape(expand("<sfile>:p:h") . "/MyVimConfig/main.vim")` to ~/.vim/vimrc
" git to ~/.vim/MyVimConfig

set nocompatible
if ! has('python3') "{{{
    echoerr "vim is not has python3"
    finish
endif "}}}

function Log(...) " {{{1
    let l:msg = join(a:000)
    call add(g:loader_debug_log, l:msg)
    if get(g:, 'loader_debug')
        echomsg l:msg
    endif
endfunction

let s:project_root = expand("<sfile>:p:h")
let g:loader_debug = v:false
let g:loader_debug_log = []
" load python main {{{1
execute "py3file " .. fnameescape(s:project_root .. "/python/__main__.py")
" Vim Scripts {{{1
let s:vim_scripts =<< trim EOF
{
    vimscript
    {
        function.vim
        plug_config.vim
        settings.vim
        colors.vim
        autocmd.vim
        command.vim
        keymap.vim
        // 插件配置文件
        plugged_configs
        {
            ale.vim
            coc_nvim.vim
            JavaComplete2.vim
            NERDTree.vim
            winmode.vim
        }
    }
}
EOF
let s:tmp = []
for s:i in s:vim_scripts
    let s:line = split(s:i, '^ *')
    if len(s:line) == 0 || s:line[0][0:1] == '//'
        continue
    endif " skip empty or note line
    call add(s:tmp, s:line[0])
endfor
let s:vim_scripts = s:tmp
unlet s:tmp
" Build Vim Scripts {{{1
let s:stack = []
let s:run_vimscript_queue = [s:project_root]
for s:line in s:vim_scripts
    if s:line == '{'
        let s:tmp = remove(s:run_vimscript_queue, -1)
        call add(s:stack, s:tmp)
    elseif s:line == '}'
        call remove(s:stack, -1)
    else
        let s:tmp = s:stack[-1] .. "/" .. s:line
        call add(s:run_vimscript_queue, s:tmp)
    endif
endfor
" Running Vim Scripts {{{1
for s:path in s:run_vimscript_queue
    let s:tmp = fnameescape(s:path)
    call Log("load:", s:tmp)
    execute "source " .. s:tmp
endfor
" }}}1
