eval (python -m virtualfish auto_activation global_requirements)

set -gx PIPENV_IGNORE_VIRTUALENVS 1

set -gx WORKON_HOME $HOME/.virtualenvs

# Default virtual env
if not set -q VIRTUAL_ENV
    vf activate py3.6
end

# Add cargo bin to PATH
set -gx PATH ~/.cargo/bin/ $PATH

# Set default editor
set -gx EDITOR nvim

# Vi bindings
fish_vi_key_bindings

# Linux brew.
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

# Some useful navigation helpers. 
function ..    ; cd .. ; end
function ...   ; cd ../.. ; end
function ....  ; cd ../../.. ; end
function ..... ; cd ../../../.. ; end

function root ; cd (git rev-parse --show-cdup) ; end
