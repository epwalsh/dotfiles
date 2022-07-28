" set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 12
set laststatus=2
let g:Powerline_symbols = 'fancy'
let g:airline_powerline_fonts = 1
let g:airline_theme = 'solarized'

let iterm_profile = $ITERM_PROFILE
if iterm_profile == "Light"
    let g:airline_solarized_bg = 'light'
else
    let g:airline_solarized_bg = 'dark'
endif

" Disable airline from changing tmux theme.
let g:airline#extensions#tmuxline#enabled = 0
