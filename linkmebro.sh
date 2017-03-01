#!/bin/bash
# installs symlinks for dotfiles
rm ~/.zshrc
ln -s ~/dotfiles/.zshrc ~/.zshrc
rm ~/.zsh_completions
ln -s ~/dotfiles/.zsh_completions ~/.zsh_completions
rm ~/.vimrc
ln -s ~/dotfiles/.vimrc ~/.vimrc
rm ~/.gvimrc
ln -s ~/dotfiles/.gvimrc ~/.gvimrc
rm -rf ~/.vim
ln -s ~/dotfiles/.vim ~/.vim
rm ~/.vimrc.local
ln -s ~/dotfiles/.vimrc.local ~/.vimrc.local
rm ~/.vimrc.before.local
ln -s ~/dotfiles/.vimrc.before.local ~/.vimrc.before.local
rm ~/Library/LaunchAgents/org.gnupg.gpg-agent.plist
ln -s org.gnupg.gpg-agent.plist ~/Library/LaunchAgents/org.gnupg.gpg-agent.plist
