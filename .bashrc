alias iCloud='cd /Users/epwalsh/Library/Mobile\ Documents/com~apple~CloudDocs'
alias tmux="TERM=screen-256color-bce tmux"
alias linux10='ssh epwalsh@linux10.stat.iastate.edu'
alias mypro="ssh epwalsh@10.0.1.163"
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app/'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app/'
alias 511='cd ~/coursework/MATH-511/'
alias 515='cd ~/coursework/MATH-515/'
alias 516='cd ~/coursework/MATH-516/'
alias 641='cd ~/coursework/STAT-641/'
alias 642='cd ~/coursework/STAT-642/'
alias tmux-py2='tmux new-session "tmux source-file ~/.vim/tmux-ipython2"'
alias la='ls -aFG'
alias ls='ls -FG'
alias ecw='ssh pete@162.243.59.58'
alias impact1='ssh epwalsh@impact1.stat.iastate.edu'
alias aflex='ssh epwalsh@aflex.vrac.iastate.edu'
alias julia="exec '/Applications/Julia-0.4.3.app/Contents/Resources/julia/bin/julia'"

# txtblk='\e[0;30m' # Black - Regular
# txtred='\e[0;31m' # Red
# txtgrn='\e[0;32m' # Green
# txtylw='\e[0;33m' # Yellow
# txtblu='\e[0;34m' # Blue
# txtpur='\e[0;35m' # Purple
# txtcyn='\e[0;36m' # Cyan
# txtwht='\e[0;37m' # White
 
bldblk='\e[1;30m' # Black - Bold
# bldred='\e[1;31m' # Red
# bldgrn='\e[1;32m' # Green
# bldylw='\e[1;33m' # Yellow
# bldblu='\e[1;34m' # Blue
# bldpur='\e[1;35m' # Purple
# bldcyn='\e[1;36m' # Cyan
# bldwht='\e[1;37m' # White
 
# undblk='\e[4;30m' # Black - Underline
# undred='\e[4;31m' # Red
# undgrn='\e[4;32m' # Green
# undylw='\e[4;33m' # Yellow
# undblu='\e[4;34m' # Blue
# undpur='\e[4;35m' # Purple
# undcyn='\e[4;36m' # Cyan
# undwht='\e[4;37m' # White
 
# bakblk='\e[40m'   # Black - Background
# bakred='\e[41m'   # Red
# badgrn='\e[42m'   # Green
# bakylw='\e[43m'   # Yellow
# bakblu='\e[44m'   # Blue
# bakpur='\e[45m'   # Purple
# bakcyn='\e[46m'   # Cyan
# bakwht='\e[47m'   # White

lightpink='\033[38;5;165m'
lightblue='\033[38;5;033m'
 
txtrst='\e[0m'    # Text Reset

# Prompt
HOST_PREFIX=$(echo $HOSTNAME | sed 's/\..*$//')
print_before_the_prompt() {
    printf "\n$lightblue[%s:%s] $bldblk%s $lightpink%s$txtrst\n" "$HOST_PREFIX" "$USER" "$PWD" "$(vcprompt)"
}

PROMPT_COMMAND=print_before_the_prompt
PS1='\[\e[1;30m\]->> \[\e[0m\]'


source /usr/local/bin/virtualenvwrapper.sh 
workon py279

set -o vi
