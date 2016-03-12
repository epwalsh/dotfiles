#!/bin/bash
# Careful! Running this script will overwrite all the files below in your
# home directory.

DOTFILES=".Rprofile
.bash_profile
.bashrc
.tmux-osx.conf
.tmux.conf
.vimrc"

for f in $DOTFILES
do
    if [ -e $HOME/$f ]
    then
        rm $HOME/$f
    fi
    ln -s $HOME/dotfiles/$f $HOME/$f
done
