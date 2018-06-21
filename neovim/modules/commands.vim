" Pandoc commands
command Pandoc call Knit_pandoc()

function! Knit_pandoc()
    execute "!pandoc -s --mathjax -c ../../main.css -c ../../math.css " . expand("%:p") . " -o " . expand("%:p:r") . "_preview.html"
    silent execute "!pandoc --mathjax " . expand("%:p") . " -o " . expand("%:p:r") . ".html"
endfunction
