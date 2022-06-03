" Check group of text under cursor.
function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

function! Format()
    normal m`
    %!isort --stdout --filename % --quiet - | black --stdin-filename % --quiet -
    normal ``
endfunc
