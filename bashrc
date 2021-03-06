#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
if [ "$(uname)" == "Darwin" ]; then
    export CLICOLOR=1
    export LSCOLORS=ExGxdxdxCxDxDxBxBxegeg 
else
    alias ls='ls --color=auto'
fi
alias rr='. ~/.bashrc'
alias cls='clear'
alias apt='sudo apt'

export PATH="/usr/local/sbin:/usr/local/bin:$PATH"
export EDITOR="vim"

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

#TODO: check .rbenv exists
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

source ~/config/vender/bundler-exec/bundler-exec.sh

