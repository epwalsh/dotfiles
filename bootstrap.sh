#!/usr/bin/env bash
#
# I use the script as a reference for bootstrapping my development environment
# on new (Mac) computers. I generally don't run it directly since it gets outdated quickly
# and there's always commands that will fail and need to be updated.

# Exit if anything fails.
set -e
# Match hidden files with "*"
shopt -s dotglob

#A##########
# Homebrew #
############

# Install Homebrew if not yet installed.
if ! hash brew 2>/dev/null; then
    echo "Installing homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formula.
brew upgrade

# Install dependencies.
brew install \
    coreutils \
    moreutils \
    findutils \
    gnu-sed \
    fish \
    wget \
    python3 \
    tmux \
    reattach-to-user-namespace \
    fzf \
    go \
    git-crypt \
    mosh \
    gnupg

# Install nightly neovim.
brew install --HEAD neovim

# Install NERDFont
brew tap homebrew/cask-fonts
brew install --cask font-dejavu-sans-mono-nerd-font

# Use homebrew-installed Python by default.
brew link python

##################
# Rust toolchain #
##################

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Rust tools.
cargo install sccache \
    bat \
    ripgrep \
    fd-find \
    sd \
    du-dust \
    bottom \
    zoxide \
    starship \
    exa

##############################################
# Install configuration files (as symlinks). #
##############################################

mkdir -p ~/.config
mkdir -p ~/.virtualenvs

# tmux.
for filename in ~/dotfiles/tmux/.tmux*; do
    ln -sf $filename ~/
done

# Neovim.
mkdir -p ~/.config/nvim
for filename in ~/dotfiles/neovim/*; do
    ln -sf $filename ~/.config/nvim/$(basename $filename)
done

# Fish.
mkdir -p ~/.config/fish
for filename in ~/dotfiles/fish/*; do
    ln -sf $filename ~/.config/fish/$(basename $filename)
done

# Go.
for filename in ~/dotfiles/go/.*; do
    ln -sf $filename ~/
done

# Alacritty.
mkdir -p ~/.config/alacritty
ln -sf ~/dotfiles/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml

# Starship.
ln -sf ~/dotfiles/starship/starship.toml ~/.config/starship.toml

# Global Python requirements.
ln -sf ~/dotfiles/requirements.txt ~/.virtualenvs/global_requirements.txt

# Git.
git config --global user.name "epwalsh"
git config --global user.email "petew@allenai.org"
echo ".venv" >> ~/.gitignore
git config --global core.excludesFile "$HOME/.gitignore"

########################
# Change shell to Fish #
########################

echo $(which fish) | sudo tee -a /etc/shells
chsh -s $(which fish)

# Fish italics (might not need this anymore).
# tic -x xterm-256color.terminfo.txt
# tic -x tmux/tmux-256color.terminfo.txt

#######################
# Python environments #
#######################

# Set up virtualfish.
pip3 install virtualfish
vf install global_requirements auto_activation
ln -sf ~/dotfiles/requirements.txt ~/.virtualenvs/global_requirements.txt
vf new base
