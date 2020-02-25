" Enable mouse support
set mouse=a

" Enable true colors.
" set termguicolors

let os = substitute(system('uname'), "\n", "", "")
if os == 'Darwin'
    " set clipboard=unnamed
else
    " let g:clipboard = {
    "             \   'name': 'myClipboard',
    "             \   'copy': {
    "             \      '+': 'xsel --nodetach -i --clipboard',
    "             \      '*': 'xsel --nodetach -i --clipboard',
    "             \    },
    "             \   'paste': {
    "             \      '+': 'xsel -o --clipboard',
    "             \      '*': 'xsel -o --clipboard',
    "             \   },
    "             \   'cache_enabled': 1,
    "             \ }
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

" Add vertical bar at 80 characters
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

" Configure the cursor shape and color.
set guicursor=i:ver25

set scroll=20

" Change directory to where current buffer is.
" autocmd BufEnter * silent! lcd %:p:h

" Set Python 3 provider.
if filereadable($HOME . "/.virtualenvs/py3.6/bin/python")
    let g:python3_host_prog = $HOME . "/.virtualenvs/py3.6/bin/python"
elseif filereadable($HOME . "/.virtualenvs/py3.6/bin/python")
    let g:python3_host_prog = $HOME . "/.virtualenvs/py3.7/bin/python"
endif

" Disable Python 2.
let g:loaded_python_provider = 0
