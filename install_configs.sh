# Match hidden files with "*"
shopt -s dotglob

mkdir -p ~/.config

for filename in ~/dotfiles/bash/*; do
    filebase=`basename $filename`
    ln -sf $filename ~/$filebase
done

for filename in ~/dotfiles/tmux/.*; do
    filebase=`basename $filename`
    ln -sf $filename ~/$filebase
done

mkdir -p ~/.config/nvim
for filename in ~/dotfiles/neovim/*; do
    filebase=`basename $filename`
    ln -sf $filename ~/.config/nvim/$filebase
done

mkdir -p ~/.config/fish
for filename in ~/dotfiles/fish/*; do
    filebase=`basename $filename`
    ln -sf $filename ~/.config/fish/$filebase
done

mkdir -p ~/.config/alacritty
ln -sf ~/dotfiles/alacritty.yml ~/.config/alacritty/

ln -sf ~/dotfiles/starship.toml ~/.config/starship.toml

# Python linting configs.
ln -sf ~/dotfiles/.pylintrc ~/.config/.pylintrc
ln -sf ~/dotfiles/.pydocstyle ~/.config/.pydocstyle

# Neovim plugins.
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim +PlugInstall +qall
nvim +UpdateRemotePlugins +qall
