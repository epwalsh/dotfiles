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
    if has("macunix")
        au FileType tex nnoremap <leader>kk :!open %:p:r.pdf -a /Applications/Skim.app/<cr>
    else
        au FileType tex nnoremap <leader>kk :!xdg-open %:p:r.pdf<cr>
    endif
    au FileType tex nnoremap <leader>lu :!lualatex %:p<cr>
augroup END
