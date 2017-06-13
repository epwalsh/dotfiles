export PATH=$HOME/bin:$PATH

# Welcome message to decrease productivity
fortune | cowsay

# Vim-like keybindings
set -o vi

# Improve tab-completion by cycling through options
bind '"\t":menu-complete'

# Source other config files
for file in ~/.{bash_prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;
