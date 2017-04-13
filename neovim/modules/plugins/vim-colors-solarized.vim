" =============================================================================
" File Name:     vim-colors-solarized.vim
" Author:        Evan Pete Walsh
" Contact:       epwalsh10@gmail.com
" Creation Date: 21-03-2016
" Last Modified: 2017-04-13 16:44:34
" =============================================================================

let g:solarized_termcolors = 256
colorscheme solarized

let iterm_profile = $ITERM_PROFILE
if iterm_profile == "Light"
    set background=light
endif
