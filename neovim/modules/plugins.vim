" Plugins.
"

call plug#begin("~/.config/nvim/plugged/")

" Solarized theme.
Plug 'altercation/vim-colors-solarized'

" Status line theme.
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Setting tmux status line theme to match Vim status line theme.
" Plug 'edkolev/tmuxline.vim'

" Illuminate words matching current word under cursor.
Plug 'rrethy/vim-illuminate'

" Better folding for Python.
Plug 'tmhedberg/SimpylFold'

" A bunch of markdown stuff, including folding.
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }

" Paste images into Markdown.
Plug 'ferrine/md-img-paste.vim', { 'for': 'markdown' }

" Automatically manages LSP servers.
Plug 'williamboman/mason.nvim'

" Quickstart configs for LSP.
Plug 'neovim/nvim-lspconfig'

" Show LSP progress.
Plug 'j-hui/fidget.nvim'

" Shows a lightbulb whenever a text doc / code action is available.
Plug 'kosayoda/nvim-lightbulb'

" A pretty list for showing issues / quickfix / location lists.
" Use `:Trouble` to open.
Plug 'folke/trouble.nvim'

" Provides a nice menu for code actions.
" Use `:CodeActionMenu` to open.
Plug 'weilbith/nvim-code-action-menu'

" Async linting and other stuff.
Plug 'benekastah/neomake'

" Using tab for insertion.
Plug 'ervandew/supertab'

" Sending code to an interpreter for any language.
Plug 'jalvesaq/vimcmdline'

" Auto-complete pairs.
Plug 'jiangmiao/auto-pairs'

" Changing surroundings.
Plug 'tpope/vim-surround'

" Bindings for commenting out.
Plug 'scrooloose/nerdcommenter'

" File navigation.
Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/fern.vim', {
    \ 'branch': 'main',
    \ }
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
Plug 'lambdalisue/glyph-palette.vim'
Plug 'lambdalisue/fern-hijack.vim'
Plug 'yuki-yano/fern-preview.vim'
Plug 'lambdalisue/fern-git-status.vim'
Plug 'LumaKernel/fern-mapping-fzf.vim'

" Autocompletion.
Plug 'hrsh7th/cmp-buffer', {
    \ 'branch': 'main',
    \ }
Plug 'hrsh7th/cmp-nvim-lsp', {
    \ 'branch': 'main',
    \ }
Plug 'hrsh7th/cmp-nvim-lsp-signature-help', {
    \ 'branch': 'main',
    \ }
Plug 'hrsh7th/cmp-path', {
    \ 'branch': 'main',
    \ }
Plug 'hrsh7th/cmp-vsnip', {
    \ 'branch': 'main',
    \ }
Plug 'hrsh7th/nvim-cmp', {
    \ 'branch': 'main',
    \ }
Plug 'hrsh7th/vim-vsnip-integ', {
    \ 'branch': 'main',
    \ }

" Automatic aligning.
Plug 'junegunn/vim-easy-align'

" Git.
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'ruanyl/vim-gh-line'

" Rename the current file.
Plug 'wojtekmach/vim-rename'

" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Rust.
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'simrat39/rust-tools.nvim', { 'for': 'rust' }

" Python.
Plug 'Vimjas/vim-python-pep8-indent', { 'for': 'python' }
Plug 'davidhalter/jedi-vim', { 'for': 'python' }

" Fish
Plug 'dag/vim-fish', { 'for': 'fish' }

" Go.
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'for': 'go' }

" Jsonnet.
" To get automatic formatting, you also need to install jsonnetfmt.
" AFAIK the only way to do that is with go:
"   > go get github.com/google/go-jsonnet/cmd/jsonnetfmt
Plug 'google/vim-jsonnet', { 'for': 'jsonnet' }

call plug#end()

filetype plugin indent on
