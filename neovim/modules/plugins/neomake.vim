autocmd! BufWritePost *.py Neomake
autocmd! BufWritePost *.sh Neomake
autocmd! BufWritePost *.cpp Neomake
autocmd! BufWritePost *.hpp Neomake

let g:neomake_open_list = 0
let g:neomake_list_height = 5

let repo = systemlist("git rev-parse --show-toplevel")[0]

" Change error/warning sign to something that works on both linux and OS X well.
let g:neomake_warning_sign = {'text': 'W>', 'texthl': 'airline_z'}
let g:neomake_error_sign = {'text': 'E>', 'texthl': 'airline_a'}
" Run :so $VIMRUNTIME/syntax/hitest.vim to show all highlight groups.


" C++ settings
" ========================================================================= {{{
let args = ['-Wall', '-pedantic', '-Wno-sign-conversion', '-Wno-c++11-extensions', '-std=c++11']

" If in a Git repository, add the root of the Git repo
if repo !~ "^fatal"
    call add(args, '-I' . repo . '/include')
endif

" Include Eigen and Boost.
call add(args, '-I' . '/usr/local/Cellar/eigen/3.3.4/include/eigen3')
call add(args, '-I' . '/usr/local/Cellar/boost/1.66.0/include')

let g:neomake_cpp_enabled_makers = ['clang']
let g:neomake_cpp_clang_maker = {
   \ 'exe': '/usr/local/opt/llvm/bin/clang++',
   \ 'args': args,
   \ }
" ========================================================================= }}}

" Python settings
" ========================================================================= {{{
let g:neomake_python_enabled_makers = ["mypy"]
let g:neomake_python_mypy_makers = {
            \ 'args': [
            \ '--ignore-missing-imports',
            \ ],
            \ }

" If in a repository, check for a .pylintrc file in the root.
if repo !~ "^fatal" && filereadable(repo . '/.pylintrc')
    let pylintrc = repo . '/.pylintrc'
else
    let pylintrc = '~/.config/.pylintrc'
endif
call add(g:neomake_python_enabled_makers, 'pylint')

let g:neomake_python_pylint_maker = {
            \ 'args': [
            \ '--rcfile', pylintrc,
            \ '--msg-template="{path}:{line}:{column}:{C}: [{symbol}] {msg}"',
            \ ],
            \ }

" If in repo, check for .pydocstyle config, otherwise ignore.
if repo !~ "^fatal" && filereadable(repo . '/.pydocstyle')
    let pydocstyle = repo . '/.pydocstyle'
    let g:neomake_python_pydocstyle_maker = {
                \ 'args': [
                \ '--config', pydocstyle,
                \ ],
                \ 'errorformat': '%W%f:%l %.%#:,%+C %m',
                \ }
    call add(g:neomake_python_enabled_makers, 'pydocstyle')
endif
" ========================================================================= }}}

" Shell/Bash settings
" ========================================================================= {{{
let g:neomake_sh_enabled_makers = ["shellcheck"]
let g:neomake_sh_shellcheck_maker = {
            \ 'args': ['-fgcc'],
            \ 'errorformat':
                \ '%f:%l:%c: %trror: %m,' .
                \ '%f:%l:%c: %tarning: %m,' .
                \ '%f:%l:%c: %tote: %m'
            \}
" ========================================================================= }}}
