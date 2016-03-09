# The bash_profile of Evan Pete Walsh >> epwalsh.com :: epwalsh10@gmail.com
# 
# Last Modified: Tue Mar  8 21:07:20 2016
# 
# This file is sourced on login in a linux environment. On Mac OS X, this file 
# sourced for both login and non-login scripts. We put exports and in this file,
# and aliases and other settings in .bashrc, which we source below. 

if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

# When tmux is started, it will source this file even if it has already been 
# sourced. 
if [ -n "$TMUX" ]; then
    kill -INT $$
fi
# Everything below here will not be sourced again when tmux is started.

cd ~/dotfiles/; git pull; cd -

# Exports ---------------------------------------------------------------- {{{
export EDITOR=vim
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/GitHub/Code/Python

case "${OSTYPE}" in 
    # Mac OS X ----------------------------------------------------- {{{
    darwin*)
    export PATH=$HOME/bin:$PATH
    export PATH="$PATH:/usr/local/Cellar/cmake/3.2.3/bin"
    export PATH="$PATH:/usr/local/texlive/2014/bin/x86_64-darwin"
    export PATH="$PATH:/Library/Frameworks/R.framework/Versions/3.1/Resources"
    export TERM="xterm-256color" 
    ;;
    # -------------------------------------------------------------- }}}
    # Linux -------------------------------------------------------- {{{
    linux*)
    export PATH=$HOME/.local/bin:$HOME/bin:$PATH
    ;;
    # -------------------------------------------------------------- }}}
esac
# ------------------------------------------------------------------------ }}}
