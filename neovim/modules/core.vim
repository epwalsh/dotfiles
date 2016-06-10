" =============================================================================
" File Name:     core.vim
" Author:        Evan Pete Walsh
" Contact:       epwalsh10@gmail.com
" Creation Date: 21-03-2016
" Last Modified: Thu Jun  9 22:19:44 2016
" =============================================================================

" This will cause autocomplete tip window to close as soon as a selection is
" made. This is particular useful for pymode rope omnicompletion.
" autocmd CompleteDone * pclose

" Set encoding to utf-8, this may be the default anyway
" set encoding=utf-8

" Copy everything to OS clipboard
set clipboard=unnamed

" Leaders
let maplocalleader = ","
let mapleader = ","

" Make sure background works properly for tmux
set t_ut=

set mouse=a

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
" Highlight Excess ctermbg=DarkGrey guibg=Black
" Match Excess /\%80v.*/
set colorcolumn=80

" Don't wrap lines by default
set nowrap

" Toggle paste
set pastetoggle=<F3>

" Popup menu behavior -------------------------------------------------- {{{
set completeopt=longest,menuone
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
" ---------------------------------------------------------------------- }}}

" Abbreviations
iabbrev @@ epwalsh10@gmail.com
