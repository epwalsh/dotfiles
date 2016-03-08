" The VIMRC of Evan Pete Walsh >> epwalsh.com :: epwalsh10@gmail.com 
"
" 'I always thought air was free until I bought a bag of chips.'
" - Unknown
"
" Last Modified: Tue 08 Mar 2016 12:01:10 PM CST

" Vundle package manager -------------------------------------------------- {{{
set nocompatible             
filetype off                  

" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Plugins
Bundle 'gmarik/Vundle.vim'
Bundle 'vim-scripts/Vim-R-plugin'
Bundle 'altercation/vim-colors-solarized'
Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Bundle 'klen/python-mode'
Bundle 'davidhalter/jedi-vim'
Bundle 'jalvesaq/R-Vim-runtime'
Bundle 'scrooloose/nerdtree'
Bundle 'msanders/snipmate.vim'
Bundle 'ervandew/supertab'
Bundle 'vim-scripts/AutoComplPop'
Bundle 'mattn/emmet-vim'
"Bundle 'ivanov/vim-ipython'
Bundle 'jpalardy/vim-slime'
Bundle 'imouzon/iliketowatch'
Bundle 'scrooloose/nerdcommenter'

call vundle#end()
filetype plugin indent on
" ------------------------------------------------------------------------- }}}

" Basic settings ---------------------------------------------------------- {{{

" This will cause autocomplete tip window to close as soon as a selection is
" made. This is particular useful for pymode rope omnicompletion.
autocmd CompleteDone * pclose

" Leaders
let maplocalleader = ","
let mapleader = ","

" Make sure background works properly for tmux
set t_ut=

set mouse=a

" Make sure backspace works properly
set backspace=indent,eol,start

" Highlight during word search
set nohls

" Enable syntax highlighting
syntax enable

" Theme settings 
set background=dark
let g:solarized_termcolors = 256
colorscheme solarized

" Line numbers
set number 
set relativenumber

" Highlight text past 80 characters and add vertical bar
" Highlight Excess ctermbg=DarkGrey guibg=Black
" Match Excess /\%80v.*/
set colorcolumn=80

" Don't wrap lines by default
set nowrap 

" Toggle paste 
set pastetoggle=<F3>

" Popup menu behavior -------------------------------------------------- {{{
set completeopt=longest,menuone
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
" ---------------------------------------------------------------------- }}}

" Abbreviations
iabbrev @@ epwalsh10@gmail.com 
" ------------------------------------------------------------------------- }}}

" Mappings ---------------------------------------------------------------- {{{
nnoremap ; :
vnoremap ; :
"nmap : <nop>
"vmap : <nop>

" Always use very magic setting for regex searches
nmap / /\v
vmap / /\v

" Toggle relative line numbers 
nnoremap <F5> :setlocal relativenumber!<cr>
inoremap <F5> <esc>:setlocal relativenumber!<cr>li
vnoremap <F5> :<c-u>normal! `<mr`>mt<cr>:<c-u>setlocal relativenumber!
            \<cr>:<c-u>normal! `rv`t<cr>
nnoremap <leader><F5> :setlocal relativenumber!<cr>
vnoremap <leader><F5> :<c-u>normal! `<mr`>mt<cr>:<c-u>setlocal relativenumber!
            \<cr>:<c-u>normal! `rv`t<cr>

" Toggle line wrap 
nnoremap <F8> :setlocal wrap!<cr>
inoremap <F8> <esc>:setlocal wrap!<cr>li
vnoremap <F8> :<c-u>normal! `<mr`>mt<cr>:<c-u>setlocal wrap!
            \<cr>:<c-u>normal! `rv`t<cr>

" Jump to matching character (ex. matching brace or parenthesis)
nnoremap <leader>m %

" Execute :nohl with <F4>
nnoremap <F4> :set<Space>hls!<cr>
vnoremap <F4> :<c-u>normal! `<mr`>mt<cr>:<c-u>set<Space>hls!<cr>:<c-u>normal! `rv`t<cr>

" Movements between windows when not in tmux
nnoremap <c-j> <nop>
" map <c-j> <c-w>j
" map <c-k> <c-w>k
" map <c-l> <c-w>l
" map <c-h> <c-w>h

" Move lines up or down 
nnoremap ∆ :m .+1<CR>==
nnoremap ˚ :m .-2<CR>==
vnoremap ∆ :m '>+1<CR>gv=gv 
vnoremap ˚ :m '<-2<CR>gv=gv

" Change current word to uppercase 
inoremap <leader>u <esc>bveUea
nnoremap <leader>u bveUe 
" Change current word to lowercase
inoremap <leader>l <esc>bveuea
nnoremap <leader>l <esc>bveue

" Copy current line 
nnoremap <leader>yl 0v$y

" Global copying and pasting between files open in vim
vnoremap <F6> "+y
vnoremap <leader>cp "+y
nnoremap <F7> "+p
nnoremap <leader>cv "+p
inoremap <F7> <esc>"+pi
inoremap <leader>cv <esc>"+pi
nnoremap <leader><F7> "+p

" Open vimrc in a split
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
" Source vimrc 
nnoremap <leader>sv :source $MYVIMRC<cr> 

" Put quotes around a word
nnoremap <leader>" ea"<esc>hbi"<esc>lel
nnoremap <leader>' ea'<esc>hbi'<esc>lel 
vnoremap <leader>" <esc>`>a"<esc>`<i"<esc>`>ll
vnoremap <leader>' <esc>`>a'<esc>`<i'<esc>`>ll 

" Escape insert mode without having to press that stupid <esc> key
inoremap jk <esc>
vnoremap <leader>jk <esc>
" Map <esc> to no operation in insert mode
"inoremap <esc> <nop> 

" Quickly jump to beginning and end of lines
nnoremap H 0
nnoremap L $h
vnoremap H 0
vnoremap L $h

" Define some nifty operating-pending mappings
onoremap p i(
onoremap in( :<c-u>normal! f(vi(<cr>
onoremap il( :<c-u>normal! F)vi(<cr>

" Find trailing whitespace
nnoremap <leader>w mqgg/\v\s+$<cr>`q
" Remove trailing whitespace
nnoremap <leader>W mqgg:%s:\v\s+$:<cr>`q

" Insert line below and stay in normal mode
nnoremap <leader>o o<esc>
" Insert line above and stay in normal mode
nnoremap <leader>O O<esc>

" Git 
nnoremap <leader>gc :! git commit -a -m 'updates'<cr>
nnoremap <leader>gp :! git push<cr>
" ------------------------------------------------------------------------- }}}

" Powerline setup --------------------------------------------------------- {{{
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 11
set laststatus=2
let g:Powerline_symbols = 'fancy'
" ------------------------------------------------------------------------- }}}

" Nerdtree ---------------------------------------------------------------- {{{
" Activate nerdtree with F2
map <F2> :NERDTreeToggle<CR>
" ------------------------------------------------------------------------- }}}

" FileType-specific settings ---------------------------------------------- {{{

" Vimscript file settings ---------------------------------------------- {{{
augroup filetype_vim
    autocmd!
    au FileType vim setlocal shiftwidth=4 tabstop=4 expandtab
    " Allow code folding (type 'za' to fold or unfold)
    au FileType vim setlocal foldmethod=marker
    au Bufwritepre,filewritepre *.vimrc execute "normal ma"
    au Bufwritepre,filewritepre *.vimrc execute "1," . 10 . 
                \"g/Last Modified:.*/s/Last Modified:.*/Last Modified: " 
                \.strftime("%c")
    au bufwritepost,filewritepost *.vimrc execute "normal `a"
augroup END
" ---------------------------------------------------------------------- }}}

" R settings ----------------------------------------------------------- {{{
autocmd FileType r call SetROptions()
if !exists("*SetROptions")
    function SetROptions() 
        vmap <buffer> <Space> <Plug>RDSendSelection
        nmap <buffer> <Space> <Plug>RDSendLine
        " nnoremap <buffer> <Space> :call SendLineToR('down')<CR>
        "nmap <buffer> <LocalLeader>cc <Plug>RToggleComment
        "vmap <buffer> <LocalLeader>cc <Plug>RToggleComment
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
        setlocal shiftwidth=2 tabstop=2 expandtab
    endfunction
endif

" See VIM-R-Plugin manual for details on these
let vimrplugin_assign = 0
let vimrplugin_applescript=0
let vimrplugin_vsplit=1

" Custom header for R files 
augroup R_header 
    autocmd!
    au bufnewfile *.R 0r ~/.vim/headers/R_header.txt
    au bufnewfile *.R execute "1," . 10 . "g/File Name:.*/s//File Name:     " 
                \.expand("%:t")
    au bufnewfile *.R execute "1," . 10 . 
                \"g/Creation Date:.*/s//Creation Date: " 
                \.strftime("%d-%m-%Y")
    au bufwritepre,filewritepre *.R execute "normal ma"
    au bufwritepre,filewritepre *.R execute "1," . 10 . 
                \"g/Last Modified:.*/s/Last Modified:.*/Last Modified: " 
                \.strftime("%c")
    au bufwritepost,filewritepost *.R execute "normal `a"
augroup END
" ---------------------------------------------------------------------- }}}

" Latex settings ------------------------------------------------------- {{{
augroup tex_settings
    autocmd!
    au bufread *.tex set tw=150
    au FileType tex set tw=150
    au FileType tex setlocal colorcolumn=150
    au FileType tex setlocal shiftwidth=2 tabstop=2 expandtab 
    au FileType tex nnoremap <leader>kk :!open %:p:r.pdf -a /Applications/Skim.app/<cr>
    au FileType tex nnoremap <leader>lu :!lualatex %:p<cr>
    au bufnewfile *.tex 0r ~/.vim/headers/tex_header.txt
augroup END

set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'
" ---------------------------------------------------------------------- }}}

" C/Cpp settings --------------------------------------------------------- {{{
au FileType c    setlocal shiftwidth=4 tabstop=4 expandtab
au FileType cpp  setlocal shiftwidth=4 tabstop=4 expandtab
au bufread *.h   setlocal shiftwidth=4 tabstop=4 expandtab
au bufread *.hpp setlocal shiftwidth=4 tabstop=4 expandtab
au FileType make setlocal noexpandtab shiftwidth=8 softtabstop=0

" Custom header for c/cpp files 
augroup cpp_header
    autocmd!
    au bufnewfile *.c,*.cpp 0r ~/.vim/headers/cpp_header.txt
    au bufnewfile *.c,*.cpp exe "1," . 10 . "g/File Name:.*/s//File Name:     " 
                \.expand("%:t")
    au bufnewfile *.c,*.cpp exe "1," . 10 . 
                \"g/Creation Date:.*/s//Creation Date: " 
                \.strftime("%d-%m-%Y")
    au bufwritepre,filewritepre *.c,*.cpp execute "normal ma"
    au bufwritepre,filewritepre *.c,*.cpp execute "1," . 10 . 
                \"g/Last Modified:.*/s/Last Modified:.*/Last Modified: " 
                \.strftime("%c")
    au bufwritepost,filewritepost *.c,*.cpp execute "normal `a"
augroup END

" Custom header for cpp header files
augroup cpp_header_header
    autocmd!
    au bufnewfile *.h,*.hpp 0r ~/.vim/headers/cpp_header.txt
    au bufnewfile *.h,*.hpp exe "1," . 10 . "g/File Name:.*/s//File Name:     " 
                \.expand("%:t")
    au bufnewfile *.h,*.hpp exe "1," . 10 . 
                \"g/Creation Date:.*/s//Creation Date: " 
                \.strftime("%d-%m-%Y")
    au bufwritepre,filewritepre *.h,*.hpp execute "normal ma"
    au bufwritepre,filewritepre *.h,*.hpp execute "1," . 10 . 
                \"g/Last Modified:.*/s/Last Modified:.*/Last Modified: " 
                \.strftime("%c")
    au bufwritepost,filewritepost *.h,*.hpp execute "normal `a"
augroup END
" ---------------------------------------------------------------------- }}}

" Python settings ------------------------------------------------------ {{{
" Syntax highlighting
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all
let g:pymode_folding = 0 
let g:SuperTabDefaultCompletionType = "context"
let g:pymode_virtualenv = 1
let g:pymode_rope = 0
set completeopt=menuone,longest,preview
au FileType python setlocal shiftwidth=4 tabstop=4 expandtab
au FileType python setlocal omnifunc=pythoncomplete#Complete

" Custom header 
augroup python_header
    autocmd!
    au bufnewfile *.py 0r ~/.vim/headers/py_header.txt
    au bufnewfile *.py exe "1," . 10 . "g/File Name:.*/s//File Name:     " 
                \.expand("%:t")
    au bufnewfile *.py exe "1," . 10 . 
                \"g/Creation Date:.*/s//Creation Date: " 
                \.strftime("%d-%m-%Y")
    au bufwritepre,filewritepre *.py execute "normal ma"
    au bufwritepre,filewritepre *.py execute "1," . 10 . 
                \"g/Last Modified:.*/s/Last Modified:.*/Last Modified: " 
                \.strftime("%c")
    au bufwritepost,filewritepost *.py execute "normal `a"
augroup END

" Use slime to send python code to interpreter.
autocmd FileType python call SetPythonOptions()
if !exists("*SetPythonOptions")
    function SetPythonOptions()
        " Using ipython within tmux is the best way.
        let g:slime_target = "tmux"
        " Create a tempory file to hold sent commands 
        let g:slime_paste_file = tempname()
        let g:slime_default_config = {"socket_name": "default", "target_pane": "1"}
        " Enable ipython's magic paste
        let g:slime_python_ipython = 1
        vmap <buffer> <leader><Space> <Plug>SlimeRegionSend
        nmap <buffer> <leader><Space> <Plug>SlimeLineSend
        " After sending code to ipython, move to the next line with code, not
        " comments.
        vmap <buffer> <Space> <Plug>SlimeRegionSend'>:set<Space>nois<cr>:set<Space>nohls<cr>/^[^#]+$<cr>:set<Space>is<cr>
        nmap <buffer> <Space> <Plug>SlimeLineSend:set<Space>nois<cr>:set<Space>nohls<cr>/^[^#]+$<cr>:set<Space>is<cr>
    endfunction
endif
" ---------------------------------------------------------------------- }}}

" HTML/CSS settings ---------------------------------------------------- {{{
let g:user_emmet_leader_key='<C-Z>'
au FileType html setlocal shiftwidth=2 tabstop=2 expandtab
au FileType html setlocal nowrap
au FileType css  setlocal shiftwidth=4 tabstop=4 expandtab 
au FileType css  setlocal nowrap 
" ---------------------------------------------------------------------- }}}

" Bash settings -------------------------------------------------------- {{{
augroup bash_settings
    autocmd!
    au FileType sh setlocal shiftwidth=4 tabstop=4 expandtab
    au FileType sh setlocal foldmethod=marker
    au bufnewfile *.sh 0r ~/.vim/headers/sh_header.txt 
augroup END
" ---------------------------------------------------------------------- }}}

" .tmux.conf file settings -------------------------------------------- {{{
augroup tmux_conf
    autocmd!
    au bufread *.tmux.conf setlocal foldmethod=marker
    au Bufwritepre,filewritepre *.tmux.conf execute "normal ma"
    au Bufwritepre,filewritepre *.tmux.conf execute "1," . 10 . 
                \"g/Last Modified:.*/s/Last Modified:.*/Last Modified: " 
                \.strftime("%c")
    au bufwritepost,filewritepost *.tmux.conf execute "normal `a"
augroup END
" ---------------------------------------------------------------------- }}}

" .bash_profile/.bashrc file settings ---------------------------------- {{{
augroup bash_dotfiles
    autocmd!
     au Bufwritepre,filewritepre *.bash_profile execute "normal ma"
     au Bufwritepre,filewritepre *.bash_profile execute "1," . 10 . 
                \"g/Last Modified:.*/s/Last Modified:.*/Last Modified: " 
                \.strftime("%c")
    au bufwritepost,filewritepost *.bash_profile execute "normal `a"
    au Bufwritepre,filewritepre *.bashrc execute "normal ma"
    au Bufwritepre,filewritepre *.bashrc execute "1," . 10 . 
                \"g/Last Modified:.*/s/Last Modified:.*/Last Modified: " 
                \.strftime("%c")
    au bufwritepost,filewritepost *.bashrc execute "normal `a"
augroup END
" ---------------------------------------------------------------------- }}}
" ------------------------------------------------------------------------- }}}

" Comments ---------------------------------------------------------------- {{{
let NERDSpaceDelims = 1
"function! CppCommentBlock(comment)
"    let start = '/*'
"    let finish = '*/'
"    " Build the comment box and put the comment inside it...
"    return start . "\<CR>"
"    \    . a:comment . "\<CR>"
"    \    . "\<BS>\<BS>" . finish . "\<CR>"
"endfunction
"
"nnoremap cc <nop>
"vnoremap cc <nop>
"augroup comments
"    autocmd!
"    au FileType python nnoremap <buffer> <localleader>cc 
"                \mqI# <esc>`qll
"    au FileType python vnoremap <buffer> <localleader>cc 
"                \<esc>mq:'<,'>s:^:# :<cr>:nohlsearch<cr>`qll
"    au FileType python nnoremap <buffer> <localleader>cu 
"                \mq:s:#\s\\|#<cr>:nohlsearch<cr>`qhh
"    au FileType python vnoremap <buffer> <localleader>cu 
"                \<esc>mq:'<,'>s:#\s\\|#::<cr>:nohlsearch<cr>`qhh
"    au FileType cpp nnoremap <buffer> <localleader>cc 
"                \mqI// <esc>`qlll
"    au FileType cpp vnoremap <buffer> <localleader>cc 
"                \<esc>mq`>A */<esc>`<I/* <esc>`q
"    au FileType cpp inoremap <buffer> <localleader>// 
"                \<c-r>=CppCommentBlock(input("Enter comment: "))<cr>
"    au FileType html nnoremap <buffer> <localleader>cc 
"                \mqI<!-- <esc>A--><esc>`q5l
"    au FileType html vnoremap <buffer> <localleader>cc 
"                \<esc>mq`>A --><esc>`<I<!-- <esc>`q
"augroup END
" ------------------------------------------------------------------------- }}}
