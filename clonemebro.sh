#!/bin/bash
# prints crap to paste into a machine to bootstrap gmason
echo "

Paste the following to bootstrap gmason:

# assume gmason already created, as sudo user

apt-get install zsh
apt-get install vim-nox
git clone https://github.com/nodoubleg/oh-my-zsh.git .oh-my-zsh
git clone https://github.com/nodoubleg/dotfiles.git
bash dotfiles/linkmebro.sh
chsh /bin/zsh



"
