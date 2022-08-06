#!/usr/bin/env bash

set -e

OS=$(uname)

read -p "Ready to install dependencies. Are you sure you want to continue? [Y/n] " confirm
if [[ $confirm =~ ^[Yy]$ ]]; then
    if [[ $OS = 'Darwin' ]]; then
        source scripts/prepare_osx.sh
    else
        source scripts/prepare_linux.sh
    fi
    
    source scripts/prepare_all.sh
fi

read -p "Ready to install all configs and dotfiles. Are you sure you want to continue? (y/n) " confirm
if [[ $confirm =~ ^[Yy]$ ]]; then
    source scripts/install_configs.sh
fi

if [[ $OS = 'Darwin' ]]; then
    read -p "Preparing to set OS X defaults. Are you sure you want to continue? (y/n) " confirm
    if [[ $confirm =~ ^[Yy]$ ]]; then
        source scripts/defaults_osx.sh
    fi
fi

# Set default shell to Fish.
echo $(which fish) | sudo tee -a /etc/shells
chsh -s $(which fish)

# Set up virtualfish.
vf install global_requirements auto_activation
ln -sf ~/dotfiles/requirements.txt ~/.virtualenvs/global_requirements.txt

echo "Done. Note that some of these changes require a logout/restart to take effect."
