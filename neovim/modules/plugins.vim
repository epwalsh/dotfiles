" =============================================================================
" File Name:     plugins.vim
" Author:        Evan Pete Walsh
" Contact:       epwalsh10@gmail.com
" Creation Date: 21-03-2016
" Last Modified: 2017-03-28 19:31:52
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
Bundle 'jalvesaq/vimcmdline'
Bundle 'jalvesaq/Nvim-R'
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
Bundle 'Vimjas/vim-python-pep8-indent'

" Bundle 'epwalsh/Evim'
Bundle 'epwalsh/NvimAutoheader'

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
