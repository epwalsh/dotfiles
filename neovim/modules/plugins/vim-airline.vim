" =============================================================================
" File Name:     vim-airline.vim
" Author:        Evan Pete Walsh
" Contact:       epwalsh10@gmail.com
" Creation Date: 21-03-2016
" Last Modified: 2017-04-13 16:45:14
" =============================================================================

set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 12
set laststatus=2
let g:Powerline_symbols = 'fancy'
let g:airline_powerline_fonts = 1
let g:airline_theme='solarized'

let iterm_profile = $ITERM_PROFILE
if iterm_profile == "Light"
    let g:airline_solarized_bg = 'light'
else
    let g:airline_solarized_bg = 'dark'
endif
" Good themes: papercolor, murmur, powerlineish, solarized, light, badwolf
