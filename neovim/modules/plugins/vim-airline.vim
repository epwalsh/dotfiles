" =============================================================================
" File Name:     vim-airline.vim
" Creation Date: 21-03-2016
" Last Modified: 2017-06-15 12:19:16
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

" Disable airline from changing tmux theme.
let g:airline#extensions#tmuxline#enabled = 0
