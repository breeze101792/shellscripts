########################################################
########################################################
#####                                              #####
#####    For HS Alias                              #####
#####                                              #####
########################################################
########################################################

########################################################
#####    Compatibility                             #####
########################################################

# alias ecd="ecd"
# alias mark_build="mbuild "

########################################################
#####    Library                                   #####
########################################################
if [ $HS_ENV_OS = "bsd" ]
then
    alias ls='ls --color=auto '
elif [ "${HS_PLATFORM_WSL}" = "y" ]
then
    alias ls='ls --color=never --group-directories-first -X'
else
    alias ls='ls --color=auto --group-directories-first -X '
fi

alias l='ls -a '
alias lt='ls -a -t '
alias lc='ls -a --color=always'

alias ll='l -lh'
alias llc='ls -lh --color=always'
alias llt='ll -t'
alias lld='ll -al $@| grep "^d"'

alias cgrep='grep --color=always '
alias sgrep='grep -rnIi  '
alias scgrep='grep --color=always -rnIi  '

alias nvim='TERM=xterm-256color && nvim '
alias vim='TERM=xterm-256color && vim '
alias vi='TERM=xterm-256color && vim -m '
alias pnvim='pvim -d nvim '

########################################################
#####    Tools                                     #####
########################################################
alias clips="clip -s "
alias clipx="clip -x "

########################################################
#####    Dev                                       #####
########################################################
# git alias ##
alias glog2="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
alias gstatus='git status -uno '
alias gdiff='git diff --check --no-ext-diff'
alias glog="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"
#alias lg="git $lg1"
alias nlfsgit="GIT_LFS_SKIP_SMUDGE=1 git "

alias mdebug="sdebug --device /dev/ttyUSB1"

########################################################
#####    Safe commands                             #####
########################################################
if [ "${HS_CONFIG_SAFE_COMMAND_REPLACEMENT}" = "y" ]
then
    alias rm=srm
fi
