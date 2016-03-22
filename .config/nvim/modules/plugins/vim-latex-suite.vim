" =============================================================================
" File Name:     vim-latex-suite.vim
" Author:        Evan Pete Walsh
" Contact:       epwalsh10@gmail.com
" Creation Date: 21-03-2016
" Last Modified: Mon Mar 21 20:31:51 2016
" =============================================================================

set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'

augroup tex_mappings
    autocmd!
    au FileType tex nnoremap <leader>kk :!open %:p:r.pdf -a /Applications/Skim.app/<cr>
    au FileType tex nnoremap <leader>lu :!lualatex %:p<cr>
augroup END
