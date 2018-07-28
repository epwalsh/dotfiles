" Vundle package manager -------------------------------------------------- {{{
filetype off

set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin("~/.config/nvim/bundle/")

Bundle 'altercation/vim-colors-solarized'
" Bundle 'artur-shaik/vim-javacomplete2'
Bundle 'benekastah/neomake'
Bundle 'ervandew/supertab'
Bundle 'epwalsh/NvimAutoheader'
Bundle 'epwalsh/vimcmdline'
Bundle 'gerw/vim-latex-suite'
Bundle 'gmarik/Vundle.vim'
" Bundle 'jaxbot/github-issues.vim'
" Bundle 'jalvesaq/vimcmdline'
Bundle 'jalvesaq/Nvim-R'
Bundle 'JamshedVesuna/vim-markdown-preview'
Bundle 'jiangmiao/auto-pairs'
Bundle 'JuliaEditorSupport/julia-vim'
Bundle 'mattn/emmet-vim'
Bundle 'metakirby5/codi.vim'
Bundle 'rhysd/vim-clang-format'
Bundle 'rrethy/vim-illuminate'
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/nerdtree'
Bundle 'Shougo/deoplete.nvim'
Bundle 'Shougo/neosnippet.vim'
Bundle 'Shougo/neosnippet-snippets'
Bundle 'tmhedberg/SimpylFold'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-surround'
Bundle 'vim-airline/vim-airline'
Bundle 'vim-airline/vim-airline-themes'
Bundle 'Vimjas/vim-python-pep8-indent'
Bundle 'wojtekmach/vim-rename'
Bundle 'zchee/deoplete-jedi'
Bundle 'davidhalter/jedi-vim'


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
