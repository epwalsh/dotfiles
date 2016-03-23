" =============================================================================
" File Name:     plugins.vim
" Author:        Evan Pete Walsh
" Contact:       epwalsh10@gmail.com
" Creation Date: 21-03-2016
" Last Modified: Wed Mar 23 15:31:56 2016
" =============================================================================

" Vundle package manager -------------------------------------------------- {{{
filetype off

set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin("~/.config/nvim/bundle/")

Bundle 'altercation/vim-colors-solarized'
Bundle 'benekastah/neomake'
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
Bundle 'zchee/deoplete-jedi'

Bundle 'epwalsh/Evim'

" Bundle 'davidhalter/jedi-vim'     " Replaced with deoplete-jedi
" Bundle 'klen/python-mode'         " Clunky - use jedi-vim and neomake
" Bundle 'vim-scripts/AutoComplPop' " Use deoplete instead for async

call vundle#end()
filetype plugin indent on
" ------------------------------------------------------------------------- }}}

" Load plugin configuration files ----------------------------------------- {{{
for file in split(glob(Dot('modules/plugins/*.vim')), '\n')
    let name = fnamemodify(file, ':t:r')

    let bundles = deepcopy(g:vundle#bundles)
    let plugins = map(bundles, "fnamemodify(v:val['name'], ':r')")

    if index(plugins, name) >= 0
        exec 'source' file
    else
        echom "No plugin found for config file " . file
    endif
endfor
" ------------------------------------------------------------------------- }}}
