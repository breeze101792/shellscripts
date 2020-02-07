#!/usr/bin/env bash
export PS1="[\[$(tput sgr0)\]\[\033[38;5;11m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;10m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\]]-[\d \t]\$(check_cmd_status \$?)\$(item_promote \$(parse_git_branch))\$(set_working_path -s)[\[$(tput sgr0)\]\[\033[38;5;6m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]]\n->\[$(tput sgr0)\]"

#shopt -s cdable_vars

if [ "${HS_CONFIG_CHANGE_DIR}" = "y" ]
then
    set_working_path -g
fi
