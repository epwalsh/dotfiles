#!/bin/bash
# =============================================================================
# File Name:     setup2.sh
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 26-03-2016
# Last Modified: Sun Mar 27 12:42:39 2016
# =============================================================================

# General setup ----------------------------------------------------------- {{{
DIRS_HOME="bash
tmux
R
git"

for d in $DIRS_HOME
do
    files="$(/bin/ls -a $d)"
    for f in $files 
    do
        if [ "$f" != "." ] && [ "$f" != ".." ]
        then
            if [ -e $HOME/$f ]
            then
                rm $HOME/$f
            fi
            ln -s $HOME/dotfiles/$d/$f $HOME/$f
        fi
    done
done
# ------------------------------------------------------------------------- }}}

# Neovim setup------------------------------------------------------------- {{{
DIRS_NVIM="headers
modules"

for d in $DIRS_NVIM
do
    if [ -e $HOME/.config/nvim/$d ]
    then
        rm $HOME/.config/nvim/$d
    fi
    ln -s $HOME/dotfiles/neovim/$d/ $HOME/.config/nvim/
done

if [ -e $HOME/.config/nvim/init.vim ]
then
    rm $HOME/.config/nvim/init.vim
fi
ln -s $HOME/dotfiles/neovim/init.vim $HOME/.config/nvim/
# ------------------------------------------------------------------------- }}}

# Vim setup --------------------------------------------------------------- {{{
if [ -e $HOME/.vimrc ]
then
    rm $HOME/.vimrc 
fi
ln -s $HOME/dotfiles/vim/.vimrc $HOME/

if [ -e $HOME/.vim/headers ]
then
    rm $HOME/.vim/headers
fi
ln -s $HOME/dotfiles/vim/headers/ $HOME/.vim/
# ------------------------------------------------------------------------- }}}

exit 0
