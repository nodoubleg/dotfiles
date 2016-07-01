#!/bin/bash
# installs symlinks for dotfiles
rm ~/.zshrc
ln -s ~/dotfiles/.zshrc ~/.zshrc
rm ~/.vimrc
ln -s ~/dotfiles/.vimrc ~/.vimrc
rm ~/.gvimrc
ln -s ~/dotfiles/.gvimrc ~/.gvimrc
