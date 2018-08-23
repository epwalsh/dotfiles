# Basics.
apt-get update
apt-get install -y \
    build-essential \
    curl \
    tmux \
    python-setuptools

# Python 3.6.
add-apt-repository ppa:deadsnakes/ppa
apt-get update
apt-get install python3.6
