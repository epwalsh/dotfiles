#!/bin/bash
# =============================================================================
# File Name:     setup2.sh
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 26-03-2016
# Last Modified: Sat Mar 26 14:52:34 2016
# =============================================================================

DIRS_HOME="bash
tmux
R
git"

for d in $DIRS_HOME
do
    FILES="$(ls -a $d)"
    for f in $FILES 
    do
        if [ "$f" != "./" ] && [ "$f" != "../" ]
        then
            if [ -e $HOME/$f ]
            then
                rm $HOME/$f
            fi
            ln -s $HOME/dotfiles/$d/$f $HOME/$f
        fi
    done
done

NVIM_FILES="$(ls .config/nvim)"
for f in $NVIM_FILES 
do
    if [ -e $HOME/.config/nvim/$f ]
    then
        rm -rf $HOME/.config/nvim/$f
    fi
    ln -s $HOME/dotfiles/.config/nvim/$f $HOME/.config/nvim/$f
done

a
