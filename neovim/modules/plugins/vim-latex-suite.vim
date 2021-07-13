set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'
let g:Tex_GotoError=0
let g:tex_conceal = ""

augroup tex_mappings
    autocmd!
    if has("macunix")
        au FileType tex nnoremap <leader>kk :!open %:p:r.pdf -a /Applications/Skim.app/<cr>
    else
        au FileType tex nnoremap <leader>kk :!xdg-open %:p:r.pdf<cr>
    endif
    au FileType tex nnoremap <leader>lu :!lualatex %:p<cr>
    au BufWritePost *.tex :!lualatex %:p
augroup END
