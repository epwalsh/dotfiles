#!/usr/bin/env bash

# Python dependencies.
pip3 install -r requirements.txt

# Git configs.
git config --global user.name "epwalsh"
git config --global user.email "petew@allenai.org"
echo ".venv" >> ~/.gitignore
git config --global core.excludesFile "$HOME/.gitignore"

# Rust toolchain.
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
