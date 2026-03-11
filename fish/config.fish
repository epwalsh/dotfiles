# Add function subdirs to fish_function_path.
set fish_function_path (path resolve $__fish_config_dir/functions/*/) $fish_function_path

# Update path.
fish_add_path --path $HOME/bin
fish_add_path --path $HOME/.local/bin
fish_add_path --path $HOME/.cargo/bin
fish_add_path --path /usr/local/go/bin
fish_add_path --path $HOME/go/bin
fish_add_path --path /opt/homebrew/bin
fish_add_path --path /opt/homebrew/sbin

# Set default editor
set -gx EDITOR nvim

# Vi bindings
fish_vi_key_bindings

# Stop the fuckery of homebrew from fucking auto-updating every fucking time I want to install something.
# JFC if I wanted that behavior I would use Windows.
set -gx HOMEBREW_NO_AUTO_UPDATE 1

# Something to do with a markdown parser.
set -gx EXTENSION_WIKI_LINK 1

# Some useful navigation helpers. 
function ..    ; cd ..; and ls ; end
function ...   ; cd ../..; and ls ; end
function ....  ; cd ../../..; and ls ; end
function ..... ; cd ../../../..; and ls ; end

function root ; cd ./(git rev-parse --show-cdup) ; end

# Python virtual env setup
# set -gx PIPENV_IGNORE_VIRTUALENVS 1
# set -gx WORKON_HOME $HOME/.virtualenvs

# Google cloud.
if test -e ~/google-cloud-sdk/path.fish.inc
    source ~/google-cloud-sdk/path.fish.inc
end

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/petew/Downloads/google-cloud-sdk/path.fish.inc' ]; . '/Users/petew/Downloads/google-cloud-sdk/path.fish.inc'; end

# zoxide
if type -q zoxide
    zoxide init fish | source
end

# starship prompt.
starship init fish | source

# bat theme
set -gx BAT_THEME_LIGHT gruvbox-dark
set -gx BAT_THEME_DARK gruvbox-dark

# Git shortcuts
alias g git
alias gc 'git add -A; git commit -m'
alias gp 'git push'

# sccache for Rust.
if command -v sccache > /dev/null
    set -gx RUSTC_WRAPPER (which sccache)
end

# Aliases.
alias mux tmuxinator
alias s3-ls 'aws s3 ls --summarize --human-readable'

# Source local extras.
if test -e ~/.config/fish/extra.fish
    source ~/.config/fish/extra.fish
end
