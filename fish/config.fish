if test -e ~/.config/fish/extra.fish
    source ~/.config/fish/extra.fish
end

# Add cargo bin to PATH
set -l cargo_bin_path $HOME/.cargo/bin
contains -- $cargo_bin_path $PATH
  or set -gx PATH $cargo_bin_path $PATH

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
function ..    ; cd .. && ls ; end
function ...   ; cd ../.. && ls ; end
function ....  ; cd ../../.. && ls ; end
function ..... ; cd ../../../.. && ls ; end

function root ; cd ./(git rev-parse --show-cdup) ; end

# Python virtual env setup
set -gx PIPENV_IGNORE_VIRTUALENVS 1
set -gx WORKON_HOME $HOME/.virtualenvs

# Google cloud.
if test -e ~/google-cloud-sdk/path.fish.inc
    source ~/google-cloud-sdk/path.fish.inc
end
