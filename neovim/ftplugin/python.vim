setlocal shiftwidth=4 tabstop=4 expandtab omnifunc=pythoncomplete#Complete
setlocal indentkeys-=<:> " Don't automatically adjust indentation when typing ':'
setlocal foldmethod=expr
setlocal foldexpr=nvim_treesitter#foldexpr()
setlocal foldnestmax=2
