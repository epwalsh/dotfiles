augroup mdip_settings
    autocmd!
    au FileType markdown command! PasteImg call mdip#MarkdownClipboardImage()<CR>
    au FileType markdown nnoremap <leader>p :PasteImg<CR>
augroup END
