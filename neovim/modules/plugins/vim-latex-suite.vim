" =============================================================================
" File Name:     vim-latex-suite.vim
" Creation Date: 21-03-2016
" Last Modified: 2017-06-15 12:19:27
" =============================================================================

set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'
let g:Tex_GotoError=0

augroup tex_mappings
    autocmd!
    au FileType tex nnoremap <leader>kk :!open %:p:r.pdf -a /Applications/Skim.app/<cr>
    au FileType tex nnoremap <leader>lu :!lualatex %:p<cr>
augroup END
