# The bashrc of Evan Pete Walsh >> epwalsh.com :: epwalsh10@gmail.com
#
# Last Modified: 2017-04-13 14:41:40
#
# This file is supposed to be sourced for interactive non-login shells in a 
# linux environment.
# If not running interactively, don't do anything:
case $- in
    *i*) ;;
    *) return;;
esac

# Welcome message
# figlet Hello, World!
fortune | cowsay

# Vim-like keybindings
set -o vi

# Improve tab-completion by cycling through options
bind '"\t":menu-complete'

# Command prompt --------------------------------------------------------- {{{
bldblk='\e[1;30m' # Black - Bold
lightpink='\033[38;5;165m'
lightblue='\033[38;5;033m'
txtrst='\e[0m'    # Text Reset

HOST_PREFIX=$(echo $HOSTNAME | sed 's/\..*$//')
print_before_the_prompt() {
    printf "\n$lightblue[%s:%s] $bldblk%s $lightpink%s$txtrst\n" "$HOST_PREFIX" "$USER" "$PWD" "$(vcprompt)"
}

PROMPT_COMMAND=print_before_the_prompt
PS1='\[\e[1;30m\]->> \[\e[0m\]'
# ------------------------------------------------------------------------ }}}

# General aliases
alias ni='nvim'
alias R='R --quiet'
alias tree='tree -lC'

# System-specific aliases and settings ----------------------------------- {{{
case "${OSTYPE}" in
    # Mac OS X ----------------------------------------------------- {{{
    darwin*)
    alias iCloud='cd /Users/epwalsh/Library/Mobile\ Documents/com~apple~CloudDocs'
    alias tmux="TERM=screen-256color-bce tmux"
    alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app/'
    alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app/'
    alias ls='ls -FG'
    alias la='ls -a'

    source /usr/local/bin/virtualenvwrapper.sh
    workon py2.7
    ;;
    # -------------------------------------------------------------- }}}
    # Linux -------------------------------------------------------- {{{
    linux*)
    alias ls='ls -FG --color'
    alias la='ls -a'
    ;;
    # -------------------------------------------------------------- }}}
esac
# ------------------------------------------------------------------------ }}}

# Need this for matplotlib to work with a virtualenv ---------------------- {{{
# Instead of running script as 'python script.py' use 
# 'frameworkpython script.py'
function frameworkpython {
    if [[ ! -z "$VIRTUAL_ENV" ]]; then
        PYTHONHOME=$VIRTUAL_ENV /usr/local/bin/python "$@"
    else
        /usr/local/bin/python "$@"
    fi
}
# ------------------------------------------------------------------------- }}}
