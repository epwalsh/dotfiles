if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

if [ -n "$TMUX" ]; then
    kill -INT $$
fi

export EDITOR=vim
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/GitHub/Code/Python

if [ "$(uname)" == "Darwin" ]; then
    export PATH="$PATH:/usr/local/Cellar/cmake/3.2.3/bin"
    export PATH="$PATH:/usr/local/texlive/2014/bin/x86_64-darwin"
    export PATH="$PATH:/Library/Frameworks/R.framework/Versions/3.1/Resources"
    export TERM="xterm-256color" 
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    export PATH=$HOME/.local/bin:$HOME/bin:$PATH
fi
