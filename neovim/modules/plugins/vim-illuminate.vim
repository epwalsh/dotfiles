" Time in millis (default 250)
let g:Illuminate_delay = 250

let g:Illuminate_ftHighlightGroups = {
      \ 'vim': ['vimVar', 'vimString', 'vimLineComment',
      \         'vimFuncName', 'vimFunction', 'vimUserFunc', 'vimFunc']
      \ }

let g:Illuminate_ftblacklist = ['nerdtree']

let iterm_profile = $ITERM_PROFILE
if iterm_profile == "Light"
    highlight illuminatedWord cterm=bold ctermbg=187
else
    highlight illuminatedWord cterm=bold ctermbg=236
endif
