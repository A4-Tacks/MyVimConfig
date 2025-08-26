scriptencoding utf-8
" 准备工作:
" CocInstall coc-json coc-tsserver coc-marketplace coc-snippets
" 提供json解析 ts服务器 coc插件管理器

" 搜索软件包
" CocList marketplace

" coc-lsp: `https://github-wiki-see.page/m/neoclide/coc.nvim/wiki/Language-servers`

" 可能用到的软件包: vint shellcheck shfmt ...

" maps

" rename
nmap <silent> <F2> <Plug>(coc-rename)

" 关闭补全窗口
inoremap <silent><expr> <C-e> coc#pum#visible() ? coc#pum#cancel() : "\<End>"

" 代码操作选择
xmap <F3> <Plug>(coc-codeaction-selected)
nmap <F3> <Plug>(coc-codeaction-cursor)

xmap <c-@> <Plug>(coc-codeaction-selected)
nmap <c-@> <Plug>(coc-codeaction-cursor)

" 源码级操作选择
nmap <C-F3>  <Plug>(coc-codeaction-source)

" 快速修复
nmap <F4> <Plug>(coc-fix-current)

" 命令列表
nnoremap <leader>c :CocCommand<CR>
xnoremap <leader>c :CocCommand<CR>

" rust-analyzer 合并行
nnoremap <leader>z vj:CocCommand rust-analyzer.joinLines<CR>
xnoremap <leader>z   :CocCommand rust-analyzer.joinLines<CR>

" 大纲
nnoremap <silent><nowait> <leader>o :call ToggleCocOutline()<CR>
function! ToggleCocOutline() abort
  let winid = coc#window#find('cocViewId', 'OUTLINE')
  if winid == -1
    call CocActionAsync('showOutline', 0)
  else
    call coc#window#close(winid)
  endif
endfunction

" 错误跳转
nmap <silent> <C-k> <Plug>(coc-diagnostic-prev)
nmap <silent> <C-j> <Plug>(coc-diagnostic-next)

" 片段跳转
inoremap <silent> <c-j> <cmd>:call coc#snippet#jump(1,0)<cr>
inoremap <silent> <c-k> <cmd>:call coc#snippet#jump(0,0)<cr>

" 显示代码诊断
nnoremap <silent> <C-F4> :CocDiagnostics<Cr>

" 关闭所有窗口
nnoremap <silent> <leader>w :call coc#float#close_all()<CR>


" display doc
" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
xnoremap <silent> K <cmd>call <SID>show_documentation()<CR>

function! s:show_documentation()
    if (index(['vim', 'help'], &filetype) != -1)
        execute 'h '.g:cursor_word_str
    elseif index(['bash', 'sh'], &filetype) != -1
        execute '!' . &keywordprg . ' ' . g:cursor_word_str
    elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
        " not exit visual, do optional range hover
        return
    else
        execute '!' . &keywordprg . ' ' . g:cursor_word_str
    endif
    if mode() =~# '[vV]' " Exit visual mode
        execute "normal! \<esc>"
    endif
endfunction



" Default Options
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(0) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <silent><expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(0) : "\<C-h>"
inoremap <silent><expr> <Up> coc#pum#visible() ? coc#pum#prev(0) : "\<Up>"
inoremap <silent><expr> <Down> coc#pum#visible() ? coc#pum#next(0) : "\<Down>"
inoremap <silent><expr> <C-p> coc#pum#visible()
            \   ? coc#pum#prev(0)
            \   : "\<C-p>"
inoremap <silent><expr> <C-n> coc#pum#visible()
            \   ? coc#pum#next(0)
            \   : pumvisible()
            \       ? "\<C-n>"
            \       : coc#refresh()

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <cr> foldclosed('.') != -1
            \ ? execute("foldopen!")
            \ : coc#pum#visible() ? coc#pum#confirm()
            \ : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)

augroup coc_user
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  " Update statusline
  autocmd User CocStatusChange redrawstatus
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>f  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>e  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
"command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
set statusline^=%(%1*[%{coc#status()}%{get(b:,'coc_current_function','')}]%*\ %)

