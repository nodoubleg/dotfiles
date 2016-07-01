#!/bin/bash
# prints crap to paste into a machine to bootstrap gmason
# todo: turn this into a bunch of lxc exec calls
echo "

# paste this as root:

apt install zsh
apt install vim-nox
apt remove 
adduser gmason
cat /etc/sudoers.d/90-cloud* | sed -e s/ubuntu/gmason/g' > /etc/sudoers.d/80-gmason


# paste this as gmason:

git clone https://github.com/nodoubleg/oh-my-zsh.git .oh-my-zsh
git clone https://github.com/nodoubleg/dotfiles.git
bash dotfiles/linkmebro.sh
chsh /bin/zsh

"
