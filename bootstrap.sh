#!/usr/bin/env bash

# Now run bootstrap_helper.py to move the important files to the right place.
read -p "This may overwrite existing files. Are you sure you want to continue? (y/n) " -n 1;
echo "";
if [[ $REPLY =~ ^[Yy]$ ]]; then
    python bootstrap_helper.py;
fi;

# Install homebrew if not yet installed.
if ! hash brew 2>/dev/null; then
    echo "Installing homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";
fi

# Run the brew script to install all the brewy stuff.
read -p "Preparing to update homebrew and run formuals. This may take a while. Are you sure you want to continue? (y/n) " -n 1;
echo "";
if [[ $REPLY =~ ^[Yy]$ ]]; then
    source brew.sh;
fi;
