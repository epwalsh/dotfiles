" Default linelength.
let g:black_linelength = 88

" Helper function to grab the line-length from a pyproject.toml file.
function! SetBlackLinelengthFromPyproject(filepath)
    let line_length = systemlist("grep 'line-length' " . a:filepath)
    if len(line_length) == 1
        let g:black_linelength = split(line_length[0], " = ")[1]
    endif
endfunction

" Try to find a pyproject.toml file if this is a git repo.
if exists("g:repo")
    " Get path to current file being edited.
    let buffer_path = expand("%:p")
    if empty(buffer_path)
        let buffer_path = getcwd() . '/.'
    endif

    let buffer_path_parts = split(buffer_path, '/')

    " Traverse up through the git repo starting at the current directory,
    " looking for a pyproject.toml file in each subdirectory.
    for index in reverse(range(len(buffer_path_parts) - 1))
        let directory = '/' . join(buffer_path_parts[0:index], '/')
        let potential_pyproject_path = directory . '/pyproject.toml'

        if filereadable(potential_pyproject_path)
            call SetBlackLinelengthFromPyproject(potential_pyproject_path)
            break
        endif

        " If we've reached the git repo root and still haven't found a
        " pyproject.toml, quit.
        if directory == g:repo
            break
        endif
    endfor
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
