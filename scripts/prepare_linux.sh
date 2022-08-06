#!/usr/bin/env bash

set -e

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
    fish \
    golang \
    fzf

# Python
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt-get update
sudo apt-get install -y \
    python3.9 \
    python3-pip \
    python3-dev \
    python3.9-dev \
    python-virtualenv
