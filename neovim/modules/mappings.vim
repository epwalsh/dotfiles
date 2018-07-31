function! WrapMove(move_type)
    if &wrap == 0
        execute "normal! " . a:move_type
    else
        execute "normal! g" . a:move_type
    endif
endfunction

" For navigating through wrapped lines.
nnoremap j gj
nnoremap k gk
nnoremap 0 :call WrapMove("0")<cr>
nnoremap $ :call WrapMove("$")<cr>

nnoremap ; :
vnoremap ; :
"nmap : <nop>
"vmap : <nop>

" Always use very magic setting for regex searches
nmap / /\v
vmap / /\v

" Toggle relative line numbers
nnoremap <F5> :setlocal relativenumber!<cr>
inoremap <F5> <esc>:setlocal relativenumber!<cr>li
vnoremap <F5> :<c-u>normal! `<mr`>mt<cr>:<c-u>setlocal relativenumber!
            \<cr>:<c-u>normal! `rv`t<cr>
nnoremap <leader><F5> :setlocal relativenumber!<cr>
vnoremap <leader><F5> :<c-u>normal! `<mr`>mt<cr>:<c-u>setlocal relativenumber!
            \<cr>:<c-u>normal! `rv`t<cr>

" Jump to matching character (ex. matching brace or parenthesis)
nnoremap <leader>m %

" Execute :nohl with <F4>
nnoremap <F4> :set<Space>hls!<cr>
vnoremap <F4> :<c-u>normal! `<mr`>mt<cr>:<c-u>set<Space>hls!<cr>:<c-u>normal! `rv`t<cr>

" Movements between windows when not in tmux
nnoremap <c-j> <nop>

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

" Escape insert mode without having to press that stupid <esc> key. Also keeps
" the cursor from moving back one-character when possible.
inoremap jk <esc>l
vnoremap <leader>jk <esc>
" Map <esc> to no operation in insert mode
"inoremap <esc> <nop>

" Quickly jump to beginning and end of lines
nnoremap H 0
nnoremap L $h
vnoremap H 0
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
