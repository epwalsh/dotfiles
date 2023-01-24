#!/usr/bin/env bash

set -e

# Install homebrew if not yet installed.
if ! hash brew 2>/dev/null; then
    echo "Installing homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formula.
brew upgrade

brew install \
    coreutils \
    moreutils \
    findutils \
    gnu-sed \
    fish \
    wget \
    python \
    python3 \
    tmux \
    reattach-to-user-namespace \
    fzf \
    go \
    git-crypt \
    gnupg

# Install nightly neovim.
brew install --HEAD neovim

# Install NERDFont
brew tap homebrew/cask-fonts
brew install --cask font-dejavu-sans-mono-nerd-font

# Use homebrew-installed Python by default.
brew link python

# Fish italics.
tic -x xterm-256color.terminfo.txt
tic -x tmux/tmux-256color.terminfo.txt

# Remove outdated versions from the cellar.
brew cleanup
