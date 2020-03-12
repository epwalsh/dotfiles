# Basics.
sudo apt-get update
sudo apt-get install -y \
    build-essential \
    curl \
    tmux \
    python-setuptools \
    fortune-mod \
    cowsay \
    tree \
    shellcheck \
    ripgrep \
    fish

# Python 3.6.
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt-get update
sudo apt-get install -y \
    python3.6 \
    python3-pip \
    python3-dev \
    python3.6-dev \
    python-virtualenv

# Fuzzy completion.
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
