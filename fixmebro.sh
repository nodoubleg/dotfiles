#!/bin/bash
# idempotent machine fixer for this dotfiles repo

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
backup_root="$HOME/.dotfiles-backups"
run_moom=false
show_shell_diffs=false

usage() {
  cat <<'EOF'
usage: fixmebro.sh [--moom]

Repairs dotfile links and installs only missing prerequisites.

options:
  --moom    import the tracked Moom settings if Moom is installed
  -h        show this help
EOF
}

log() {
  printf '%s\n' "$1"
}

show_conflict_diff() {
  local source_path="$1"
  local target_path="$2"

  [[ -f "$source_path" ]] || return 0
  [[ -f "$target_path" ]] || return 0

  if cmp -s "$source_path" "$target_path"; then
    return 0
  fi

  log "diff for conflicting $target_path:"
  diff -u --label "current:$target_path" --label "repo:$source_path" "$target_path" "$source_path" || true
}

backup_path() {
  local path="$1"
  local stamp backup_dir target

  [[ -e "$path" || -L "$path" ]] || return 0

  stamp="$(date +%Y%m%d-%H%M%S)"
  backup_dir="$backup_root/$stamp"
  mkdir -p "$backup_dir"
  target="$backup_dir/$(basename "$path")"
  mv "$path" "$target"
  log "backed up $path -> $target"
}

ensure_symlink() {
  local source_path="$1"
  local target_path="$2"

  mkdir -p "$(dirname "$target_path")"

  if [[ -L "$target_path" ]] && [[ "$(readlink "$target_path")" == "$source_path" ]]; then
    return 0
  fi

  if [[ -e "$target_path" || -L "$target_path" ]]; then
    if [[ "$show_shell_diffs" == true ]]; then
      show_conflict_diff "$source_path" "$target_path"
    fi
    backup_path "$target_path"
  fi

  ln -s "$source_path" "$target_path"
  log "linked $target_path -> $source_path"
}

ensure_file_copy() {
  local source_path="$1"
  local target_path="$2"

  mkdir -p "$(dirname "$target_path")"

  if [[ -f "$target_path" ]] && cmp -s "$source_path" "$target_path"; then
    return 0
  fi

  if [[ -e "$target_path" || -L "$target_path" ]]; then
    backup_path "$target_path"
  fi

  cp "$source_path" "$target_path"
  chmod +x "$target_path"
  log "installed $target_path"
}

ensure_git_repo() {
  local repo_url="$1"
  local target_path="$2"

  if [[ -d "$target_path/.git" ]]; then
    return 0
  fi

  if [[ -e "$target_path" || -L "$target_path" ]]; then
    backup_path "$target_path"
  fi

  git clone "$repo_url" "$target_path"
}

ensure_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    return 0
  fi

  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

setup_homebrew_env() {
  local brew_bin

  for brew_bin in \
    /opt/homebrew/bin/brew \
    /usr/local/bin/brew \
    /home/linuxbrew/.linuxbrew/bin/brew \
    "$HOME/.linuxbrew/bin/brew"
  do
    if [[ -x "$brew_bin" ]]; then
      eval "$("$brew_bin" shellenv)"
      return 0
    fi
  done

  return 1
}

install_homebrew_packages() {
  local packages=(
    coreutils
    pandoc
    pwgen
    thefuck
    starship
  )
  local package

  for package in "${packages[@]}"; do
    if ! brew list "$package" >/dev/null 2>&1; then
      brew install "$package"
    fi
  done
}

ensure_spacevim_layout() {
  ensure_git_repo https://spacevim.org/git/repos/SpaceVim/ "$HOME/.SpaceVim"
  ensure_symlink "$repo_root/.SpaceVim.d" "$HOME/.SpaceVim.d"
  ensure_symlink "$HOME/.SpaceVim" "$HOME/.vim"

  if [[ -e "$HOME/.vimrc" || -L "$HOME/.vimrc" ]]; then
    backup_path "$HOME/.vimrc"
  fi
  if [[ -e "$HOME/.gvimrc" || -L "$HOME/.gvimrc" ]]; then
    backup_path "$HOME/.gvimrc"
  fi
}

maybe_import_moom() {
  if [[ "$run_moom" != true ]]; then
    return 0
  fi

  if [[ "$(uname)" != "Darwin" ]]; then
    return 0
  fi

  if [[ ! -d /Applications/Moom.app ]]; then
    log "skipping Moom import: /Applications/Moom.app not found"
    return 0
  fi

  defaults import com.manytricks.Moom "$repo_root/Moom.plist"
  log "imported Moom settings"
}

while (($#)); do
  case "$1" in
    --moom)
      run_moom=true
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      usage
      exit 1
      ;;
  esac
  shift
done

if [[ "$(uname)" == "Darwin" ]]; then
  log "ensuring Homebrew and shell utilities..."
  ensure_homebrew
  setup_homebrew_env
  install_homebrew_packages
fi

log "ensuring oh-my-zsh..."
ensure_git_repo https://github.com/nodoubleg/oh-my-zsh.git "$HOME/.oh-my-zsh"

log "repairing shell links..."
show_shell_diffs=true
ensure_symlink "$repo_root/.zshrc" "$HOME/.zshrc"
ensure_symlink "$repo_root/.zprofile" "$HOME/.zprofile"
ensure_symlink "$repo_root/.zsh_completions" "$HOME/.zsh_completions"
ensure_symlink "$repo_root/.zshcompletion" "$HOME/.zshcompletion"
ensure_symlink "$repo_root/.config/starship.toml" "$HOME/.config/starship.toml"
show_shell_diffs=false
if [[ "$(uname)" == "Darwin" ]]; then
  ensure_symlink "$repo_root/org.gnupg.gpg-agent.plist" "$HOME/Library/LaunchAgents/org.gnupg.gpg-agent.plist"
fi

log "ensuring editor setup..."
ensure_spacevim_layout

log "installing ssh wrapper..."
ensure_file_copy "$repo_root/bin_ssh_wrapper.sh" "$HOME/bin/ssh"

maybe_import_moom

log "done"
