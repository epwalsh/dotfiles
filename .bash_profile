if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

if [ -n "$TMUX" ]; then
    kill -INT $$
fi

export PATH="$PATH:/usr/local/Cellar/cmake/3.2.3/bin"
export PATH="$PATH:/usr/local/texlive/2014/bin/x86_64-darwin"
export PATH="$PATH:/Library/Frameworks/R.framework/Versions/3.1/Resources"
export TERM="xterm-256color" 
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/GitHub/Code/Python
export EDITOR=vim
