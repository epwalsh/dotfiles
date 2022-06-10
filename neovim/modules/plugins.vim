" Vim-plug package manager -------------------------------------------------- {{{
call plug#begin("~/.config/nvim/plugged/")

" Package manager.
" Plug 'gmarik/Vundle.vim'

" Theme and appearance --- {{{

" Solarized theme.
Plug 'altercation/vim-colors-solarized'

" Status line theme.
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Setting tmux status line theme to match Vim status line theme.
" Plug 'edkolev/tmuxline.vim'

" Illuminate words matching current word under cursor.
Plug 'rrethy/vim-illuminate'

" CSV column highlighting + RBQL.
" Plug 'mechatroner/rainbow_csv'

" Better folding for Python.
Plug 'tmhedberg/SimpylFold'

" Markdown section folding.
" Plug 'masukomi/vim-markdown-folding'

" A bunch of markdown stuff, including folding.
Plug 'plasticboy/vim-markdown'

" --- }}}

" General language tools --- {{{

" Language Client. TODO: won't need this anymore once we update neovim to 0.5.
" Plug 'autozimu/LanguageClient-neovim', {
"     \ 'branch': 'next',
"     \ 'do': 'bash install.sh',
"     \ }

" Async linting and other stuff.
Plug 'benekastah/neomake'

" Using tab for insertion.
Plug 'ervandew/supertab'

" Sending code to an interpreter for any language.
Plug 'jalvesaq/vimcmdline'
" Plug 'epwalsh/vimcmdline'

" Auto-complete pairs.
Plug 'jiangmiao/auto-pairs'

" Changing surroundings.
Plug 'tpope/vim-surround'

" Bindings for commenting out.
Plug 'scrooloose/nerdcommenter'

" File navigation.
Plug 'scrooloose/nerdtree'

" Autocompletion.
Plug 'Shougo/deoplete.nvim'

" Snippets.
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'

" Automatic aligning.
Plug 'junegunn/vim-easy-align'

" Emojis.
" Plug 'junegunn/vim-emoji'

" --- }}}

" Other workflow tools --- {{{

" Git.
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Rename the current file.
Plug 'wojtekmach/vim-rename'

" fzf.
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

" --- }}}

" Language specific tools --- {{{

" Rust.
Plug 'rust-lang/rust.vim'

" Python.
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'zchee/deoplete-jedi'
Plug 'davidhalter/jedi-vim'
" Plug 'psf/black'
" Plug 'EgZvor/vim-black', { 'branch': 'main' }
" Plug 'fisadev/vim-isort'

" Fish
Plug 'dag/vim-fish'

" Go.
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" LaTeX.
Plug 'gerw/vim-latex-suite'

" Jsonnet.
Plug 'google/vim-jsonnet'

" R.
" Plug 'jalvesaq/Nvim-R'

" --- }}}

call plug#end()
" ------------------------------------------------------------------------- }}}

filetype plugin indent on

" Load plugin configuration files ----------------------------------------- {{{
for file in split(glob(Dot('modules/plugins/*.vim')), '\n')
    exec 'source' file
endfor
" ------------------------------------------------------------------------- }}}
