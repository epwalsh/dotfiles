" =============================================================================
" File Name:     filetypes.vim
" Author:        Evan Pete Walsh
" Contact:       epwalsh10@gmail.com
" Creation Date: 21-03-2016
" Last Modified: Mon Mar 21 20:32:06 2016
" =============================================================================


" Vimscript file settings ------------------------------------------------- {{{
augroup filetype_vim
    autocmd!
    au FileType vim setlocal shiftwidth=4 tabstop=4 expandtab
    au FileType vim setlocal foldmethod=marker
    au BufWritePre,FileWritePre *.vimrc execute "normal ma"
    au BufWritePre,FileWritePre *.vimrc execute "1," . 8 .
                \"g/Last Modified:.*/s/Last Modified:.*/Last Modified: "
                \.strftime("%c")
    au BufWritePost,FileWritePost *.vimrc execute "normal `a"
augroup END
" ------------------------------------------------------------------------- }}}

" R settings -------------------------------------------------------------- {{{
augroup filetype_r
    autocmd!
    setlocal shiftwidth=2 tabstop=2 expandtab
    setlocal foldmethod=marker
augroup END
" ------------------------------------------------------------------------- }}}

" Latex settings ---------------------------------------------------------- {{{
augroup filetype_tex
    autocmd!
    au BufRead *.tex set tw=150
    au FileType tex  set tw=150
    au FileType tex  setlocal colorcolumn=150
    au FileType tex  setlocal shiftwidth=2 tabstop=2 expandtab
augroup END
" ------------------------------------------------------------------------- }}}

" C/Cpp settings ---------------------------------------------------------- {{{
augroup filetype_c
    autocmd!
    au FileType c    setlocal shiftwidth=4 tabstop=4 expandtab
    au FileType cpp  setlocal shiftwidth=4 tabstop=4 expandtab
    au BufRead *.h   setlocal shiftwidth=4 tabstop=4 expandtab
    au BufRead *.hpp setlocal shiftwidth=4 tabstop=4 expandtab
    au FileType make setlocal noexpandtab shiftwidth=8 softtabstop=0
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

" Python settings --------------------------------------------------------- {{{
augroup filetype_python
    autocmd!
    au FileType python setlocal shiftwidth=4 tabstop=4 expandtab
    au FileType python setlocal omnifunc=pythoncomplete#Complete
    au FileType python setlocal foldmethod=marker
augroup END
" ------------------------------------------------------------------------- }}}

" HTML/CSS settings ------------------------------------------------------- {{{
augroup filetype_html
    autocmd!
    au FileType html setlocal shiftwidth=2 tabstop=2 expandtab
    au FileType html setlocal nowrap
    au FileType css  setlocal shiftwidth=4 tabstop=4 expandtab
    au FileType css  setlocal nowrap
augroup END
" ------------------------------------------------------------------------- }}}

" Bash settings ----------------------------------------------------------- {{{
augroup filetype_bash
    autocmd!
    au FileType sh setlocal shiftwidth=4 tabstop=4 expandtab
    au FileType sh setlocal foldmethod=marker
augroup END
" ------------------------------------------------------------------------- }}}

" .tmux.conf file settings ------------------------------------------------ {{{
augroup tmux_dotfiles
    autocmd!
    au BufRead *.tmux.conf setlocal foldmethod=marker
    au BufWritePre,FileWritePre *.tmux.conf execute "normal ma"
    au BufWritePre,FileWritePre *.tmux.conf execute "1," . 10 .
                \"g/Last Modified:.*/s/Last Modified:.*/Last Modified: "
                \.strftime("%c")
    au BufWritePost,FileWritePost *.tmux.conf execute "normal `a"
augroup END
" ------------------------------------------------------------------------- }}}

" .bash_profile/.bashrc file settings ------------------------------------- {{{
augroup bash_dotfiles
    autocmd!
     au BufWritePre,FileWritePre *.bash_profile execute "normal ma"
     au BufWritePre,FileWritePre *.bash_profile execute "1," . 10 .
                \"g/Last Modified:.*/s/Last Modified:.*/Last Modified: "
                \.strftime("%c")
    au BufWritePost,FileWritePost *.bash_profile execute "normal `a"
    au BufWritePre,FileWritePre *.bashrc execute "normal ma"
    au BufWritePre,FileWritePre *.bashrc execute "1," . 10 .
                \"g/Last Modified:.*/s/Last Modified:.*/Last Modified: "
                \.strftime("%c")
    au BufWritePost,FileWritePost *.bashrc execute "normal `a"
augroup END
" ------------------------------------------------------------------------- }}}
