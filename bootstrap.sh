#!/usr/bin/env bash

# Install homebrew if not yet installed.
if ! hash brew 2>/dev/null; then
    echo "Installing homebrew";
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
    source ~/.bash_profile;
fi;


# Install fonts for powerline.
read -p "Ready to install powerline fonts. Are you sure you want to continue? (y/n) " -n 1;
echo "";
if [[ $REPLY =~ ^[Yy]$ ]]; then
    cd ..;
    git clone https://github.com/powerline/fonts.git;
    cd fonts;
    ./install.sh;
    cd ..;
    rm -rf fonts;
    cd dotfiles;
fi;


# Now install neovim plugins.
read -p "Ready to install neovim plugins. Are you sure you want to continue? (y/n) " -n 1;
echo "";
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.config/nvim/bundle/Vundle.vim;
    nvim +PluginInstall +qall;
    nvim +UpdateRemotePlugins +qall;
fi;


# Set some sane Apple defaults.

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Show the ~/Library folder
chflags nohidden ~/Library

# Show the /Volumes folder
sudo chflags nohidden /Volumes

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Disable smart quotes in messages as it’s annoying for messages that contain code
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

# Disable continuous spell checking in messages
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false

# Enable 3-finger drag. (Moving with 3 fingers in any window "chrome" moves the window.)
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Change menu bar to dark mode
osascript <<EOF
tell application "System Events"
    tell appearance preferences
        set dark mode to true
    end tell
end tell
EOF

# Kill affected applications                                                  
for app in "Activity Monitor" \
	"Address Book" \
	"Calendar" \
	"cfprefsd" \
	"Contacts" \
	"Dock" \
	"Finder" \
	"Google Chrome Canary" \
	"Google Chrome" \
	"Mail" \
	"Messages" \
	"Opera" \
	"Photos" \
	"Safari" \
	"SizeUp" \
	"Spectacle" \
	"SystemUIServer" \
	"Terminal" \
	"Transmission" \
	"Tweetbot" \
	"Twitter" \
	"iCal"; do
	killall "${app}" &> /dev/null
done
echo "Done. Note that some of these changes require a logout/restart to take effect."
