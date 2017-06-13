# The bash_profile of Evan Pete Walsh >> epwalsh.com :: epwalsh10@gmail.com
#
# Last Modified: 2017-06-13 16:25:32
#
# This file is sourced on login in a linux environment. On Mac OS X, this file
# sourced for both login and non-login scripts. We put exports in this file
# and aliases and other settings in .bashrc, which we source below.

# Source bashrc
if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

# Source local exports
if [ -f ~/.local_exports ]; then
    source ~/.local_exports
fi

# When tmux is started, it will source this file even if it has already been
# sourced. So everything below here will not be sourced again when tmux starts.
if [ -n "$TMUX" ]; then
    kill -INT $$
fi

# Exports
export WORKON_HOME=$HOME/.virtualenvs
export PATH=$HOME/bin:$PATH
export TERM="xterm-256color"
export LANG='en_US.UTF-8'
export EDITOR=nvim
