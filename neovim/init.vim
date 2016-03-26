" The nvimrc/init.vim of Evan Pete Walsh >> epwalsh.com :: epwalsh10@gmail.com
"
" 'I always thought air was free until I bought a bag of chips.' - Unknown
"
" Last Modified: Mon Mar 21 21:58:30 2016
" =============================================================================

" Wraps paths to make them relative to this directory --------------------- {{{
function! Dot(path)
  return '~/.config/nvim/' . a:path
endfunction
" ------------------------------------------------------------------------- }}}

" Load configuration modules ---------------------------------------------- {{{
for file in split(glob(Dot('modules/*.vim')), '\n')
  execute 'source' file
endfor
" ------------------------------------------------------------------------- }}}
