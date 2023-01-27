setlocal shiftwidth=4 tabstop=4 expandtab omnifunc=pythoncomplete#Complete
setlocal foldmethod=expr
setlocal foldexpr=nvim_treesitter#foldexpr()
setlocal foldnestmax=2
setlocal spell

" Don't automatically adjust indentation when typing ':'
" Need to do this in an autocmd. See https://stackoverflow.com/a/37889460/4151392
autocmd FileType python setlocal indentkeys-=<:> indentkeys+==else:
