#!/bin/bash

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

iterm2_set_user_var () {
  PARENT_COMMAND=$(ps -o comm= $PPID)
  # Avoid to do send the command when ssh is not run by the shell
  if [ "$PARENT_COMMAND" = "bash" ] || [ "$PARENT_COMMAND" = "-zsh" ]; then
    printf "\033]1337;SetUserVar=%s=%s\007" "$1" $(printf "%s" "$2" | base64 | tr -d '\n')
  fi
}

on_exit () {
  iterm2_set_user_var current_ssh_host ""
}
trap on_exit EXIT

HOSTNAME=`echo $@ | sed s/.*@//`

iterm2_set_user_var current_ssh_host "$HOSTNAME"

/usr/bin/ssh "$@"
