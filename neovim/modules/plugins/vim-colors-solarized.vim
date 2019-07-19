let g:solarized_termcolors = 256
colorscheme solarized

" Highlight current line under cursor.
set cursorline

let iterm_profile = $ITERM_PROFILE
if iterm_profile == "Light"
    set background=light
else
    highlight CursorLine ctermbg=236
    highlight ColorColumn ctermbg=236 guibg=grey
    highlight Comment cterm=italic ctermfg=96 ctermbg=236
    highlight Number ctermfg=198
endif

" This ensures that vim will inheret transparency from the terminal.
hi Normal guibg=NONE ctermbg=NONE
