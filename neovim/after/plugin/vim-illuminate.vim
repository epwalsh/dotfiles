let g:Illuminate_delay = 250
let g:Illuminate_ftHighlightGroups = {
      \ 'vim': ['vimVar', 'vimString', 'vimLineComment',
      \         'vimFuncName', 'vimFunction', 'vimUserFunc', 'vimFunc']
      \ }
let g:Illuminate_ftblacklist = ['nerdtree', 'fern']
highlight illuminatedWord cterm=bold ctermbg=236
nnoremap <c-j> :lua require("illuminate").next_reference({wrap=true})<cr>
nnoremap <c-k> :lua require("illuminate").next_reference({reverse=true,wrap=true})<cr>
