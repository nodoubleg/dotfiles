if [[ "$OSTYPE" == darwin* ]]; then
  if [[ "$(uname -m)" == "arm64" ]]; then
    [[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    [[ -x /usr/local/bin/brew ]] && eval "$(/usr/local/bin/brew shellenv)"
  fi
else
  for brew_bin in \
    /home/linuxbrew/.linuxbrew/bin/brew \
    "$HOME/.linuxbrew/bin/brew"
  do
    if [[ -x "$brew_bin" ]]; then
      eval "$("$brew_bin" shellenv)"
      break
    fi
  done
fi
