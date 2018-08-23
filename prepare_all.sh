# Base python dependencies.
sudo pip install --upgrade pip setuptools wheel
sudo pip install -r requirements.txt

# Powerline fonts.
cd ~/Downloads
git clone https://github.com/powerline/fonts.git
cd fonts
./install.sh
cd ..
rm -rf fonts/
cd ~/dotfiles

# Install vcprompt.
mkdir -p $HOME/bin
curl -sL https://github.com/djl/vcprompt/raw/master/bin/vcprompt > $HOME/bin/vcprompt
chmod 755 $HOME/bin/vcprompt

# Setup python virtualenv.
export WORKON_HOME=$HOME/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh
mkvirtualenv py3.6 -p $(which python3.6)
workon py3.6
pip install -r requirements.txt
