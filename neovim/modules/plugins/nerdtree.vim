" Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

map <F2> :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.pyc$', '\.o$', '\.gch$', '__pycache__']
let NERDTreeShowLineNumbers = 1 
