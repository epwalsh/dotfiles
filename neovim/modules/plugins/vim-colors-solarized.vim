" =============================================================================
" File Name:     vim-colors-solarized.vim
" Creation Date: 21-03-2016
" Last Modified: 2017-06-15 12:19:23
" =============================================================================

let g:solarized_termcolors = 256
colorscheme solarized

let iterm_profile = $ITERM_PROFILE
if iterm_profile == "Light"
    set background=light
endif

" This ensures that vim will inheret transparency from the terminal.
hi Normal guibg=NONE ctermbg=NONE

" Set ColorColumn color.
hi ColorColumn ctermbg=236 guibg=grey
