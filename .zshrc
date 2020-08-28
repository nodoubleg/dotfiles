# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

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
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
# TODO: add better test.


# git push to all remotes
alias gpall="git remote | xargs -L1 git push --all"
alias gpo='git push origin'

# custom completion
fpath=(~/.zshcompletion $fpath)

## app-specific stuff

# stupid hack to work around zsh's insistence upon keeping the same CWD.
#cd $HOME

# tab-complete ssh hosts
h=()
if [[ -r ~/.ssh/config ]]; then
  h=($h ${${${(@M)${(f)"$(cat ~/.ssh/config)"}:#Host *}#Host }:#*[*?]*})
fi
if [[ -r ~/.ssh/known_hosts ]]; then
  h=($h ${${${(f)"$(cat ~/.ssh/known_hosts{,2} || true)"}%%\ *}%%,*}) 2>/dev/null
fi
if [[ -r ~/.ssh/ldap_known_hosts ]]; then
  h=($h ${${${(f)"$(cat ~/.ssh/ldap_known_hosts{,2} || true)"}%%\ *}%%,*}) 2>/dev/null
fi
if [[ $#h -gt 0 ]]; then
  zstyle ':completion:*:ssh:*' hosts $h
  zstyle ':completion:*:slogin:*' hosts $h
fi

# no longer tab-complete usernames and other junk
unsetopt cdablevars
zstyle ':completion:*:functions' ignored-patterns '_*'

# let's try to stop honoring ctrl-s:
stty -ixon
# and resume on any key if that doesn't work:
stty ixany


# mkdir + cd
function mkdircd () { mkdir -p "$@" && eval cd "\"\$$#\"";  }

test -f ~/.sensitive_include && source ~/.sensitive_include

cd $HOME
unsetopt share_history


# GPG as SSH_AGENT!
# from: http://www.weinschenker.name/2013-10-08/use-gpgtools-for-ssh-logins-on-mac-os-x/
export GPG_TTY=$(tty)
if [ -f "${HOME}/.gpg-agent-info" ]; then
  . "${HOME}/.gpg-agent-info"
  export GPG_AGENT_INFO
fi

uname=$(uname)
if [[ ${uname}x != Linuxx ]]
then
  plugins=(gpg-agent git osx zsh-256color zsh_reload z hex2dec pandoc pwgen)
  unset LSCOLORS
  source $ZSH/oh-my-zsh.sh
  alias ls="/usr/local/bin/gls --color=tty"
  alias kmdns="sudo killall -9 mDNSResponder"
  source /Users/gmason/.iterm2_shell_integration.zsh
  # Various paths
  export PATH=/Users/gmason/bin:/usr/local/sbin:/usr/local/bin:$PATH
  alias gnubin='export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"'
else
  plugins=(pandoc git ubuntu zsh-256color hex2dec pwgen)
  alias open='xdg-open 2>/dev/null'
fi

# try using code for git?
#if command -v code >/dev/null 2>&1
#then
#  export GIT_EDITOR="`command -v code` -wr"
#else
#  export GIT_EDITOR='/usr/bin/vim'
#fi

. ~/.zsh_completions

# set up pandoc tab-complete
# Can't put this in an oh-my-zsh plugin because compinit shenanigans.
if command -v pandoc >/dev/null 2>&1
then
  autoload -U +X bashcompinit && bashcompinit
  pandoc --bash-completion | source /dev/stdin
fi
