# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename "${HOME}/.zshrc"

# autoload -Uz compinit
# compinit
# End of lines added by compinstall

# custom zsh
zstyle ':completion:*' menu select

# load theme promot
autoload -Uz compinit promptinit
compinit
promptinit

# bash completion compatiable
autoload bashcompinit
bashcompinit

# This will set the default prompt to the walters theme
prompt walters

# serarch history
#autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
#zle -N up-line-or-beginning-search
#zle -N down-line-or-beginning-search

#------------------------------
# Key Settings
#------------------------------

# [[ -n "${key[Up]}"   ]] && bindkey "${key[Up]}"   up-line-or-beginning-search
# [[ -n "${key[Down]}" ]] && bindkey "${key[Down]}" down-line-or-beginning-search
#
## home & end
# bindkey "${terminfo[khome]}" beginning-of-line
# bindkey "${terminfo[kend]}" end-of-line
# bindkey "${terminfo[kdch1]}" delete-char

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"      beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"       end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"    overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}" backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"    delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"        up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"      down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"      backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"     forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"    beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"  end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}" reverse-menu-complete

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
    autoload -Uz add-zle-hook-widget
    function zle_application_mode_start { echoti smkx }
    function zle_application_mode_stop { echoti rmkx }
    add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
    add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

# define extra keys
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line

# bindkey ";5C" forward-word
# bindkey ";5D" backward-word

#------------------------------
# Prompt
#------------------------------
autoload -U colors zsh/terminfo
colors

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git hg
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git*' formats "%{${fg[cyan]}%}[%{${fg[green]}%}%s%{${fg[cyan]}%}][%{${fg[blue]}%}%r/%S%%{${fg[cyan]}%}][%{${fg[blue]}%}%b%{${fg[yellow]}%}%m%u%c%{${fg[cyan]}%}]%{$reset_color%}"

# function check_cmd_status()
# {
#     RETVAL=$?
#     case $RETVAL in 
#         1)
#             echo "%B%F{yellow}Error%b%F{cyan}][%f"
#             ;;
#         0)
#             return 0
#             ;;
#         *)
#             return $RETVAL
#             ;;
#     esac
# }

# set_current_path()
# {
#     if [ -e "${HS_TMP_FILE_CONFIG}" ] && [ -f "${HS_TMP_FILE_CONFIG}" ]
#     then
#         echo `pwd` > ${HS_TMP_FILE_CONFIG}
#     else
#         echo "[Set Current path fail]"
#     fi
# }
#parse_git_branch()
#{
#    #git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
#    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1%F{cyan}][%f/'
#}
# nonzero_return() {
#     RETVAL=$?
#     [ $RETVAL -ne 0 ] && echo "-$RETVAL-"
# }
setprompt() {
  setopt prompt_subst

  if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then 
    p_host='%F{yellow}%M%f'
  else
    p_host='%F{green}%M%f'
  fi

  PS1=${(j::Q)${(Z:Cn:):-$'
    %F{white}[%f
    %(!.%F{red}%n%f.%F{white}%n%f)
    %F{white}@%f
    ${p_host}
    %F{white}][%f
    %F{white}%T-%w%f
    %F{white}]%f
    $(item_promote $(check_cmd_status $?))
    $(item_promote $(parse_git_branch))
    %F{white}`set_working_path -s`%f
    %F{white}[%f
    %F{cyan}%~%f
    %F{white}]%f
  '}}$'\n%(!.%F{red}%#%f.%F{white}%#%f) '

  PS2=$'%_>'
  RPROMPT=$'${vcs_info_msg_0_}'
}
setprompt_lite() {
  setopt prompt_subst

  if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then 
    p_host='%F{yellow}%M%f'
  else
    p_host='%F{green}%M%f'
  fi

  PS1=${(j::Q)${(Z:Cn:):-$'
    %F{white}[%f
    %(!.%F{red}%n%f.%F{white}%n%f)
    %F{white}@%f
    ${p_host}
    %F{white}][%f
    %F{white}%T-%w%f
    %F{white}]%f
    %F{white}[%f
    %F{cyan}%~%f
    %F{white}]%f
  '}}$'\n%(!.%F{red}%#%f.%F{white}%#%f) '

  PS2=$'%_>'
  RPROMPT=$'${vcs_info_msg_0_}'
}
if [ "${HS_CONFIG_ADVANCED_PROMOTE}" = "y" ]
then
    setprompt
else
    setprompt_lite
fi

# firefox download path
#if [ ! -d "/tmp/downloads_tmp" ];
#then
#   mkdir /tmp/downloads_tmp
#   ln -sf /tmp/downloads_tmp $HOME/downloads
#fi
#alias path
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
alias -g .......='../../../../../..'
alias -g ........='../../../../../../..'

#alias btspeaker='cat /home/shaowu/.usr/script/speaker_connect.bt | bluetoothctl'
# command
shell_setup zsh
