" Time in millis (default 250)
let g:Illuminate_delay = 250

let g:Illuminate_ftHighlightGroups = {
      \ 'vim': ['vimVar', 'vimString', 'vimLineComment',
      \         'vimFuncName', 'vimFunction', 'vimUserFunc', 'vimFunc']
      \ }

let g:Illuminate_ftblacklist = ['nerdtree']

highlight illuminatedWord cterm=bold ctermbg=236
