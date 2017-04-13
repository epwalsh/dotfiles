# The bash_profile of Evan Pete Walsh >> epwalsh.com :: epwalsh10@gmail.com
#
# Last Modified: 2017-04-13 14:45:05
#
# This file is sourced on login in a linux environment. On Mac OS X, this file
# sourced for both login and non-login scripts. We put exports in this file
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
# ---------------------------------------------------------------------

# Automatically check for updates to dotfiles on login
# cd ~/dotfiles/; git pull; cd -

# Exports ---------------------------------------------------------------- {{{

case "${OSTYPE}" in
    # Mac OS X ----------------------------------------------------- {{{
    darwin*)
    export WORKON_HOME=$HOME/.virtualenvs
    # export PROJECT_HOME=$HOME/GitHub/Code/Python

    export PATH=$HOME/bin:$PATH
    # export PATH="$PATH:/usr/local/texlive/2014/bin/x86_64-darwin"
    # export PATH="$PATH:/Library/Frameworks/R.framework/Versions/3.1/Resources"
    # export PATH="$PATH:/Applications/Julia-0.4.3.app/Contents/Resources/julia/bin/"
    export TERM="xterm-256color"
    export LANG='en_US.UTF-8'
    export EDITOR=nvim
    ;;
    # -------------------------------------------------------------- }}}
    # Linux -------------------------------------------------------- {{{
    linux*)
    export PATH=$HOME/.local/bin:$HOME/bin:$PATH
    export EDITOR=nvim
    export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
    [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
    ;;
    # -------------------------------------------------------------- }}}
esac
# ------------------------------------------------------------------------ }}}

# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
