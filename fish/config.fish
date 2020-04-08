if test -e ~/.config/fish/extra.fish
    source ~/.config/fish/extra.fish
end

# eval (python3 -m virtualfish auto_activation global_requirements)

set -gx PIPENV_IGNORE_VIRTUALENVS 1

set -gx WORKON_HOME $HOME/.virtualenvs

# Default virtual env
if not set -q VIRTUAL_ENV
    set -gx VIRTUAL_ENV ~/.virtualenvs/py3
end
vf activate (basename $VIRTUAL_ENV)

# Add cargo bin to PATH
set -gx PATH ~/.cargo/bin/ $PATH

# Set default editor
set -gx EDITOR nvim

# Vi bindings
fish_vi_key_bindings

# Linux brew.
if test -d "/home/linuxbrew"
    set -l linuxbrew_bin_path "/home/linuxbrew/.linuxbrew/bin"
    set -l linuxbrew_sbin_path "/home/linuxbrew/.linuxbrew/sbin"
    set -l linuxbrew_manpath "/home/linuxbrew/.linuxbrew/share/man"
    set -l linuxbrew_infopath "/home/linuxbrew/.linuxbrew/share/info"
    
    contains -- $linuxbrew_bin_path $PATH
      or set -gx PATH $linuxbrew_bin_path $PATH
    
    contains -- $linuxbrew_sbin_path $PATH
      or set -gx PATH $linuxbrew_sbin_path $PATH
    
    contains -- $linuxbrew_manpath $MANPATH
      or set -gx MANPATH $linuxbrew_manpath $MANPATH
    
    contains -- $linuxbrew_infopath $INFOPATH
      or set -gx INFOPATH $linuxbrew_infopath $INFOPATH
end

# Some useful navigation helpers. 
function ..    ; cd .. ; end
function ...   ; cd ../.. ; end
function ....  ; cd ../../.. ; end
function ..... ; cd ../../../.. ; end

function root ; cd (git rev-parse --show-cdup) ; end
