" configuración de la barra de estado inferior
let g:lightline = {
      \ 'active': {
      \   'left': [['mode', 'paste'], [], ['relativepath', 'modified']],
      \   'right': [['kitestatus'], ['filetype', 'percent', 'lineinfo'], ['gitbranch']]
      \ },
      \ 'inactive': {
      \   'left': [['inactive'], ['relativepath']],
      \   'right': [['bufnum']]
      \ },
      \ 'component': {
      \   'bufnum': '%n',
      \   'inactive': 'inactive'
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head',
      \   'kitestatus': 'kite#statusline'
      \ },
      \ 'colorscheme': 'gruvbox',
      \ 'subseparator': {
      \   'left': '',
      \   'right': ''
      \ }
      \}

" si usted utiliza el autocompletado KITE descomente las dos sgt líneas
"let g:kite_auto_complete = 1
"let g:kite_supported_languages = ['lenguaje']
let g:coc_global_extensions = [
    \ 'coc-snippets',
    \ 'coc-tsserver',
    \ 'coc-java-vimspector',
    \ 'coc-java'
    \ ]

" cuándo este utilizando KITE desabilite la entrega de sugerencias de COC, descomente la línea:
"autocmd FileType javascript let b:coc_suggest_disable = 1
autocmd FileType scss setl iskeyword+=@-@

" cerrado automatico de la barra lateral o árbol
let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=1
let NERDTreeAutoDeleteBuffer=1
let NERDTreeMinimalUI=1
let NERDTreeDirArrows=1
let NERDTreeShowLineNumbers=1
let NERDTreeMapOpenInTab='\t'
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

" navegación con tmux
let g:tmux_navigator_no_mappings=1

" vim fugitive
command! -bang -nargs=? -complete=dir GFiles
  \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>, fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" configuración para la funcionalidad de vim-floaterm
let g:floaterm_keymap_new = '<F7>'
let g:floaterm_keymap_next = '<F8>'
let g:floaterm_keymap_prev = '<F9>'
let g:floaterm_keymap_toggle = '<F10>'
let g:floaterm_keymap_kill = '<F11>'

" para realizar buenas capturas de código con vim-silicon
let g:silicon = {
      \   'theme':              'Dracula',
      \   'font':                  'Hack',
      \   'background':         '#AAAAFF',
      \   'shadow-color':       '#555555',
      \   'line-pad':                   2,
      \   'pad-horiz':                 80,
      \   'pad-vert':                 100,
      \   'shadow-blur-radius':         0,
      \   'shadow-offset-x':            0,
      \   'shadow-offset-y':            0,
      \   'line-number':           v:true,
      \   'round-corner':          v:true,
      \   'window-controls':       v:true,
      \ }

let g:silicon['output'] = '~/vim-silicon/screen-{time:%d-%m-%Y}.png'

let s:workhours = {
      \ 'Monday':    [8, 16],
      \ 'Tuesday':   [9, 17],
      \ 'Wednesday': [9, 17],
      \ 'Thursday':  [9, 17],
      \ 'Friday':    [9, 15],
      \ }

function! s:working()
    let day = strftime('%u')
    if has_key(s:workhours, day)
      let hour = strftime('%H')
      let [start_hour, stop_hour] = s:workhours[day]
      if start_hour <= hour && hour <= stop_hour
        return "~/Work-Snippets/"
      endif
    endif
    return "~/Personal-Snippets/"
endfunction

let g:silicon['output'] = function('s:working')

" para traducir usa vim-translator
nmap <silent> <Leader>ta <Plug>Translate
vmap <silent> <Leader>ta <Plug>TranslateV
" Display translation in a window
nmap <silent> <Leader>tr <Plug>TranslateW
vmap <silent> <Leader>tr <Plug>TranslateWV
" Replace the text with translation
nmap <silent> <Leader>ts <Plug>TranslateR
vmap <silent> <Leader>ts <Plug>TranslateRV

nnoremap <silent><expr> <M-f> translator#window#float#has_scroll() ?
                            \ translator#window#float#scroll(1) : "\<M-f>"
nnoremap <silent><expr> <M-b> translator#window#float#has_scroll() ?
                            \ translator#window#float#scroll(0) : "\<M-f>"



"*--------------------------- FUNCIÓN QUE INTEGRA LA TERMINAL DENTRO DE NVIM -------------------------------*
function! OpenTerminal()
  " mover al búfer hacia la derecha
  execute "normal \<C-l>"
  execute "normal \<C-l>"
  execute "normal \<C-l>"
  execute "normal \<C-l>"

  let bufNum = bufnr("%")
  let bufType = getbufvar(bufNum, "&buftype", "not found")

  if bufType == "terminal"
    " cerrar terminal existente
    execute "q"
  else
    " se abrirá la terminal cmd, pero si usted utiliza otra terminal, debes
    " poner el nombre del .exe o ejecutable ya sea: 'cmd, zsh, bash, iTerm', quedando la
    " línea (81) así: execute 'sp term://zsh'
    execute "sp term://cmd"

    " apagar números
    execute "set nonu"
    execute "set nornu"

    " alternar insertar en entrar o salir
    silent au BufLeave <buffer> stopinsert!
    silent au BufWinEnter,WinEnter <buffer> startinsert!

    " establezco atajos dentro de la terminal
    execute "tnoremap <buffer> <Esc> <C-\\><C-n><C-w><C-h>"
    execute "tnoremap <buffer> <C-t> <C-\\><C-n>:q<CR>"
    execute "tnoremap <buffer> <C-7> <C-\\><C-\\><C-n>"

    startinsert!
  endif
endfunction

"*---------------------- SOLUCIÓN A EL ERROR DE COC-SNIPPETS -----------------------*
" Si al iniciar neovim te aparece siempre este molestoso error de coc-snippets:
"[coc.nvim] Error on execute :pyx command, ultisnips feature of coc-snippets requires pyx support on vim. use :CocOpenLog for details
" ejecuta el comando en la PowerShell como administrador: pip install pynvim
" así no deberá aparecerte más.

"*------------------------- CONFIGURACIÓN DE COC, LA DEJO EN INGLES -----------------------------*
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.6.1") || has("patch-8.1.1564")
  set signcolumn=number
else
  set signcolumn=yes
endif

" configuration de coc-snippets
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<TAB>'

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Use K to show documentation in preview window.
nnoremap <silent> DOC :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <Leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <Leader>f  <Plug>(coc-format-selected)
nmap <Leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<Leader>aap` for current paragraph
xmap <Leader>a  <Plug>(coc-codeaction-selected)
nmap <Leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <Leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <Leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <Leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.6.1') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" Highlight symbol under cursor on CursorHold

let $FZF_DEFAULT_OPTS='--layout=reverse'
"let g:fzf_layout = { 'window': 'call FloatingFZF()' }
"function! FloatingFZF()
  "let buf = nvim_create_buf(v:false, v:true)
  "call setbufvar(buf, '&signcolumn', 'no')
  "let height = float2nr((&lines - 3) / 2)
  "let width = float2nr(&columns - (&columns * 2 / 10))
  "let col = float2nr((&columns - width) / 2)
  "let row = float2nr((&lines - height) / 2)
  "let opts = {
        "\ 'relative': 'editor',
        "\ 'row': row,
        "\ 'col': col,
        "\ 'width': width,
        "\ 'height': height
        "\ }
  "call nvim_open_win(buf, v:true, opts)
"endfunction

"function! SearchPatternInFile(pattern)
    "" Save cursor position.
    "let save_cursor = getcurpos()

    "" Set cursor position to beginning of file.
    "call cursor(0, 0)

    "" Search for the string 'hello' with a flag c.  The c flag means that a
    "" match at the cursor position will be accepted.
    "let search_result = search(a:pattern, "c")

    "" Set the cursor back at the saved position.  The setpos function was
    "" used here because the return value of getcurpos can be used directly
    "" with it, unlike the cursor function.
    "call setpos('.', save_cursor)

    "" If the search function didn't find the pattern, it will have
    "" returned 0, thus it wasn't found.  Any other number means that an instance
    "" has been found.
    "return search_result
"endfunction

function! ParensIndent()
  let prev = col('.') - 1
  let after = col('.')
  let prevChar = matchstr(getline('.'), '\%' . prev . 'c.')
  let afterChar = matchstr(getline('.'), '\%' . after . 'c.')
  if (prevChar == '"' && afterChar == '"') ||
\    (prevChar == "'" && afterChar == "'") ||
\    (prevChar == "(" && afterChar == ")") ||
\    (prevChar == "{" && afterChar == "}") ||
\    (prevChar == "[" && afterChar == "]")
    return "\<CR>\<ESC>O"
  endif
  
  return "\<CR>"
endfunction

inoremap <expr> <space> ParensSpacing()

function! ParensSpacing()
  let prev = col('.') - 1
  let after = col('.')
  let prevChar = matchstr(getline('.'), '\%' . prev . 'c.')
  let afterChar = matchstr(getline('.'), '\%' . after . 'c.')
  if (prevChar == '"' && afterChar == '"') ||
\    (prevChar == "'" && afterChar == "'") ||
\    (prevChar == "(" && afterChar == ")") ||
\    (prevChar == "{" && afterChar == "}") ||
\    (prevChar == "[" && afterChar == "]")
    return "\<space>\<space>\<left>"
  endif
  
  return "\<space>"
endfunction

inoremap <expr> <BS> ParensRemoveSpacing()

function! ParensRemoveSpacing()
  let prev = col('.') - 1
  let after = col('.')
  let prevChar = matchstr(getline('.'), '\%' . prev . 'c.')
  let afterChar = matchstr(getline('.'), '\%' . after . 'c.')

  if (prevChar == '"' && afterChar == '"') ||
\    (prevChar == "'" && afterChar == "'") ||
\    (prevChar == "(" && afterChar == ")") ||
\    (prevChar == "{" && afterChar == "}") ||
\    (prevChar == "[" && afterChar == "]")
    return "\<bs>\<right>\<bs>"
  endif
  
  if (prevChar == ' ' && afterChar == ' ')
    let prev = col('.') - 2
    let after = col('.') + 1
    let prevChar = matchstr(getline('.'), '\%' . prev . 'c.')
    let afterChar = matchstr(getline('.'), '\%' . after . 'c.')
    if (prevChar == '"' && afterChar == '"') ||
  \    (prevChar == "'" && afterChar == "'") ||
  \    (prevChar == "(" && afterChar == ")") ||
  \    (prevChar == "{" && afterChar == "}") ||
  \    (prevChar == "[" && afterChar == "]")
      return "\<bs>\<right>\<bs>"
    endif
  endif
  
  return "\<bs>"
endfunction

inoremap { {}<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap ' ''<left>
inoremap " ""<left>

let curly = "}"
inoremap <expr> } CheckNextParens(curly)

let bracket = "]"
inoremap <expr> ] CheckNextParens(bracket)

let parens = ")"
inoremap <expr> ) CheckNextParens(parens)

let quote = "'"
inoremap <expr> ' CheckNextQuote(quote)

let dquote = '"'
inoremap <expr> " CheckNextQuote(dquote)

let bticks = '`'
inoremap <expr> ` CheckNextQuote(bticks)

function CheckNextQuote(c)
  let after = col('.')
  let afterChar = matchstr(getline('.'), '\%' . after . 'c.')
  
  if (afterChar == a:c)
    return "\<right>"
  endif
  if (afterChar == ' ' || afterChar == '' || afterChar == ')' || afterChar== '}' || afterChar == ']')
    return a:c . a:c . "\<left>"
  endif
  if (afterChar != a:c)
    let bticks = '`'
    let dquote = '"'
    let quote = "'"
    if(afterChar == dquote || afterChar == quote || afterChar == bticks)
      return a:c . a:c . "\<left>"
    endif
  endif
  return a:c
endfunction

function CheckNextParens(c)
  let after = col('.')
  let afterChar = matchstr(getline('.'), '\%' . after . 'c.')
  if (afterChar == a:c)

    return "\<right>"
  endif
  return a:c
endfunction
