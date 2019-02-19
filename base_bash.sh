#!/usr/bin/env bash
# shell options
parse_git_branch()
{
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

set_current_path()
{
    echo `pwd` > $HS_ENV_CONFIG
}
export PS1="[\[$(tput sgr0)\]\[\033[38;5;11m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;10m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\]]-[\[$(tput sgr0)\]\[\033[38;5;10m\]\l\[$(tput sgr0)\]\[\033[38;5;15m\]]-[\[$(tput sgr0)\]\[\033[38;5;11m\]\$?\[$(tput sgr0)\]\[\033[38;5;15m\]]-[\d \t]-\[\033[33m\]\$(parse_git_branch)$(set_current_path)\[\033[00m\]-[\[$(tput sgr0)\]\[\033[38;5;6m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]]\n->\[$(tput sgr0)\]"

#shopt -s cdable_vars

if [ "$HS_CONFIG_I3_PATCH" = "y" ]
then
    if [ -e $HS_ENV_CONFIG ]
    then
       cd $(cat $HS_ENV_CONFIG)
    fi
fi
