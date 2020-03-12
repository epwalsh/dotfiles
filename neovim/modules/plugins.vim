" Vundle package manager -------------------------------------------------- {{{
filetype off

set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin("~/.config/nvim/bundle/")

" Color theme.
Bundle 'altercation/vim-colors-solarized'

" Bundle 'artur-shaik/vim-javacomplete2'

" Async linting and other stuff.
Bundle 'benekastah/neomake'

" Setting tmux theme to match Vim theme.
Bundle 'edkolev/tmuxline.vim'

" Using tab for insertion.
Bundle 'ervandew/supertab'

" Bundle 'epwalsh/NvimAutoheader'

" LaTeX files.
Bundle 'gerw/vim-latex-suite'

" Package manager.
Bundle 'gmarik/Vundle.vim'

" Jsonnet filetype.
Bundle 'google/vim-jsonnet'

" Bundle 'jaxbot/github-issues.vim'

" Sending code to an interpreter for any language.
Bundle 'jalvesaq/vimcmdline'
" Bundle 'epwalsh/vimcmdline'

" R REPL + a lot of other stuff.
Bundle 'jalvesaq/Nvim-R'

" Previewing markdown files.
Bundle 'JamshedVesuna/vim-markdown-preview'

" Auto-complete pairs.
Bundle 'jiangmiao/auto-pairs'

Bundle 'JuliaEditorSupport/julia-vim'

" Swift syntax highlighting and indentation.
Bundle "keith/swift.vim"

" HTML files.
Bundle 'mattn/emmet-vim'

" CSV column highlighting + RBQL.
Bundle 'mechatroner/rainbow_csv'
 
" Command line tool for math that runs Python in Vim session.
Bundle 'metakirby5/codi.vim'

" Javascript bundle. Comes with syntax highlighting, improved indentation.
Bundle 'pangloss/vim-javascript'

" Code completion in Rust.
Bundle 'racer-rust/vim-racer'

" Check C and C++ files.
Bundle 'rhysd/vim-clang-format'

" Illuminate words matching current word under cursor.
Bundle 'rrethy/vim-illuminate'

" Rust.
Bundle 'rust-lang/rust.vim'

" Deopletion for Rust.
" Bundle 'sebastianmarkow/deoplete-rust'

" Bindings for commenting out.
Bundle 'scrooloose/nerdcommenter'

" File navigation.
Bundle 'scrooloose/nerdtree'

" Autocompletion.
Bundle 'Shougo/deoplete.nvim'

" Snippets.
Bundle 'Shougo/neosnippet.vim'
Bundle 'Shougo/neosnippet-snippets'

" Folding.
Bundle 'tmhedberg/SimpylFold'

" Git.
Bundle 'tpope/vim-fugitive'

" Changing surroundings.
Bundle 'tpope/vim-surround'

" Kotlin lang
" Bundle 'udalov/kotlin-vim'
Bundle 'epwalsh/kotlin-vim'

" Status bar theme.
Bundle 'vim-airline/vim-airline'
Bundle 'vim-airline/vim-airline-themes'

" Better Python indenting.
Bundle 'Vimjas/vim-python-pep8-indent'

" Renaming variables.
Bundle 'wojtekmach/vim-rename'

" Python autocompletion.
Bundle 'zchee/deoplete-jedi'
Bundle 'davidhalter/jedi-vim'

" Python autoformatting.
Bundle 'psf/black'


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
