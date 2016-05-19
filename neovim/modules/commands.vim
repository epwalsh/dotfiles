" =============================================================================
" File Name:     commands.vim
" Author:        Evan Pete Walsh
" Contact:       epwalsh10@gmail.com
" Creation Date: 19-05-2016
" Last Modified: Thu May 19 12:11:19 2016
" =============================================================================

" Pandoc commands
command KnitS !pandoc -s --filter pandoc-eqnos %:p -o %:p:r_preview.html
command Knit !pandoc --filter pandoc-eqnos %:p -o %:p:r.html
