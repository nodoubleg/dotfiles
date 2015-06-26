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
plugins=(git osx)

source $ZSH/oh-my-zsh.sh

# custom completion
fpath=(~/.zshcompletion $fpath)

# Various paths
# VIM_APP_DIR looks to default to /Applications
#export VIM_APP_DIR="/Applications"
export PATH=/Users/gmason/bin:/usr/local/sbin:/usr/local/bin:$PATH

## aliases
alias hpc='ssh -X gateway.hpcc.msu.edu'
alias hpca='ssh -L 31337:192.168.0.19:22 -a -X gateway.hpcc.msu.edu'
alias gateway='ssh -X gateway.hpcc.msu.edu'
alias gateway0='ssh -X gateway-00.hpcc.msu.edu'
alias gateway1='ssh -X gateway-01.hpcc.msu.edu'
alias admin='ssh -A -X gmason@192.168.0.19'
alias admin0='ssh -A -X gmason@192.168.0.16'
alias admin1='ssh -A -X gmason@192.168.0.19'
alias rhel6='ssh -X gmason@172.16.186.127'
alias radmin='ssh -C -A -X -p 31337 gmason@localhost'
alias testgw='ssh -X gmason@testgw-00.i'
unset LSCOLORS
alias ls="gls --color"
alias kmdns="sudo killall -9 mDNSResponder"
alias root='nocorrect root'
alias tungw1025='ssh -L 1025:192.168.0.19:22 -a gateway-00.hpcc.msu.edu'
alias tunpup='ssh -L 31338:192.168.0.22:22 -p 1025 gmason@localhost'
alias tunvm='ssh -L 9443:172.16.98.13:9443 -p 1025 gmason@localhost'
alias pwgen='openssl rand -base64 $1 2> /dev/null'
alias gpo='git push origin'
source /Users/gmason/.iterm2_shell_integration.zsh

## app-specific stuff
export HOMEBREW_GITHUB_API_TOKEN='36caca807c24aaff614474677a2672721f3505f1'


# no longer tab-complete usernames and other junk
unsetopt cdablevars
