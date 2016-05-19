" =============================================================================
" File Name:     commands.vim
" Author:        Evan Pete Walsh
" Contact:       epwalsh10@gmail.com
" Creation Date: 19-05-2016
" Last Modified: Thu May 19 15:23:53 2016
" =============================================================================

" Pandoc commands
" command KnitS !pandoc -s --mathjax -c ../../main.css %:p -o %:p:r_preview.html
" command Knit !pandoc --mathjax %:p -o %:p:r.html
command Pandoc call Knit_pandoc()

function! Knit_pandoc()
    execute "!pandoc -s --mathjax -c ../../main.css " . expand("%:p") . " -o " . expand("%:p:r") . "_preview.html"
    silent execute "!pandoc --mathjax " . expand("%:p") . " -o " . expand("%:p:r") . ".html"
endfunction
