#!/usr/bin/env bash

# Base python dependencies.
# pip2 install --user --upgrade pip setuptools wheel
# pip3 install --user --upgrade pip setuptools wheel
# pip2 install --user -r requirements.txt
# pip3 install --user -r requirements.txt

# Powerline fonts.
# NOTE: We switched to Nerd Fonts, which can be installed via homebrew. See ./prepare_osx.sh
# cd ~/Downloads || exit
# git clone https://github.com/powerline/fonts.git
# cd fonts || exit
# ./install.sh
# cd .. || exit
# rm -rf fonts/
# cd ~/dotfiles || exit

# Install vcprompt.
# mkdir -p $HOME/bin
# curl -sL https://github.com/djl/vcprompt/raw/master/bin/vcprompt > $HOME/bin/vcprompt
# chmod 755 $HOME/bin/vcprompt

# Setup python virtualenv.
# export WORKON_HOME=$HOME/.virtualenvs
# export VIRTUALENVWRAPPER_PYTHON=$(which python3)
# source /usr/local/bin/virtualenvwrapper.sh
# mkvirtualenv py3 -p $(which python3)
# workon py3
# pip install -r requirements.txt

# Git configs.
git config --global user.name "epwalsh"
git config --global user.email "petew@allenai.org"
echo ".venv" >> ~/.gitignore
git config --global core.excludesFile "$HOME/.gitignore"

# Install Rust toolchain.
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# And Rust tools.
cargo install sccache \
    # alternative to cat
    bat \
    # alternative to grep
    ripgrep \
    # alternative to find
    fd-find \
    # alternative to sed
    sd \
    # alternative to du
    du-dust \
    # alternative to top, invoke as 'btm'
    bottom \
    # autojumper alternative to cd (requires fzf for fuzzy selection)
    zoxide \
    # very cool command line prompt
    starship \
    # alternative to ls and tree
    exa

# cargo install procs  # alternative to ps
# cargo install tokei  # displays statistics about your code
# cargo install hyperfine  # command line benchmarking tool
# cargo install tealdeer  # fast implementation of tldr: https://github.com/tldr-pages/tldr
# cargo install bandwhich  # CLI for diplaying network utilization
# cargo install grex  # CLI for generating regexs based on user-provided test cases
# cargo install hors  # How do I?

# Install Go

# And go tools.
go get github.com/google/go-jsonnet/cmd/jsonnetfmt
