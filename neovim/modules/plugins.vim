" Vim-plug package manager -------------------------------------------------- {{{
call plug#begin("~/.config/nvim/plugged/")

" Color theme.
Plug 'altercation/vim-colors-solarized'

" Plug 'artur-shaik/vim-javacomplete2'

" Async linting and other stuff.
Plug 'benekastah/neomake'

" Fish
Plug 'dag/vim-fish'

" Setting tmux theme to match Vim theme.
Plug 'edkolev/tmuxline.vim'

" Using tab for insertion.
Plug 'ervandew/supertab'

" Plug 'epwalsh/NvimAutoheader'

" Go.
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" LaTeX files.
Plug 'gerw/vim-latex-suite'

" Package manager.
Plug 'gmarik/Vundle.vim'

" Jsonnet filetype.
Plug 'google/vim-jsonnet'

" Plug 'jaxbot/github-issues.vim'

" Sending code to an interpreter for any language.
Plug 'jalvesaq/vimcmdline'
" Plug 'epwalsh/vimcmdline'

" R REPL + a lot of other stuff.
Plug 'jalvesaq/Nvim-R'

" Previewing markdown files.
Plug 'JamshedVesuna/vim-markdown-preview'

" Auto-complete pairs.
Plug 'jiangmiao/auto-pairs'

Plug 'JuliaEditorSupport/julia-vim'

" HTML files.
Plug 'mattn/emmet-vim'

" CSV column highlighting + RBQL.
Plug 'mechatroner/rainbow_csv'
 
" Command line tool for math that runs Python in Vim session.
Plug 'metakirby5/codi.vim'

" Javascript bundle. Comes with syntax highlighting, improved indentation.
Plug 'pangloss/vim-javascript'

" Code completion in Rust.
Plug 'racer-rust/vim-racer'

" Check C and C++ files.
Plug 'rhysd/vim-clang-format'

" Illuminate words matching current word under cursor.
Plug 'rrethy/vim-illuminate'

" Rust.
Plug 'rust-lang/rust.vim'

" Deopletion for Rust.
" Plug 'sebastianmarkow/deoplete-rust'

" Bindings for commenting out.
Plug 'scrooloose/nerdcommenter'

" File navigation.
Plug 'scrooloose/nerdtree'

" Autocompletion.
Plug 'Shougo/deoplete.nvim'

" Snippets.
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'

" Folding.
Plug 'tmhedberg/SimpylFold'

" Git.
Plug 'tpope/vim-fugitive'

" Changing surroundings.
Plug 'tpope/vim-surround'

" Kotlin lang
" Plug 'udalov/kotlin-vim'
Plug 'epwalsh/kotlin-vim'

" Status bar theme.
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Better Python indenting.
Plug 'Vimjas/vim-python-pep8-indent'

" Renaming variables.
Plug 'wojtekmach/vim-rename'

" Python autocompletion.
Plug 'zchee/deoplete-jedi'
Plug 'davidhalter/jedi-vim'

" Python autoformatting.
Plug 'psf/black', { 'commit': 'ce14fa8b497bae2b50ec48b3bd7022573a59cdb1' }


call plug#end()
" ------------------------------------------------------------------------- }}}

filetype plugin indent on

" Load plugin configuration files ----------------------------------------- {{{
for file in split(glob(Dot('modules/plugins/*.vim')), '\n')
    exec 'source' file
endfor
" ------------------------------------------------------------------------- }}}
