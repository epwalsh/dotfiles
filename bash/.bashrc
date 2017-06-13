# The bashrc of Evan Pete Walsh >> epwalsh.com :: epwalsh10@gmail.com
#
# Last Modified: 2017-06-12 18:24:54
#
# This file is supposed to be sourced for interactive non-login shells in a 
# linux environment.
# If not running interactively, don't do anything:
case $- in
    *i*) ;;
    *) return;;
esac

# Welcome message
fortune | cowsay

# Vim-like keybindings
set -o vi

# Improve tab-completion by cycling through options
bind '"\t":menu-complete'

# Command prompt
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

# Aliases
alias ni='nvim'
alias R='R --quiet'
alias tree='tree -lC'
alias iCloud='cd /Users/epwalsh/Library/Mobile\ Documents/com~apple~CloudDocs'
alias tmux="TERM=screen-256color-bce tmux"
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app/'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app/'
alias ls='ls -FG'
alias la='ls -a'

function cd_ls {
    if [[ -z $1 ]]
    then
        cd ; ls
    else
        cd "$1"; ls
    fi
}

alias tree='tree --dirsfirst -C'
alias ..='cd_ls ..'
alias ...='cd_ls ../..'
alias ....='cd_ls ../../..'
alias .....='cd_ls ../../../..'
alias ......='cd_ls ../../../../..'

# Virtual environment
source /usr/local/bin/virtualenvwrapper.sh
workon py2.7

# Functions
pyclean () {
    find . | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf
}

codi() {
    local syntax="${1:-python}"
    shift
    nvim -c \
        "let g:startify_disable_at_vimenter = 1 |\
        set bt=nofile ls=0 noru nonu nornu |\
        hi ColorColumn ctermbg=NONE |\
        hi VertSplit ctermbg=NONE |\
        hi NonText ctermfg=0 |\
        Codi $syntax" "$@"
}
