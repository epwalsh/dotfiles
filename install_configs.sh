# Match hidden files with "*"
shopt -s dotglob

mkdir -p ~/.config

for filename in ~/dotfiles/bash/*; do
    filebase=`basename $filename`
    ln -s $filename ~/$filebase
done

for filename in ~/dotfiles/tmux/*; do
    filebase=`basename $filename`
    ln -s $filename ~/$filebase
done

mkdir -p ~/.config/nvim
for filename in ~/dotfiles/neovim/*; do
    filebase=`basename $filename`
    ln -s $filename ~/.config/nvim/$filebase
done

mkdir -p ~/.config/alacritty
for filename in ~/dotfiles/alacritty/*; do
    filebase=`basename $filename`
    ln -s $filename ~/.config/alacritty/$filebase
done

# Python linting configs.
ln -s ~/dotfiles/.pylintrc ~/.config/.pylintrc
ln -s ~/dotfiles/.pydocstyle ~/.config/.pydocstyle

# Neovim plugins.
git clone https://github.com/VundleVim/Vundle.vim.git ~/.config/nvim/bundle/Vundle.vim
nvim +PluginInstall +qall
nvim +UpdateRemotePlugins +qall
