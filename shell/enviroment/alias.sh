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

alias ecd="ecd"
alias mark_build="mbuild "

########################################################
#####    Library                                   #####
########################################################
if [ $HS_ENV_OS = "bsd" ]
then
    alias ls='ls --color=auto '
    alias l='ls -a --color'
    alias lt='ls -a --color -t'
else
    alias ls='ls --color=auto --group-directories-first -X '
    alias l='ls -a --color=auto'
    alias lt='ls -a --color=auto -t'
fi
alias ll='l -lh'
alias llt='ll -t'
alias lld='ll -al $@| grep "^d"'

alias cgrep='grep --color=always '
alias sgrep='grep -rnIi  '
alias scgrep='grep --color=always -rnIi  '

alias vim='TERM=xterm-256color && vim '
alias vi='TERM=xterm-256color && vim -m '

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
