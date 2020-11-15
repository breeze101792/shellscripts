#!/usr/bin/env bash

# If not running interactively, don't do anything
[ -z "$PS1" ] && return
# case $- in
#     *i*) ;;
#       *) return;;
# esac

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

export PS1="[\[$(tput sgr0)\]\[\033[38;5;11m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;10m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\]][\d \t]\
\$(item_promote \$(check_cmd_status \$?))\
\$(item_promote \$(parse_git_branch))\
\$(set_working_path -s)\
[\[$(tput sgr0)\]\[\033[38;5;6m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]]\n-> \[$(tput sgr0)\]"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
shopt -s cdable_vars

# prevents you from overwriting existing files with the > operator.
# To manually overwrite a file while noclobber is set
# echo "output" >| file.txt
set -o noclobber

# enter path will auto cd
shopt -s autocd

# change bash auto-complete
# If there are multiple matches for completion, Tab should cycle through them
bind 'TAB':menu-complete 2> /dev/null
# Display a list of the matching files
bind "set show-all-if-ambiguous on" 2> /dev/null
# Perform partial completion on the first Tab press,
# only start cycling full results on the second Tab press
bind "set menu-complete-display-prefix on" 2> /dev/null

# If a tab-completed file is a symlink to a directory,
# treat it like a directory not a file
set mark-symlinked-directories on

# Use GNU ls colors when tab-completing files
set colored-stats on


# Edit with Vi keybindings
set editing-mode vi
set keymap vi

shell_setup bash
