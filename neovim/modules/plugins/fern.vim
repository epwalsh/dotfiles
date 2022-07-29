function ShiftFocusThenExecute(command)
    " Shift focus to the right/main window,
    " especially when focus is in sidebar.
    :wincmd l

    " Run commands like `:Files`.
    execute a:command
endfunction

function! s:init_fern() abort
  " Define NERDTree like mappings
  nmap <buffer> o <Plug>(fern-action-open:edit)
  nmap <buffer> go <Plug>(fern-action-open:edit)<C-w>p
  nmap <buffer> t <Plug>(fern-action-open:tabedit)
  nmap <buffer> T <Plug>(fern-action-open:tabedit)gT
  nmap <buffer> i <Plug>(fern-action-open:split)
  nmap <buffer> gi <Plug>(fern-action-open:split)<C-w>p
  nmap <buffer> s <Plug>(fern-action-open:vsplit)
  nmap <buffer> gs <Plug>(fern-action-open:vsplit)<C-w>p
  nmap <buffer> ma <Plug>(fern-action-new-path)
  nmap <buffer> P gg

  nmap <buffer> C <Plug>(fern-action-enter)
  nmap <buffer> u <Plug>(fern-action-leave)
  nmap <buffer> r <Plug>(fern-action-reload)
  nmap <buffer> R gg<Plug>(fern-action-reload)<C-o>
  nmap <buffer> cd <Plug>(fern-action-cd)
  nmap <buffer> CD gg<Plug>(fern-action-cd)<C-o>

  nmap <buffer> I <Plug>(fern-action-hidden-toggle)

  nmap <buffer> q :<C-u>quit<CR>

  " Expand or collapse by typing 'l'
  nmap <buffer><expr>
      \ <Plug>(fern-my-expand-or-collapse)
      \ fern#smart#leaf(
      \   "\<Plug>(fern-action-collapse)",
      \   "\<Plug>(fern-action-expand)",
      \   "\<Plug>(fern-action-collapse)",
      \ )

  nmap <buffer><nowait> l <Plug>(fern-my-expand-or-collapse)

  " Preview.
  nmap <silent> <buffer> p     <Plug>(fern-action-preview:toggle)
  nmap <silent> <buffer> <C-p> <Plug>(fern-action-preview:auto:toggle)
  nmap <silent> <buffer> <C-d> <Plug>(fern-action-preview:scroll:down:half)
  nmap <silent> <buffer> <C-u> <Plug>(fern-action-preview:scroll:up:half)

  " Smart preview.
  nmap <silent> <buffer> <expr> <Plug>(fern-quit-or-close-preview) fern_preview#smart_preview("\<Plug>(fern-action-preview:close)", ":q\<CR>")
  nmap <silent> <buffer> q <Plug>(fern-quit-or-close-preview)

  nnoremap ff :call ShiftFocusThenExecute('Files')<CR>
  " nnoremap <Leader>rg :call ShiftFocusThenExecute('Rg')<CR>
  " nnoremap <Leader>b :call ShiftFocusThenExecute('Buffers')<CR>
  " nnoremap <Leader>m :call ShiftFocusThenExecute('Maps')<CR>
endfunction

" Use NERD Font icons.
let g:fern#renderer = "nerdfont"
" Show hidden files by default.
let g:fern#default_hidden = 1
" Exlude these files/dirs by default.
let g:fern#default_exclude = '^\%(\.mypy_cache\|__pycache__\|\.git\|\.pytest_cache\|\.ipynb_checkpoints\|.*\.egg-info\)$'

augroup fern-custom
  autocmd! *
  autocmd! FileType fern call s:init_fern()
  autocmd FileType fern call glyph_palette#apply()
augroup END

" Start Fern when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * ++nested if argc() == 0 && !exists('s:std_in') | Fern . -drawer | endif

map <F2> :Fern . -drawer<CR>
" use this one instead if you F2 to close Fern drawer instead of refocus
" map <F2> :Fern . -drawer -toggle<CR>

let g:fern#mapping#fzf#disable_default_mappings = 1

" Fuzzy find with preview.
function! s:Fern_mapping_fzf_customize_option(spec)
    let a:spec.options .= ' --multi'
    return fzf#vim#with_preview(a:spec)
endfunction

let g:Fern_mapping_fzf_customize_option = function('s:Fern_mapping_fzf_customize_option')
