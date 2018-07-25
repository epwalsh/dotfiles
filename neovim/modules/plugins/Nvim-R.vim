" NOTES:
" <localleader>kr to knit Rmd to HTML

let R_in_buffer = 1
" let R_tmux_split = 1
let R_applescript = 0
let R_openpdf = 1
let R_openhtml = 0
let r_indent_align_args = 0
let r_indent_ess_comments = 0
let r_indent_ess_compatible = 0
let R_assign = 0

vmap <buffer> <Space> <Plug>RDSendSelection
nmap <buffer> <Space> <Plug>RDSendLine

autocmd FileType r,rmd call SetROptions()
if !exists("*SetROptions")
    function SetROptions()
        " Use Ctrl+Space to do omnicompletion
        if has("gui_running")
            inoremap <C-Space> <C-x><C-o>
        else
            inoremap <Nul> <C-x><C-o>
        endif
        nmap <buffer> <LocalLeader>cc <Plug>RToggleComment
        vmap <buffer> <LocalLeader>cc <Plug>RToggleComment
        map <buffer> <LocalLeader>nr :call RAction("rownames")<CR>
        map <buffer> <LocalLeader>nc :call RAction("colnames")<CR>
        map <buffer> <LocalLeader>nn :call RAction("names")<CR>
        map <buffer> <LocalLeader>nD :call RAction("dimnames")<CR>
        map <buffer> <LocalLeader>nd :call RAction("dim")<CR>
        map <buffer> <LocalLeader>nh :call RAction("head")<CR>
        map <buffer> <LocalLeader>nt :call RAction("tail")<CR>
        map <buffer> <LocalLeader>nl :call RAction("length")<CR>
        map <buffer> <LocalLeader>ns :call RAction("str")<CR>
        map <buffer> <LocalLeader>nC :call RAction("class")<CR>
        map <buffer> <LocalLeader>na :call RAction("args")<CR>
        map <buffer> <LocalLeader>nw :call SendCmdToR("system('clear')")<CR>
        map <buffer> <LocalLeader>ne :call SendCmdToR("system('traceback()')")<CR>
        map <buffer> <LocalLeader>sb :call SendCmdToR("system.time({")<CR>
        map <buffer> <LocalLeader>se :call SendCmdToR("})")<CR>
        map <buffer> <LocalLeader>tt :call SendCmdToR("tt = ")<CR>
        map <buffer> <LocalLeader>rm :call SendCmdToR("rm(list=ls())")<CR>
        map <buffer> <LocalLeader>ls :call SendCmdToR("ls()")<CR>
        map <buffer> <LocalLeader>qy :call SendCmdToR("q(save = 'yes')")<CR>
        map <buffer> <LocalLeader>qn :call SendCmdToR("q(save = 'no')")<CR>
    endfunction
endif
