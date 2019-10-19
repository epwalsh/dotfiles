# Welcome message to decrease productivity
if ! [ -n "$TMUX" ]; then
    fortune | cowsay;
fi

for x in $HOME/bin $HOME/.cargo/bin /usr/local/bin /usr/local/sbin ; do
    if [[ ! -d $x ]]; then
        echo "Warning, path $x does not exist, skipping adding it to PATH" >&2
        continue
    fi
    case ":$PATH:" in
        *":$x:"*) :;; # already there
        *) export PATH="$x:$PATH";;
    esac
done

# Virtualenv setup.
export WORKON_HOME=$HOME/.virtualenvs
if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    source /usr/local/bin/virtualenvwrapper.sh
else
    source ~/.local/bin/virtualenvwrapper.sh
fi

# Source other config files
for file in ~/.{bash_prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done
unset file

# Vim-like keybindings
set -o vi

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Add tab completion for many Bash commands
if which brew &> /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
	source "$(brew --prefix)/share/bash-completion/bash_completion";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi

# Fuzzy auto-completion. See https://github.com/junegunn/fzf.
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Exclude certain patterns from vim completion.
complete -F _longopt -X '@(*.mypy_cache|*__pycache__|*.pdf|*.aux|*.png|*.jpg|*.jpeg|*.gif|*.dvi|*.svg|*.pyc|*.lock)' vim vi nvim ni

# Add `killall` tab completion for common apps
if [[ `uname` == 'Darwin' ]]; then
    complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal iTerm" killall;
fi

export PATH="$HOME/.cargo/bin:$PATH"
