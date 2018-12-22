# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/shaowu/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# custom zsh
zstyle ':completion:*' menu select

# load theme promot
autoload -Uz compinit promptinit
compinit
promptinit

# This will set the default prompt to the walters theme
prompt walters

# serarch history
#autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
#zle -N up-line-or-beginning-search
#zle -N down-line-or-beginning-search
#
#[[ -n "${key[Up]}"   ]] && bindkey "${key[Up]}"   up-line-or-beginning-search
#[[ -n "${key[Down]}" ]] && bindkey "${key[Down]}" down-line-or-beginning-search
#
## home & end
#bindkey "${terminfo[khome]}" beginning-of-line
#bindkey "${terminfo[kend]}" end-of-line
#bindkey "${terminfo[kdch1]}" delete-char

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char
# define extra keys
bindkey "[C" forward-word
bindkey "[D" backward-word

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
	function zle-line-init () {
		echoti smkx
	}
	function zle-line-finish () {
		echoti rmkx
	}
	zle -N zle-line-init
	zle -N zle-line-finish
fi

## home user bin to PATH ##
export PATH=$PATH:$HOME/.usr/bin/

## Default Editor  ##
export EDITOR=vim
export VISUAL=vim

#------------------------------
# Prompt
#------------------------------
autoload -U colors zsh/terminfo
colors

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git hg
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git*' formats "%{${fg[cyan]}%}[%{${fg[green]}%}%s%{${fg[cyan]}%}][%{${fg[blue]}%}%r/%S%%{${fg[cyan]}%}][%{${fg[blue]}%}%b%{${fg[yellow]}%}%m%u%c%{${fg[cyan]}%}]%{$reset_color%}"

set_current_path()
{
    pwd > $HS_ENV_CONFIG
}
parse_git_branch()
{
    #git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1%F{cyan}][%f/'
}
nonzero_return() {
	RETVAL=$?
	[ $RETVAL -ne 0 ] && echo "-$RETVAL-"
}
setprompt() {
  setopt prompt_subst

  if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then 
    p_host='%F{yellow}%M%f'
  else
    p_host='%F{green}%M%f'
  fi

  PS1=${(j::Q)${(Z:Cn:):-$'
    %F{cyan}[%f
    %(!.%F{red}%n%f.%F{green}%n%f)
    %F{cyan}@%f
    ${p_host}
    %F{cyan}][%f
    %F{blue}%T-%w%f
    %F{cyan}][%f
    %F{white}`parse_git_branch``set_current_path`%f
    %F{blue}%~%f
    %F{cyan}]%f
    %(!.%F{red}%#%f.%F{green}%#%f)
    " "
  '}}

  PS2=$'%_>'
  RPROMPT=$'${vcs_info_msg_0_}'
}
setprompt

# firefox download path
#if [ ! -d "/tmp/downloads_tmp" ];
#then
#	mkdir /tmp/downloads_tmp
#	ln -sf /tmp/downloads_tmp $HOME/downloads
#fi
#alias path
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
alias -g .......='../../../../../..'
alias -g ........='../../../../../../..'

## alias
alias ls='ls --color=auto'
alias ll='ls -alh'
alias l='ls -a'
#alias btspeaker='cat /home/shaowu/.usr/script/speaker_connect.bt | bluetoothctl'
# command
if [ "$HS_CONFIG_I3_PATCH" = "y" ]
then
    if [ -e $HS_ENV_CONFIG ]
    then
       cd $(cat $HS_ENV_CONFIG)
    fi
fi
