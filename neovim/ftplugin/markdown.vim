" General markdown settings.
"
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'rust']
setlocal suffixesadd+=.md
setlocal shiftwidth=2 tabstop=2 expandtab wrap linebreak nolist omnifunc= conceallevel=2

" Settings for an Obsidian vault.
"
function! MaybeCreateLink()
    if has_key(v:completed_item, 'kind')
        if v:completed_item.kind == "[new]"
            CreateSilent
        endif
    endif
endfunction

augroup obsidian_settings
    autocmd!
    au BufRead,BufNewFile ~/epwalsh-notes/* setlocal path+=~/epwalsh-notes/**
    au BufRead,BufNewFile ~/epwalsh-notes/* nnoremap gf :GoTo<cr>
    au BufRead,BufNewFile ~/epwalsh-notes/* nnoremap so :Open<cr>
    au BufRead,BufNewFile ~/epwalsh-notes/* nnoremap cr :Create<cr>
    au BufRead,BufNewFile ~/epwalsh-notes/* nnoremap dn :Done<cr>
    au BufRead,BufNewFile ~/epwalsh-notes/* nnoremap td :ToDo<cr>
    au BufRead,BufNewFile ~/epwalsh-notes/* nnoremap <leader>bl :Backlinks<cr>
    au BufRead,BufNewFile ~/epwalsh-notes/* nnoremap <leader>n :New<cr>
    au BufWritePre ~/epwalsh-notes/*.md Frontmatter
    au CompleteDone ~/epwalsh-notes/*.md call MaybeCreateLink()
    au BufNewFile ~/epwalsh-notes/*.md 0r ~/.config/nvim/headers/template.md
augroup END
