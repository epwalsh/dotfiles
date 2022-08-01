" Configure LSP code navigation shortcuts
" as found in :help lsp
"
nnoremap <silent> <c-]>     <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <c-k>     <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> K         <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gi        <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gc        <cmd>lua vim.lsp.buf.incoming_calls()<CR>
nnoremap <silent> gd        <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr        <cmd>lua vim.lsp.buf.references()<CR>
" Use inc-rename.nvim for renaming.
" nnoremap <silent> rn        <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> gs        <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gw        <cmd>lua vim.lsp.buf.workspace_symbol()<CR>

" Replaced LSP implementation with code action plugin...
"
" nnoremap <silent> ga        <cmd>lua vim.lsp.buf.code_action()<CR>
"

nnoremap <silent> [x        <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent> ]x        <cmd>lua vim.diagnostic.goto_next()<CR>
nnoremap <silent> ]s        <cmd>lua vim.diagnostic.show()<CR>

" Replaced LSP implementation with trouble plugin...
"
" nnoremap <silent> <space>q  <cmd>lua vim.diagnostic.setloclist()<CR>
"

" mapping to make movements operate on 1 screen line in wrap mode
function! ScreenMovement(movement)
  if &wrap
    return "g" . a:movement
  else
    return a:movement
  endif
endfunction
onoremap <silent> <expr> j ScreenMovement("j")
onoremap <silent> <expr> k ScreenMovement("k")
onoremap <silent> <expr> 0 ScreenMovement("0")
onoremap <silent> <expr> ^ ScreenMovement("^")
onoremap <silent> <expr> $ ScreenMovement("$")
nnoremap <silent> <expr> j ScreenMovement("j")
nnoremap <silent> <expr> k ScreenMovement("k")
nnoremap <silent> <expr> 0 ScreenMovement("0")
nnoremap <silent> <expr> ^ ScreenMovement("^")
nnoremap <silent> <expr> $ ScreenMovement("$")
vnoremap <silent> <expr> j ScreenMovement("j")
vnoremap <silent> <expr> k ScreenMovement("k")
vnoremap <silent> <expr> 0 ScreenMovement("0")
vnoremap <silent> <expr> ^ ScreenMovement("^")
vnoremap <silent> <expr> $ ScreenMovement("$")
vnoremap <silent> <expr> j ScreenMovement("j")

nnoremap ; :
vnoremap ; :

" Always use very magic setting for regex searches
nmap / /\v
vmap / /\v

" Jump to matching character (ex. matching brace or parenthesis)
nnoremap <leader>m %

" Move lines up or down
nnoremap ∆ :m .+1<CR>==
nnoremap ˚ :m .-2<CR>==
vnoremap ∆ :m '>+1<CR>gv=gv
vnoremap ˚ :m '<-2<CR>gv=gv

" Change current word to uppercase
inoremap <leader>up <esc>bveUea
nnoremap <leader>up bveUe

" Change current word to lowercase
inoremap <leader>lw <esc>bveuea
nnoremap <leader>lw <esc>bveue

" Copy current line
nnoremap <leader>yl 0v$y

" Put quotes around a word
nnoremap <leader>" ea"<esc>hbi"<esc>lel
nnoremap <leader>' ea'<esc>hbi'<esc>lel
vnoremap <leader>" <esc>`>a"<esc>`<i"<esc>`>ll
vnoremap <leader>' <esc>`>a'<esc>`<i'<esc>`>ll

" Put double brackets around a word (this creates a link to another markdown
" file for Obsidian).
vnoremap <leader>l <esc>`>a]]<esc>`<i[[<esc>`>ll

" Escape insert mode without having to press that stupid <esc> key. Also keeps
" the cursor from moving back one-character when possible.
inoremap jk <esc>l
vnoremap <leader>jk <esc>

" Quickly jump to beginning and end of lines
" nnoremap H 0
nnoremap L $h
" vnoremap H 0
vnoremap L $h

" Define some nifty operating-pending mappings
onoremap p i(
onoremap in( :<c-u>normal! f(vi(<cr>
onoremap il( :<c-u>normal! F)vi(<cr>

" Find trailing whitespace
nnoremap <leader>w mqgg/\v\s+$<cr>`q
" Remove trailing whitespace
nnoremap <leader>W mqgg:%s:\v\s+$:<cr>`q

" Insert line below and stay in normal mode
nnoremap <leader>o o<esc>
" Insert line above and stay in normal mode
nnoremap <leader>O O<esc>

" Toggle paste
set pastetoggle=<F3>

" Hop up and down without losing track of where the fudge you are.
nnoremap <c-u> 10<c-y>
nnoremap <c-d> 10<c-e>

" Show highlight group.
nmap <leader>sp :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" Adjust window size.
nnoremap <c-w><left> :vertical resize -5<CR>
nnoremap <c-w><right> :vertical resize +5<CR>
nnoremap <c-w><up> :res +5<CR>
nnoremap <c-w><down> :res -5<CR>

" Run Neomake.
nnoremap <leader>mm :Neomake<CR>

" Tab completion.
" inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
" inoremap <silent><expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

" Toggle conceallevel
function! ToggleConcealLevel()
    if &conceallevel == 0
        setlocal conceallevel=2
    else
        setlocal conceallevel=0
    endif
endfunction
nnoremap <silent> <C-c><C-y> :call ToggleConcealLevel()<CR>

" Open a fold and stay at the top.
nnoremap z[ zo[z
" Open a fold and go to the bottom.
nnoremap z] zo]z
