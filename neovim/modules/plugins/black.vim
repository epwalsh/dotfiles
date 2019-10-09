let g:black_linelength = 88

function! Black()
    if !exists("b:black_off") || b:black_off != 1
        execute ':Black'
    endif
endfunction

augroup python_black
    autocmd!
    au BufWritePre *.py call Black()
augroup END
