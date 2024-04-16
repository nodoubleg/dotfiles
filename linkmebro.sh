#!/bin/bash
# installs symlinks for dotfiles

echo "Linking zsh config and oh-my-zsh..."
rm ~/.zshrc
ln -s ~/dotfiles/.zshrc ~/.zshrc
rm ~/.zsh_completions
ln -s ~/dotfiles/.zsh_completions ~/.zsh_completions
rm ~/Library/LaunchAgents/org.gnupg.gpg-agent.plist
ln -s org.gnupg.gpg-agent.plist ~/Library/LaunchAgents/org.gnupg.gpg-agent.plist
echo

echo "SpaceVim init and setup..."
rm ~/.SpaceVim.d
ln -s ~/dotfiles/.SpaceVim.d ~/.SpaceVim.d
rm -rf ~/.SpaceVim
git clone https://spacevim.org/git/repos/SpaceVim/ ~/.SpaceVim 
rm -rf ~/.vim
ln -s ~/.SpaceVim ~/.vim
rm ~/.vimrc
rm ~/.gvimrc

echo "done?"
