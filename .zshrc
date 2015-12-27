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
unset LSCOLORS
alias ls="gls --color"
alias kmdns="sudo killall -9 mDNSResponder"
alias pwgen='openssl rand -base64 $1 2> /dev/null'
alias gpo='git push origin'
source /Users/gmason/.iterm2_shell_integration.zsh
export GIT_EDITOR='/usr/bin/vim'

## app-specific stuff
export HOMEBREW_GITHUB_API_TOKEN='ZOMG_SUCH_TOKEN!'


# no longer tab-complete usernames and other junk
unsetopt cdablevars
zstyle ':completion:*:functions' ignored-patterns '_*'


# hex <-> dec conversions
#

h2d(){
  echo "ibase=16; $@"|bc
}
d2h(){
  echo "obase=16; $@"|bc
}

PATH="/Users/gmason/perl5/bin${PATH+:}${PATH}"; export PATH;
PERL5LIB="/Users/gmason/perl5/lib/perl5${PERL5LIB+:}${PERL5LIB}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/gmason/perl5${PERL_LOCAL_LIB_ROOT+:}${PERL_LOCAL_LIB_ROOT}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/gmason/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/gmason/perl5"; export PERL_MM_OPT;
