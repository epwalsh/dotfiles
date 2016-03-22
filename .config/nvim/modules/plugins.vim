" =============================================================================
" File Name:     plugins.vim
" Author:        Evan Pete Walsh
" Contact:       epwalsh10@gmail.com
" Creation Date: 21-03-2016
" Last Modified: Mon Mar 21 21:10:49 2016
" =============================================================================

" Vundle package manager -------------------------------------------------- {{{
filetype off

" Set the runtime path to include Vundle and initialize
set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin("~/.config/nvim/bundle/")

Bundle 'altercation/vim-colors-solarized'
Bundle 'benekastah/neomake'
Bundle 'davidhalter/jedi-vim'
Bundle 'ervandew/supertab'
Bundle 'gerw/vim-latex-suite'
Bundle 'gmarik/Vundle.vim'
Bundle 'jalvesaq/Nvim-R'
Bundle 'jpalardy/vim-slime'
Bundle 'mattn/emmet-vim'
Bundle 'msanders/snipmate.vim'
Bundle 'pangloss/vim-javascript'
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/nerdtree'
Bundle 'Shougo/deoplete.nvim'
Bundle 'ternjs/tern_for_vim'
Bundle 'tpope/vim-fugitive'
Bundle 'vim-airline/vim-airline'
Bundle 'vim-airline/vim-airline-themes'

Bundle 'epwalsh/Evim'

" Bundle 'klen/python-mode'         " Clunky - use jedi-vim and neomake
" Bundle 'vim-scripts/AutoComplPop' " Use deoplete instead for async
" Bundle 'zchee/deoplete-jedi'      " Works like shit

call vundle#end()
filetype plugin indent on
" ------------------------------------------------------------------------- }}}

" Load plugin configuration files ----------------------------------------- {{{
for file in split(glob(Dot('modules/plugins/*.vim')), '\n')
    let name = fnamemodify(file, ':t:r')

    let bundles = g:vundle#bundles
    let plugins = map(bundles, "v:val['name']")

    if exists("plugins['" . name . "']")
        exec 'source' file
    else
        echom "No plugin found for config file " . file
    endif
endfor
" ------------------------------------------------------------------------- }}}
