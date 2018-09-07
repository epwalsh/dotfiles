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
    shellcheck

# Python 3.6.
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt-get update
sudo apt-get install python3.6
