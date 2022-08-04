setlocal shiftwidth=4 tabstop=4 expandtab omnifunc=pythoncomplete#Complete
setlocal indentkeys-=<:> " Don't automatically adjust indentation when typing ':'

function! PyFormat()
    set shellredir=>
    normal m`
    %!isort --stdout --filename % --quiet - | black --stdin-filename % --quiet -
    normal ``
    call SimpylFold#Recache()
    normal zx
endfunc

augroup python_settings
    autocmd!
    au BufWritePre *.py call PyFormat()
augroup END
