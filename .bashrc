# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# Helpers
COLOR_RESET="\[\033[0m\]"
COLOR_FOREGROUND_RED="\[\033[31;1m\]"
COLOR_FOREGOURND_GREEN="\[\033[32;1m\]"
COLOR_FOREBROUND_BLUE="\[\033[34;1m\]"

current_git_branch()
{
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# append to the history file, don't overwrite it
shopt -s histappend

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

shopt -s expand_aliases

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*) color_prompt=yes;;
esac

PS_user_host='\u@\h'
PS_path='\w'
PS_git_branch='$(current_git_branch)'

if [ "$color_prompt" = yes ]; then
	PS_user_host="$COLOR_FOREGOURND_GREEN$PS_user_host$COLOR_RESET"
	PS_path="$COLOR_FOREBROUND_BLUE$PS_path$COLOR_RESET"
	PS_git_branch="$COLOR_FOREGROUND_RED$PS_git_branch$COLOR_RESET"
fi

PS1="\n$PS_user_host:$PS_path $PS_git_branch\n$ "
unset color_prompt

if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi


[ -f ~/.bash_aliases ] && . ~/.bash_aliases
[ -f ~/.bash_directories ] && . ~/.bash_directories
[ -f ~/.bash_environment ] && . ~/.bash_environment

xhost +local:root > /dev/null 2>&1

complete -cf sudo
