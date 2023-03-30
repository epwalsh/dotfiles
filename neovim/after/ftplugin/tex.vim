let b:autopairs_enabled=0
setlocal spell colorcolumn=150 shiftwidth=2 tabstop=2 expandtab wrap linebreak nolist

augroup tex_settings
    autocmd!
    au BufNewFile *.tex 0r ~/.config/nvim/headers/template.tex
augroup END
