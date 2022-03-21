" Recognize the right filetype for specific files.
augroup filetype_checks
    autocmd!
    au BufRead .clang-format set ft=yaml
    au BufRead Dockerfile.* set ft=dockerfile
    au BufRead *.conf set ft=conf
    au BufRead *.toml set ft=conf
    au BufRead *.jl set ft=julia
augroup END

" Miscellaneous config file settings -------------------------------------- {{{
augroup filetype_conf
    autocmd!
    au FileType conf setlocal shiftwidth=4 tabstop=4 expandtab
augroup END
" ------------------------------------------------------------------------- }}}

" Jsonnet file settings --------------------------------------------------- {{{
augroup filetype_jsonnet
    autocmd!
    au FileType jsonnet setlocal shiftwidth=4 tabstop=4 expandtab
augroup END
" ------------------------------------------------------------------------- }}}

" dosini file settings --------------------------------------------------- {{{
augroup filetype_dosini
    autocmd!
    au FileType dosini setlocal shiftwidth=4 tabstop=4 expandtab
augroup END
" ------------------------------------------------------------------------- }}}

" Vimscript file settings ------------------------------------------------- {{{
augroup filetype_vim
    autocmd!
    au FileType vim setlocal shiftwidth=4 tabstop=4 expandtab
    au FileType vim setlocal foldmethod=marker
augroup END
" ------------------------------------------------------------------------- }}}

" R settings -------------------------------------------------------------- {{{
augroup filetype_r
    autocmd!
    au FileType r,rmd setlocal shiftwidth=2 tabstop=2 expandtab
    au FileType r,rmd setlocal foldmethod=marker
augroup END
" ------------------------------------------------------------------------- }}}

" Latex settings ---------------------------------------------------------- {{{
augroup filetype_tex
    autocmd!
    au FileType tex  let b:autopairs_enabled=0
    au FileType tex  setlocal colorcolumn=150
    au FileType tex  setlocal shiftwidth=2 tabstop=2 expandtab
    au FileType tex  setlocal wrap linebreak nolist
    au BufNewFile *.tex 0r ~/.config/nvim/headers/template.tex
augroup END
" ------------------------------------------------------------------------- }}}

" C/Cpp settings ---------------------------------------------------------- {{{
augroup filetype_c
    autocmd!
    au FileType c    setlocal shiftwidth=4 tabstop=4 expandtab foldmethod=syntax
    au FileType cpp  setlocal shiftwidth=4 tabstop=4 expandtab foldmethod=syntax
augroup END
" ------------------------------------------------------------------------- }}}

" JavaScript settings ----------------------------------------------------- {{{
augroup filetype_js
    autocmd!
    au FileType javascript setlocal shiftwidth=4 tabstop=4 expandtab
    au FileType javascript setlocal foldmethod=marker
    " au FileType javascript setlocal omnifunc=javascriptcomplete#Complete
    au FileType javascript setlocal omnifunc=tern#Complete
augroup END
" ------------------------------------------------------------------------- }}}

" Dockerfile settings ----------------------------------------------------- {{{
augroup filetype_dockerfile
    autocmd!
    au FileType dockerfile setlocal shiftwidth=4 tabstop=4 expandtab
augroup END
" ------------------------------------------------------------------------- }}}

" Jenkinsfile settings ----------------------------------------------------- {{{
augroup filetype_jenkinsfile
    autocmd!
    au BufRead Jenkinsfile setlocal shiftwidth=2 tabstop=2 expandtab
augroup END
" ------------------------------------------------------------------------- }}}

" Swift settings --------------------------------------------------------- {{{
augroup filetype_swift
    autocmd!
    au FileType swift setlocal shiftwidth=4 tabstop=4 expandtab
augroup END
" ------------------------------------------------------------------------- }}}

" Python settings --------------------------------------------------------- {{{
augroup filetype_python
    autocmd!
    au FileType python setlocal shiftwidth=4 tabstop=4 expandtab
    au FileType python setlocal omnifunc=pythoncomplete#Complete
    au BufNewFile *.py,*.pyx 0r ~/.config/nvim/headers/template.py
augroup END
" ------------------------------------------------------------------------- }}}

" Kotlin settings --------------------------------------------------------- {{{
augroup filetype_kotlin
    autocmd!
    au FileType kotlin setlocal shiftwidth=4 tabstop=4 expandtab
augroup END
" ------------------------------------------------------------------------- }}}

" Julia settings ---------------------------------------------------------- {{{
augroup filetype_julia
    autocmd!
    au FileType julia setlocal shiftwidth=4 tabstop=4 expandtab
augroup END
" ------------------------------------------------------------------------- }}}

" yml settings ------------------------------------------------------------ {{{
augroup filetype_yml
    autocmd!
    au FileType yaml setlocal shiftwidth=2 tabstop=2 expandtab
    au FileType yaml setlocal wrap linebreak nolist
augroup END
" ------------------------------------------------------------------------- }}}

" Java settings ----------------------------------------------------------- {{{
augroup filetype_java
    autocmd!
    autocmd FileType java setlocal shiftwidth=4 tabstop=4 expandtab
    autocmd FileType java setlocal omnifunc=javacomplete#Complete
augroup END
" ------------------------------------------------------------------------- }}}

" HTML/CSS settings ------------------------------------------------------- {{{
augroup filetype_html
    autocmd!
    au FileType html setlocal shiftwidth=2 tabstop=2 expandtab
    au FileType html setlocal nowrap
    au FileType css  setlocal shiftwidth=4 tabstop=4 expandtab
    au FileType css  setlocal nowrap
    au FileType css setlocal foldmethod=marker
augroup END
" ------------------------------------------------------------------------- }}}

" JSON settings ----------------------------------------------------------- {{{
augroup filetype_json
    autocmd!
    au FileType json setlocal shiftwidth=4 tabstop=4 expandtab
    au FileType json setlocal conceallevel=0
augroup END
" ------------------------------------------------------------------------- }}}

" Markdown settings ------------------------------------------------------- {{{
function MaybeCreateLink()
    if has_key(v:completed_item, 'kind')
        if v:completed_item.kind == "[new]"
            CreateSilent
        endif
    endif
endfunction

augroup filetype_md
    autocmd!
    au FileType markdown setlocal shiftwidth=2 tabstop=2 expandtab
    au FileType markdown setlocal wrap linebreak nolist
    au FileType markdown setlocal omnifunc=
    au FileType markdown setlocal conceallevel=2
    au BufRead,BufNewFile ~/epwalsh-notes/* setlocal path+=~/epwalsh-notes/**
    au FileType markdown nnoremap gf :GoTo<cr>
    au FileType markdown nnoremap so :Open<cr>
    au FileType markdown nnoremap cr :Create<cr>
    au FileType markdown nnoremap dn :Done<cr>
    au FileType markdown nnoremap td :ToDo<cr>
    au FileType markdown nnoremap <leader>bl :Backlinks<cr>
    au FileType markdown nnoremap <leader>n :New<cr>
    au BufWritePre ~/epwalsh-notes/*.md Frontmatter
    au CompleteDone ~/epwalsh-notes/*.md call MaybeCreateLink()
    au BufNewFile ~/epwalsh-notes/*.md 0r ~/.config/nvim/headers/template.md
augroup END
set suffixesadd+=.md
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'rust']
" ------------------------------------------------------------------------- }}}

" Restructured text settings ---------------------------------------------- {{{
augroup filetype_rst
    autocmd!
    au FileType rst setlocal shiftwidth=4 tabstop=4 expandtab
augroup  END
" ------------------------------------------------------------------------- }}}

" Bash settings ----------------------------------------------------------- {{{
augroup filetype_bash
    autocmd!
    au FileType sh setlocal shiftwidth=4 tabstop=4 expandtab
    au FileType sh setlocal foldmethod=marker
augroup END
" ------------------------------------------------------------------------- }}}

" Fish settings ----------------------------------------------------------- {{{
augroup filetype_fish
    autocmd!
    au FileType fish setlocal shiftwidth=4 tabstop=4 expandtab
    " au FileType fish setlocal foldmethod=marker
augroup END
" ------------------------------------------------------------------------- }}}

" Go settings ----------------------------------------------------------- {{{
augroup filetype_go
    autocmd!
    au FileType go setlocal shiftwidth=4 tabstop=4
    " au FileType fish setlocal foldmethod=marker
augroup END
" ------------------------------------------------------------------------- }}}
