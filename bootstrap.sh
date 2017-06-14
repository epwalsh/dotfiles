#!/usr/bin/env bash

# Install homebrew if not yet installed.
if ! hash brew 2>/dev/null; then
    echo "Installing homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";
fi

# Run the brew script to brew-install all the brewy stuff.
read -p "Preparing to update homebrew and run formulas. This may take a while. Are you sure you want to continue? (y/n) " -n 1;
echo "";
if [[ $REPLY =~ ^[Yy]$ ]]; then
    source brew.sh;
fi;

# Run the pip script to pip-install all the pipy stuff.
read -p "Preparing to install Python dependencies. This may take a while. Are you sure you want to continue? (y/n) " -n 1;
echo "";
if [[ $REPLY =~ ^[Yy]$ ]]; then
    source pip.sh;
fi;

# Now run bootstrap_helper.py to move the important files to the right place.
read -p "Ready to bootstrap config files. This may overwrite existing files. Are you sure you want to continue? (y/n) " -n 1;
echo "";
if [[ $REPLY =~ ^[Yy]$ ]]; then
    python bootstrap_helper.py;
    source ~/.bash_profile
fi;
