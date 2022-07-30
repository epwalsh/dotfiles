# Modified from https://github.com/mathiasbynens/dotfiles/blob/master/brew.sh

# Install homebrew if not yet installed.
if ! hash brew 2>/dev/null; then
    echo "Installing homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils

# brew install clang-format

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed

# Install Bash 4.
# Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before
# running `chsh`. To do so, run `sudo chsh -s /usr/local/bin/bash`.
# brew install bash
# brew tap homebrew/versions
# brew install bash-completion2

# Fish
brew install fish

# Switch to using brew-installed bash as default shell
# if ! fgrep -q '/usr/local/bin/bash' /etc/shells; then
#   echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
#   chsh -s /usr/local/bin/bash;
# fi;

# Fish italics.
tic -x xterm-256color.terminfo.txt
tic -x tmux/tmux-256color.terminfo.txt

# Install `wget` with IRI support.
brew install wget

# Install newer version of Python
brew install python
brew install python3
# Set the homebrew Python and the default
brew link python

# Install Tmux
brew install tmux
brew install reattach-to-user-namespace

# Install more recent versions of some macOS tools.
brew tap neovim/neovim
brew install neovim
brew install vim --with-override-system-vi
# brew install homebrew/dupes/grep
# brew install homebrew/dupes/openssh
# brew install homebrew/dupes/screen
# brew install homebrew/php/php56 --with-gmp

# Install Java
# brew cask install java

# Install font tools.
brew tap bramstein/webfonttools
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2

# Linting bash files.
# brew install shellcheck

# Install other useful binaries.
brew install vcprompt
brew install ripgrep  # improved grep written in rust.
# brew install fortune
# brew install cowsay
# brew install mcrypt
# brew install ack
# brew install dark-mode
#brew install exiv2
# brew install git
# brew install git-lfs
# brew install imagemagick --with-webp
# brew install lua
# brew install lynx
# brew install p7zip
# brew install pigz
# brew install pv
brew install rename
# brew install rhino
# brew install speedtest_cli
# brew install ssh-copy-id
# brew install testssl
brew install tree
# brew install vbindiff
# brew install webkit2png
# brew install zopfli
brew install fzf
brew install go

# Remove outdated versions from the cellar.
brew cleanup

# Install NERDFont
brew tap homebrew/cask-fonts
brew install --cask font-dejavu-sans-mono-nerd-font

brew install rust-analyzer
