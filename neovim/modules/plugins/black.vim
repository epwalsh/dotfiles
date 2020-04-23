if exists("g:repo") && filereadable(g:repo . '/pyproject.toml')
    let line_length = systemlist("grep 'line-length' " . g:repo . '/pyproject.toml')
    if len(line_length) == 1
        let g:black_linelength = split(line_length[0], " = ")[1]
    endif
else
    let g:black_linelength = 88
endif

function! Black()
    if !exists("b:black_off") || b:black_off != 1
        execute ':Black'
    endif
endfunction

augroup python_black
    autocmd!
    au BufWritePre *.py call Black()
augroup END
