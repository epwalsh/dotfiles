# Basics.
apt-get update
apt-get install -y \
    build-essential \
    curl \
    git \
    tmux \
    python-setuptools

# Python 3.6.
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt-get update
sudo apt-get install python3.6
