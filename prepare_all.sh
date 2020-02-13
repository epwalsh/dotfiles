# Base python dependencies.
pip2 install --user --upgrade pip setuptools wheel
pip install --user --upgrade pip setuptools wheel
pip2 install --user -r requirements.txt
pip install --user -r requirements.txt

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
export VIRTUALENVWRAPPER_PYTHON=$(which python3)
source /usr/local/bin/virtualenvwrapper.sh
mkvirtualenv py3 -p $(which python3)
workon py3
pip install -r requirements.txt
