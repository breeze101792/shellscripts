########################################################
########################################################
#####                                              #####
#####    For HS Terminal Enviroment Zone           #####
#####                                              #####
########################################################
########################################################

## Terminal Session configs
########################################################
export LANGUAGE=en_US.UTF-8
export LANG="en_US.utf8"
if true
then
    # override all settings with en_US.utf8
    LC_ALL="en_US.utf8"
    # LC_CTYPE="en_US.utf8"
    # LC_NUMERIC="en_US.utf8"
    # LC_TIME="en_US.utf8"
    # LC_COLLATE="en_US.utf8"
    # LC_MONETARY="en_US.utf8"
    # LC_MESSAGES="en_US.utf8"
    # LC_PAPER="en_US.utf8"
    # LC_NAME="en_US.utf8"
    # LC_ADDRESS="en_US.utf8"
    # LC_TELEPHONE="en_US.utf8"
    # LC_MEASUREMENT="en_US.utf8"
    # LC_IDENTIFICATION="en_US.utf8"
fi

## Terminal Session configs
########################################################
if test -n "$TMUX"
then
    # echo "Tmux"
    export TERM="screen-256color"
elif test -n "$STY"
then
    # echo "Screen"
    export TERM="screen-256color"
else
    # echo "Others"
    export TERM="xterm-256color"
fi

## Default Programs
########################################################
export EDITOR=${HS_VAR_VIM}
export VISUAL=${HS_VAR_VIM}
