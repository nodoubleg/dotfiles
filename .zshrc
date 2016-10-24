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
uname=$(uname)
if [[ ${uname}x != Linuxx ]]
then
  plugins=(git osx)
  unset LSCOLORS
  alias ls="gls --color"
  alias kmdns="sudo killall -9 mDNSResponder"
  source /Users/gmason/.iterm2_shell_integration.zsh
  PATH="/Users/gmason/perl5/bin${PATH+:}${PATH}"; export PATH;
  PERL5LIB="/Users/gmason/perl5/lib/perl5${PERL5LIB+:}${PERL5LIB}"; export PERL5LIB;
  PERL_LOCAL_LIB_ROOT="/Users/gmason/perl5${PERL_LOCAL_LIB_ROOT+:}${PERL_LOCAL_LIB_ROOT}"; export PERL_LOCAL_LIB_ROOT;
  PERL_MB_OPT="--install_base \"/Users/gmason/perl5\""; export PERL_MB_OPT;
  PERL_MM_OPT="INSTALL_BASE=/Users/gmason/perl5"; export PERL_MM_OPT;
  export HOMEBREW_GITHUB_API_TOKEN='ZOMG_SUCH_TOKEN!'
  # Various paths
  # VIM_APP_DIR looks to default to /Applications
  #export VIM_APP_DIR="/Applications"
  export PATH=/Users/gmason/bin:/usr/local/sbin:/usr/local/bin:$PATH
export HOMEBREW_GITHUB_API_TOKEN='ZOMG_SUCH_TOKEN!'
else
  plugins=(git ubuntu zsh-256color)
  export PATH=/home/gmason/bin:/home/gmason/bin/juju-tools:/usr/local/sbin:/usr/local/bin:$PATH
  alias open='xdg-open 2>/dev/null'
  alias jsft='juju status --format=tabular'
  alias log_edit="ssh -t adelie.canonical.com log_edit $1"
  alias log_view="ssh -t adelie.canonical.com log_view $1"
  alias ubuntu-dev-tools='lxc exec ubuntu-dev-things su - gmason'
  alias sup-mail='lxc exec kvm0:sup-mail -- su - gmason -c sup-mail'
  export SSH_ASKPASS=/usr/bin/ksshaskpass
  export JUJU_REPOSITORY=$HOME/charms
  #alias nukelxc="sudo find /run/lxcfs/controllers/pids/lxc/ -maxdepth 1 -type d | grep -v '/$' | xargs -n1 basename | xargs lxc delete -f"
  if [ -n ${TMUX+x} ]; then
      alias vi="export TERM=xterm-256color;vi"
  fi
  alias ham=hamster-cli
  alias hams='hamster-cli stop'
  alias haml='hamster-cli list'
  alias hamb='hamster-cli start'
fi

source $ZSH/oh-my-zsh.sh

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

#test $KONSOLE_PROFILE_NAME && export TERM=screen-256color
## workaround for handling TERM variable in multiple tmux sessions properly from http://sourceforge.net/p/tmux/mailman/message/32751663/ by Nicholas Marriott
# if [[ -n ${TMUX} && -n ${commands[tmux]} ]];then
# 	case $(tmux showenv TERM 2>/dev/null) in
		# *256color) ;&
		# TERM=fbterm)
			# TERM=screen-256color ;;
		# *)
			# TERM=screen
	# esac
# fi

export check='✔️'

PATH="/home/gmason/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/gmason/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/gmason/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/gmason/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/gmason/perl5"; export PERL_MM_OPT;
