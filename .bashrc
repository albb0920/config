#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias rr='. ~/.bashrc'

# prompt
PS1='\[\e[1m\]\h [\w] -\u- \[\e[m\]'

# Smart Complete
if [ -f /etc/bash_completion ]; then
. /etc/bash_completion
fi

# disable tilde expand, stupid smart complete = =
_expand(){
    return 0;
}
