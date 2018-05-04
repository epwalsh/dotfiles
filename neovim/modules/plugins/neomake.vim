autocmd! BufWritePost *.py Neomake
autocmd! BufWritePost *.cpp Neomake
autocmd! BufWritePost *.hpp Neomake

let g:neomake_open_list = 2
let g:neomake_list_height = 5

let args = ['-Wall', '-pedantic', '-Wno-sign-conversion', '-Wno-c++11-extensions', '-std=c++11']

" If in a Git repository, add the root of the Git repo
let repo = systemlist("git rev-parse --show-toplevel")[0]
if repo !~ "^fatal"
    call add(args, '-I' . repo)
endif

let g:neomake_cpp_enabled_makers = ['clang']
let g:neomake_cpp_clang_maker = {
   \ 'exe': 'clang++',
   \ 'args': args,
   \ }
