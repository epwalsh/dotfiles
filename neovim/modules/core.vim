set mouse=a
set hidden
set nobackup
set nowritebackup
set shell=sh

" Leaders
let maplocalleader = ","
let mapleader = ","

" Make sure background works properly for tmux.
set t_ut=

" Highlight during word search.
set nohls

" Enable syntax highlighting.
syntax enable

" Theme settings.
set background=dark

" Line numbers.
set number
set relativenumber

" Add vertical bar at 80 characters.
set colorcolumn=80

" Make tabs appear as 4 spaces.
set tabstop=4

" Don't wrap lines by default.
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

" Configure the cursor shape and color.
set guicursor=i:ver25

set scroll=20

" Set Python 3 provider.
let g:python3_host_prog = $VIRTUAL_ENV . '/bin/python'

" Disable Python 2.
let g:loaded_python_provider = 0

" Find the root of the repo. This is useful for configuring makers.
let repo = systemlist("git rev-parse --show-toplevel")[0]
if repo !~ "^fatal"
    let g:repo = repo
endif

" Enable spell checking.
set spell spelllang=en_us spelloptions=camel

" Faster update time, helps some plugins like vim-gitgutter.
set updatetime=100
