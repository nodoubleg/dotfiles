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

source $ZSH/oh-my-zsh.sh

uname=$(uname)
if [[ ${uname}x != Linuxx ]]
then
  plugins=(git osx zsh-256color)
  unset LSCOLORS
  alias ls="/usr/local/bin/gls --color=tty"
  alias kmdns="sudo killall -9 mDNSResponder"
  source /Users/gmason/.iterm2_shell_integration.zsh
  export HOMEBREW_GITHUB_API_TOKEN='ZOMG_SUCH_TOKEN!'
  # Various paths
  # VIM_APP_DIR looks to default to /Applications
  #export VIM_APP_DIR="/Applications"
  export PATH=/Users/gmason/bin:/usr/local/sbin:/usr/local/bin:$PATH
else
  plugins=(git ubuntu zsh-256color)
  alias open='xdg-open 2>/dev/null'
fi


# git push to all remotes
alias gpall="git remote | xargs -L1 git push --all"

# custom completion
fpath=(~/.zshcompletion $fpath)


export GIT_EDITOR='/usr/bin/vim'
alias gpo='git push origin'

## app-specific stuff

# stupid hack to work around zsh's insistence upon keeping the same CWD.
cd $HOME

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


# hex <-> dec conversions
#

h2d(){
  echo "ibase=16; $@"|bc
}
d2h(){
  echo "obase=16; $@"|bc
}

test -f ~/.sensitive_include && source ~/.sensitive_include

cd $HOME
unsetopt share_history

. ~/.zsh_completions


