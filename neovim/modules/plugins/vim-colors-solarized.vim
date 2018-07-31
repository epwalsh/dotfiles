let g:solarized_termcolors = 256
colorscheme solarized

" Highlight current line under cursor.
set cursorline

let iterm_profile = $ITERM_PROFILE
if iterm_profile == "Light"
    set background=light
else
    " Set cursorline color.
    highlight CursorLine ctermbg=236

    " Set ColorColumn color.
    highlight ColorColumn ctermbg=236 guibg=grey
endif

" This ensures that vim will inheret transparency from the terminal.
hi Normal guibg=NONE ctermbg=NONE
