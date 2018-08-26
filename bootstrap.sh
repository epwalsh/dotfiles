#!/usr/bin/env bash

OS=$(uname)

read -p "Ready to install dependencies. Are you sure you want to continue? [Y/n] " confirm
if [[ $confirm =~ ^[Yy]$ ]]; then
    if [[ $OS = 'Darwin' ]]; then
        source prepare_osx.sh
    else
        source prepare_linux.sh
    fi
    
    source prepare_all.sh
fi

read -p "Ready to install all configs and dotfiles. Are you sure you want to continue? (y/n) " confirm
if [[ $confirm =~ ^[Yy]$ ]]; then
    source install_configs.sh
fi

if [[ $OS = 'Darwin' ]]; then
    read -p "Preparing to set OS X defaults. Are you sure you want to continue? (y/n) " confirm
    if [[ $confirm =~ ^[Yy]$ ]]; then
        source defaults_osx.sh
    fi
fi

echo "Done. Note that some of these changes require a logout/restart to take effect."
