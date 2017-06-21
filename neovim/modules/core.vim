" =============================================================================
" File Name:     core.vim
" Creation Date: 21-03-2016
" Last Modified: 2017-06-21 12:28:33
" =============================================================================

" Enable mouse support
set mouse=a

" Copy everything to OS clipboard if using OS X
let os = substitute(system('uname'), "\n", "", "")
if os == "Darwin"
    set clipboard=unnamed
endif

" Leaders
let maplocalleader = ","
let mapleader = ","

" Make sure background works properly for tmux
set t_ut=

" Highlight during word search
set nohls

" Enable syntax highlighting
syntax enable

" Theme settings
set background=dark

" Line numbers
set number
set relativenumber

" Highlight text past 80 characters and add vertical bar
set colorcolumn=80

" Make tabs appear as 4 spaces
set tabstop=4

" Don't wrap lines by default
set nowrap

set completeopt=longest,menuone
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

" Scrolling behavior with mouse, scroll one line at a time
map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>
