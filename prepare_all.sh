# Base python dependencies.
# pip2 install --user --upgrade pip setuptools wheel
# pip3 install --user --upgrade pip setuptools wheel
# pip2 install --user -r requirements.txt
# pip3 install --user -r requirements.txt

# Powerline fonts.
cd ~/Downloads
git clone https://github.com/powerline/fonts.git
cd fonts
./install.sh
cd ..
rm -rf fonts/
cd ~/dotfiles

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
git config --global core.excludesFile '~/.gitignore'

# Install Rust toolchain.
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# And Rust tools.
cargo install sccache
cargo install bat  # alternative to cat
# cargo install exa  # alternative to ls and tree
cargo install ripgrep  # alternative to grep
cargo install fd-find  # alternative to find
# cargo install procs  # alternative to ps
cargo install sd  # alternative to sed
cargo install du-dust  # alternative to du
# cargo install tokei  # displays statistics about your code
# cargo install hyperfine  # command line benchmarking tool
cargo install bottom  # alternative to top, invoke as 'btm'
# cargo install tealdeer  # fast implementation of tldr: https://github.com/tldr-pages/tldr
# cargo install bandwhich  # CLI for diplaying network utilization
# cargo install grex  # CLI for generating regexs based on user-provided test cases
cargo install zoxide  # autojumper alternative to cd (requires fzf for fuzzy selection)
cargo install starship  # very cool command line prompt
# cargo install hors  # How do I?
