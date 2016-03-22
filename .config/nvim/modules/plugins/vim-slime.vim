" =============================================================================
" File Name:     vim-slime.vim
" Author:        Evan Pete Walsh
" Contact:       epwalsh10@gmail.com
" Creation Date: 21-03-2016
" Last Modified: Mon Mar 21 20:30:09 2016
" =============================================================================

let g:slime_target = "tmux"
" Create a tempory file to hold sent commands
let g:slime_paste_file = tempname()
let g:slime_default_config = {"socket_name": "default", "target_pane": "1"}
" Enable ipython's magic paste
let g:slime_python_ipython = 1

augroup slime_mappings
    autocmd!
    au FileType python vmap <buffer> <leader><Space> <Plug>SlimeRegionSend
    au FileType python nmap <buffer> <leader><Space> <Plug>SlimeLineSend
    au FileType python vmap <buffer> <Space> <Plug>SlimeRegionSend'>:set<Space>nois<cr>:set<Space>nohls<cr>/^[^#]+$<cr>:set<Space>is<cr>
    au FileType python nmap <buffer> <Space> <Plug>SlimeLineSend:set<Space>nois<cr>:set<Space>nohls<cr>/^[^#]+$<cr>:set<Space>is<cr>
augroup END
