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
if [ $HS_ENV_OS = "DARWIN" ]
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

# Don't use this line, now we auto detect it.
# alias nvim='TERM=xterm-256color && nvim '
# alias vim='TERM=xterm-256color && vim '
# alias vi='TERM=xterm-256color && vim -m '
alias pnvim='pvim -d nvim '

alias clips="clip -s "
alias clipx="clip -x "

########################################################
#####    Tools                                     #####
########################################################
alias fm="${HS_PATH_LIB}/tools/filemanager/filemanager.sh"
alias bashtop="${HS_PATH_LIB}/tools/bashtop/bashtop"

########################################################
#####    Dev                                       #####
########################################################
# git alias ##
alias gstatus='git status -uno '
alias gdiff='git diff --check --no-ext-diff'
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

#####    For update alias
########################################################
unalias glog 2> /dev/null
