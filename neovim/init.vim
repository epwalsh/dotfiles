" nvimrc / init.vim
" This is equivalent to a .vimrc for vim.
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
