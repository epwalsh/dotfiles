# Base python dependencies.
pip2 install --upgrade pip setuptools wheel
pip3 install --upgrade pip setuptools wheel
pip2 install -r requirements.txt
pip3 install -r requirements.txt

# Powerline fonts.
cd ~/Downloads
git clone https://github.com/powerline/fonts.git
cd fonts
./install.sh
cd ..
rm -rf fonts/
cd ~/dotfiles
