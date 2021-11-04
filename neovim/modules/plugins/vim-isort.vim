function! MaybeIsort()
    if !exists("b:isort_off") || b:isort_off != 1
        execute ':Isort'
    endif
endfunction

augroup python_isort
    autocmd!
    au BufWritePre *.py call MaybeIsort()
augroup END
