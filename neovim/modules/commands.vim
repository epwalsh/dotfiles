" =============================================================================
" File Name:     commands.vim
" Author:        Evan Pete Walsh
" Contact:       epwalsh10@gmail.com
" Creation Date: 19-05-2016
" Last Modified: 2016-06-17 16:28:42
" =============================================================================

" Pandoc commands
command Pandoc call Knit_pandoc()

function! Knit_pandoc()
    execute "!pandoc -s --mathjax -c ../../main.css -c ../../math.css " . expand("%:p") . " -o " . expand("%:p:r") . "_preview.html"
    silent execute "!pandoc --mathjax " . expand("%:p") . " -o " . expand("%:p:r") . ".html"
endfunction
