# Add ~/bin to PATH
set -l bin_path $HOME/bin
if test -d $bin_path
    contains -- $bin_path $PATH
    or set -gx PATH $bin_path $PATH
end

# Add cargo bin to PATH
set -l cargo_bin_path $HOME/.cargo/bin
contains -- $cargo_bin_path $PATH
  or set -gx PATH $cargo_bin_path $PATH

# go bin to PATH
set -l go_bin_path /usr/local/go/bin
if test -d $go_bin_path
    contains -- $go_bin_path $PATH
    or set -gx PATH $go_bin_path $PATH
    set -l go_user_bin_path $HOME/go/bin
    contains -- $go_user_bin_path $PATH
    or set -gx PATH $go_user_bin_path $PATH
end

# Set default editor
set -gx EDITOR nvim

# Vi bindings
fish_vi_key_bindings

# Homebrew.
if test -d "/opt/homebrew"
    set -l homebrew_bin_path "/opt/homebrew/bin"
    set -l homebrew_sbin_path "/opt/homebrew/sbin"

    contains -- $homebrew_bin_path $PATH
      or set -gx PATH $homebrew_bin_path $PATH
    contains -- $homebrew_sbin_path $PATH
      or set -gx PATH $homebrew_sbin_path $PATH
end

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
function ..    ; cd ..; and ls ; end
function ...   ; cd ../..; and ls ; end
function ....  ; cd ../../..; and ls ; end
function ..... ; cd ../../../..; and ls ; end

function root ; cd ./(git rev-parse --show-cdup) ; end

# Python virtual env setup
set -gx PIPENV_IGNORE_VIRTUALENVS 1
set -gx WORKON_HOME $HOME/.virtualenvs

# Google cloud.
if test -e ~/google-cloud-sdk/path.fish.inc
    source ~/google-cloud-sdk/path.fish.inc
end

# zoxide
if type -q zoxide
    zoxide init fish | source
end

# starship prompt.
starship init fish | source

# Git shortcuts
alias g git
alias gc 'git add -A; git commit -m'
alias gp 'git push'

# sccache for Rust.
if command -v sccache > /dev/null
    set -gx RUSTC_WRAPPER (which sccache)
end

# Source local extras.
if test -e ~/.config/fish/extra.fish
    source ~/.config/fish/extra.fish
end

alias mux tmuxinator

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/petew/Downloads/google-cloud-sdk/path.fish.inc' ]; . '/Users/petew/Downloads/google-cloud-sdk/path.fish.inc'; end

set -gx EXTENSION_WIKI_LINK 1

alias nav 'nvim notes/nav.md'
