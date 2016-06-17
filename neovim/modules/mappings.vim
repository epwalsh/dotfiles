" =============================================================================
" File Name:     mappings.vim
" Author:        Evan Pete Walsh
" Contact:       epwalsh10@gmail.com
" Creation Date: 21-03-2016
" Last Modified: 2016-06-17 16:23:04
" =============================================================================

" For navigating up and down through wrapped lines
nnoremap j gj
nnoremap k gk

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
" map <c-j> <c-w>j
" map <c-k> <c-w>k
" map <c-l> <c-w>l
" map <c-h> <c-w>h

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

" Global copying and pasting between files open in vim
" vnoremap <F6> "+y
" vnoremap <leader>cp "+y
" nnoremap <F7> "+p
" nnoremap <leader>cv "+p
" inoremap <F7> <esc>"+pi
" inoremap <leader>cv <esc>"+pi
" nnoremap <leader><F7> "+p

" Open vimrc in a split
" nnoremap <leader>ev :vsplit $MYVIMRC<cr>
" Source vimrc
" nnoremap <leader>sv :source $MYVIMRC<cr>

" Put quotes around a word
nnoremap <leader>" ea"<esc>hbi"<esc>lel
nnoremap <leader>' ea'<esc>hbi'<esc>lel
vnoremap <leader>" <esc>`>a"<esc>`<i"<esc>`>ll
vnoremap <leader>' <esc>`>a'<esc>`<i'<esc>`>ll

" Escape insert mode without having to press that stupid <esc> key
inoremap jk <esc>
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
