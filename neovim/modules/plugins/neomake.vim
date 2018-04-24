" =============================================================================
" File Name:     neomake.vim
" Creation Date: 21-03-2016
" Last Modified: 2017-06-15 12:18:51
" =============================================================================

autocmd! BufWritePost *.py Neomake
autocmd! BufWritePost *.cpp Neomake
autocmd! BufWritePost *.hpp Neomake

let g:neomake_open_list = 2
let g:neomake_list_height = 5

let g:neomake_cpp_enabled_makers = ['clang']
let g:neomake_cpp_clang_maker = {
   \ 'exe': 'clang++',
   \ 'args': ['-Wall', '-pedantic', '-Wno-sign-conversion', '-Wno-c++11-extensions', '-std=c++11'],
   \ }
