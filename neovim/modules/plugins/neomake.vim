" =============================================================================
" File Name:     neomake.vim
" Author:        Evan Pete Walsh
" Contact:       epwalsh10@gmail.com
" Creation Date: 21-03-2016
" Last Modified: 2016-08-20 14:31:55
" =============================================================================

autocmd! BufWritePost *.py Neomake
let g:neomake_open_list = 2
let g:neomake_list_height = 5
