export PATH=$HOME/bin:$PATH

# Welcome message to decrease productivity
fortune | cowsay

# Vim-like keybindings
set -o vi

# Source other config files
for file in ~/.{bash_prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Use bash-completion2
if [ -f /usr/local/share/bash-completion/bash_completion ]; then
    . /usr/local/share/bash-completion/bash_completion
fi
