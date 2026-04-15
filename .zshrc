# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

typeset -U path PATH fpath FPATH
zmodload zsh/stat

export HOMEBREW_NO_ENV_HINTS=1
ZSH_DISABLE_COMPFIX=true

#zmodload zsh/zprof

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="gmason"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
# TODO: add better test.


# git push to all remotes
alias gpall="git remote | xargs -L1 git push --all"
alias gpo='git push origin'

# custom completion
fpath=("$HOME/.zshcompletion" $fpath)

GMASON_SHELL_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/gmason-shell"
GMASON_SSH_HOSTS_CACHE="$GMASON_SHELL_CACHE_DIR/ssh-hosts.txt"
GMASON_SHELL_CACHE_UPDATER="$HOME/dotfiles/update_shell_caches.sh"
GMASON_SSH_HOSTS_CACHE_MAX_SIZE=$((1024 * 1024))

_gmason_load_ssh_hosts() {
  local -A cache_stat

  [[ -f "$GMASON_SSH_HOSTS_CACHE" ]] || return 1
  [[ ! -L "$GMASON_SSH_HOSTS_CACHE" ]] || return 1

  zstat -H cache_stat -- "$GMASON_SSH_HOSTS_CACHE" || return 1
  (( cache_stat[size] <= GMASON_SSH_HOSTS_CACHE_MAX_SIZE )) || return 1

  GMASON_SSH_HOSTS=("${(@f)$(<"$GMASON_SSH_HOSTS_CACHE")}")
}

_gmason_apply_ssh_hosts() {
  (( ${+GMASON_SSH_HOSTS} && ${#GMASON_SSH_HOSTS[@]} > 0 )) || return 0
  zstyle ':completion:*:ssh:*' hosts $GMASON_SSH_HOSTS
  zstyle ':completion:*:slogin:*' hosts $GMASON_SSH_HOSTS
}

_gmason_refresh_ssh_hosts_cache() {
  [[ -x "$GMASON_SHELL_CACHE_UPDATER" ]] || return 0

  if [[ -r "$GMASON_SSH_HOSTS_CACHE" ]]; then
    "$GMASON_SHELL_CACHE_UPDATER" ssh-hosts --if-older-than 86400 --if-inputs-newer >/dev/null 2>&1 &!
  else
    "$GMASON_SHELL_CACHE_UPDATER" ssh-hosts >/dev/null 2>&1
  fi
}

_gmason_load_ssh_hosts || true
_gmason_apply_ssh_hosts
_gmason_refresh_ssh_hosts_cache
if [[ -r "$GMASON_SSH_HOSTS_CACHE" ]] && (( ! ${+GMASON_SSH_HOSTS} || ${#GMASON_SSH_HOSTS[@]} == 0 )); then
  _gmason_load_ssh_hosts || true
  _gmason_apply_ssh_hosts
fi

## app-specific stuff

# stupid hack to work around zsh's insistence upon keeping the same CWD.
#cd $HOME

# no longer tab-complete usernames and other junk
unsetopt cdablevars
zstyle ':completion:*:functions' ignored-patterns '_*'

if [[ -t 0 ]]; then
  # let's try to stop honoring ctrl-s:
  stty -ixon
  # and resume on any key if that doesn't work:
  stty ixany
fi


# mkdir + cd
mkdircd() {
  (( $# )) || return 1
  mkdir -p -- "$@" && builtin cd -- "${@[-1]}"
}

test -f ~/.sensitive_include && source ~/.sensitive_include

unsetopt share_history
setopt incappendhistory


# GPG as SSH_AGENT!
# NOTE: this legacy block targeted an alternate macOS gpg-agent setup.
# It is commented out while gpg-agent is reconfigured (OMZ plugin will handle it later).
#eval $(/opt/homebrew/bin/gpg-agent --daemon 2> /dev/null)
#export GPG_TTY=$(tty)
#if [ -f "${HOME}/.gpg-agent-info" ]; then
#  . "${HOME}/.gpg-agent-info"
#  export GPG_AGENT_INFO
#  export SSH_AUTH_SOCK
#fi

if [[ "$OSTYPE" == darwin* ]]
then
  plugins=(git yolo macos z hex2dec pandoc pwgen colored-man-pages safe-paste man brew thefuck perl starship iterm2)
  zstyle ':omz:plugins:iterm2' shell-integration yes
  unset LSCOLORS
  if [[ -x /opt/homebrew/bin/gls ]]; then
    alias ls="/opt/homebrew/bin/gls --color=tty"
  fi
  alias kmdns="sudo killall -9 mDNSResponder"
  # Various paths
  path=(/Users/gmason/bin /usr/local/sbin /usr/local/bin $path)
  alias gnubin='export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"'
elif [[ "$OSTYPE" == linux* ]]
then
  plugins=(pandoc git yolo ubuntu hex2dec pwgen colored-man-pages safe-paste man thefuck perl starship iterm2)
  alias open='xdg-open 2>/dev/null'
fi

if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi

. ~/.zsh_completions

# try using code for git?
#if command -v code >/dev/null 2>&1
#then
#  export GIT_EDITOR="`command -v code` -wr"
#else
#  export GIT_EDITOR='/usr/bin/vim'
#fi
# Google cloud sdk stuff
#source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
#source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"

if [ -d /opt/puppetlabs/bin ]; then
  path=(/opt/puppetlabs/bin $path)
fi
if [ -d /opt/puppetlabs/pdk/bin ]; then
  path=(/opt/puppetlabs/pdk/bin $path)
fi

#zprof

if [[ -d /Users/gmason/perl5 ]]; then
  eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"
fi

if [[ -d /Users/gmason/.nvcodex ]]; then
  path+=("/Users/gmason/.nvcodex/bin")
fi

#eval "$(starship init zsh)"
