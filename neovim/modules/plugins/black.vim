if exists("g:repo") && filereadable(g:repo . '/.flake8')
    let line_length = systemlist("grep 'max-line-length' " . g:repo . '/.flake8')
    if len(line_length) == 1
        let black_linelength = split(line_length[0], " = ")[1]
        if black_linelength > 100
            let black_linelength = 100
        endif
        let g:black_linelength = black_linelength
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
