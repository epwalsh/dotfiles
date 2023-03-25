" Plugins.
"

call plug#begin("~/.config/nvim/plugged/")

" Theme.
Plug 'marko-cerovac/material.nvim'

" Status line.
Plug 'nvim-lualine/lualine.nvim'

" Interface for tree-sitter that other plugins can build off of.
" Includes better folding and syntax highlighting.
" See 'ftplugin/python.vim' for an example of how to configure folding.
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" This is useful for figuring out how treesitter is highlighting elements.
" Toggle it with ':TSPlaygroundToggle'
Plug 'nvim-treesitter/playground'

" Syntax highlighting for markdown.
Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'

" Paste images into Markdown.
Plug 'ferrine/md-img-paste.vim', { 'for': 'markdown' }

" Automatically manages LSP servers.
Plug 'williamboman/mason.nvim'

" Quickstart configs for LSP.
Plug 'neovim/nvim-lspconfig'

" Highlight word under cursor.
Plug 'RRethy/vim-illuminate'

" LSP renaming with immediate preview as you type.
Plug 'smjonas/inc-rename.nvim'

" Show LSP progress.
Plug 'j-hui/fidget.nvim'

" Shows a lightbulb whenever a text doc / code action is available.
Plug 'kosayoda/nvim-lightbulb'

" A pretty list for showing issues / quickfix / location lists.
" Use `:Trouble` to open.
Plug 'folke/trouble.nvim'
Plug 'kyazdani42/nvim-web-devicons'

" Improves the default vim.ui interface.
Plug 'stevearc/dressing.nvim'

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
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
Plug 'lambdalisue/glyph-palette.vim'
Plug 'lambdalisue/fern-hijack.vim'
Plug 'yuki-yano/fern-preview.vim'
Plug 'lambdalisue/fern-git-status.vim'
Plug 'LumaKernel/fern-mapping-fzf.vim'

" Autocompletion.
Plug 'hrsh7th/nvim-cmp'
Plug 'onsails/lspkind.nvim'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-calc'
Plug 'hrsh7th/cmp-emoji'
Plug 'uga-rosa/cmp-dictionary'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'rafamadriz/friendly-snippets'

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
" Alternative to the above, at least for Obsidian, but fern-mapping-fzf needs
" fzf.vim for now.
" Plug 'ibhagwan/fzf-lua'

" Dependency of obsidian and others.
Plug 'nvim-lua/plenary.nvim'

" telescope, does a lot of the same things as fzf
Plug 'nvim-telescope/telescope.nvim'

" Rust.
Plug 'simrat39/rust-tools.nvim', { 'for': 'rust' }

" Fish
Plug 'dag/vim-fish', { 'for': 'fish' }

" Go.
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'for': 'go' }

" Lua.
Plug 'ckipp01/stylua-nvim', { 'do': 'cargo install stylua' }

" Python
Plug 'Vimjas/vim-python-pep8-indent'

" Jsonnet.
" To get automatic formatting, you also need to install jsonnetfmt.
" AFAIK the only way to do that is with go:
"   > go get github.com/google/go-jsonnet/cmd/jsonnetfmt
Plug 'google/vim-jsonnet', { 'for': 'jsonnet' }

Plug '~/github.com/epwalsh/obsidian.nvim'

" Use <leader>b to open a list of open buffers. <ENTER> to open a buffer in
" the list, <SHIFT>o to preview.
Plug 'jeetsukumaran/vim-buffergator'

call plug#end()

filetype plugin indent on
