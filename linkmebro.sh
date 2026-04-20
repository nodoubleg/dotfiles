#!/bin/bash
# installs symlinks for dotfiles

ensure_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    return
  fi

  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

setup_homebrew_env() {
  if [[ "$(uname -m)" == "arm64" ]]; then
    [[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

install_homebrew_packages() {
  local packages=(
    coreutils
    pandoc
    pwgen
    thefuck
    starship
  )

  for package in "${packages[@]}"; do
    if ! brew list "$package" >/dev/null 2>&1; then
      brew install "$package"
    fi
  done
}

install_meslo_fonts() {
  local font_dir="$HOME/dotfiles/shameless_blobs/p10k-meslo-nerd-font"
  local font_name
  local fonts=(
    "MesloLGS NF Regular.ttf"
    "MesloLGS NF Bold.ttf"
    "MesloLGS NF Italic.ttf"
    "MesloLGS NF Bold Italic.ttf"
  )

  [[ "$(uname)" == "Darwin" ]] || return
  [[ -d "$font_dir" ]] || return

  mkdir -p "$HOME/Library/Fonts"
  for font_name in "${fonts[@]}"; do
    if [[ -f "$font_dir/$font_name" ]]; then
      cp "$font_dir/$font_name" "$HOME/Library/Fonts/$font_name"
    fi
  done
}

if [[ "$(uname)" == "Darwin" ]]; then
  echo "Installing Homebrew and shell utilities..."
  ensure_homebrew
  setup_homebrew_env
  install_homebrew_packages
  echo
fi

echo "Linking zsh config and oh-my-zsh..."
rm ~/.zshrc
ln -s ~/dotfiles/.zshrc ~/.zshrc
rm -f ~/.zprofile
ln -s ~/dotfiles/.zprofile ~/.zprofile
rm -rf ~/.zshcompletion
ln -s ~/dotfiles/.zshcompletion ~/.zshcompletion
rm ~/.zsh_completions
ln -s ~/dotfiles/.zsh_completions ~/.zsh_completions
mkdir -p ~/.config
cp ~/dotfiles/starship-presets/current-gmason.toml ~/.config/starship.toml
rm ~/Library/LaunchAgents/org.gnupg.gpg-agent.plist
ln -s org.gnupg.gpg-agent.plist ~/Library/LaunchAgents/org.gnupg.gpg-agent.plist
echo

# echo "SpaceVim init and setup..."
# rm ~/.SpaceVim.d
# ln -s ~/dotfiles/.SpaceVim.d ~/.SpaceVim.d
# rm -rf ~/.SpaceVim
# git clone https://spacevim.org/git/repos/SpaceVim/ ~/.SpaceVim
# rm -rf ~/.vim
# ln -s ~/.SpaceVim ~/.vim
# rm ~/.vimrc
# rm ~/.gvimrc
# echo

echo "setting up other apps..."
echo "Moom import. may need Moom installed if missing."
pkill Moom
defaults import com.manytricks.Moom ~/dotfiles/Moom.plist
open /Applications/Moom.app
echo "opening Moom preferences to validate settings..."
open /Applications/Moom.app

mkdir -p ~/bin
cp ~/dotfiles/bin_ssh_wrapper.sh ~/bin/ssh
chmod +x ~/bin/ssh

install_meslo_fonts

echo "done?"
