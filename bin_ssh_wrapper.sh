#!/bin/zsh

emulate -L zsh
setopt nounset pipefail

# Script that updates the iTerm Badge with the hostname of the server that you are
# connecting to with ssh.
#
# Instructions:
# - Put this script in ~/bin/ssh (this will override the default ssh binary)
# - Run 'chmod +x ~/bin/ssh' to give execution permission to the script
# - Open iTerm\Preferences\Profiles, select your profile and put '\(user.current_ssh_host)' in the Badge text box
# - Enjoy!
#
# Troubleshoot issues:
# - If it's not working, make sure your shell is white-listed in the script (see $PARENT_COMMAND in the script)
#
# Credits: inspired by https://engineering.talis.com/articles/bash-osx-colored-ssh-terminal/

DOTFILES_DIR="${HOME}/dotfiles"
SHELL_CACHE_UPDATER="${DOTFILES_DIR}/update_shell_caches.sh"

iterm2_set_user_var () {
  local parent_command

  parent_command="$(ps -o comm= "$PPID" 2>/dev/null || true)"
  # Avoid to do send the command when ssh is not run by the shell
  case "$parent_command" in
    bash|-bash|zsh|-zsh)
      printf "\033]1337;SetUserVar=%s=%s\007" "$1" "$(printf "%s" "$2" | base64 | tr -d '\n')"
      ;;
  esac
}

on_exit () {
  iterm2_set_user_var current_ssh_host ""
}
trap on_exit EXIT

ssh_target() {
  local arg
  local skip_next=false

  for arg in "$@"; do
    if [[ "$skip_next" == true ]]; then
      skip_next=false
      continue
    fi

    case "$arg" in
      -[BbcDEeFIiJLMmOopQRSWw])
        skip_next=true
        continue
        ;;
      -[BbcDEeFIiJLMmOopQRSWw]?*)
        continue
        ;;
      --)
        continue
        ;;
      -*)
        continue
        ;;
      *@*)
        printf '%s\n' "${arg##*@}"
        return 0
        ;;
      *)
        printf '%s\n' "$arg"
        return 0
        ;;
    esac
  done
}

refresh_ssh_completion_cache() {
  [[ -x "$SHELL_CACHE_UPDATER" ]] || return 0
  "$SHELL_CACHE_UPDATER" ssh-hosts --if-inputs-newer >/dev/null 2>&1 &!
}

ssh_host="$(ssh_target "$@")"
if [[ -n "${ssh_host:-}" ]]; then
  iterm2_set_user_var current_ssh_host "$ssh_host"
fi

/usr/bin/ssh "$@"
ssh_status=$?
refresh_ssh_completion_cache
exit "$ssh_status"
