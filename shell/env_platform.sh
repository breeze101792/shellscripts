########################################################
########################################################
#####                                              #####
#####    For HS Platform Config Zone               #####
#####                                              #####
########################################################
########################################################

if [ "${HS_PLATFORM_WSL}" = "y" ]
then
    hs_print "Enable WSL Platform"
    if [ "$(umask)" = "0000" ] || [ "$(umask)" = "000" ]
    then
        umask 022
    fi
    export DISPLAY=:0
fi

if [ "${HS_PLATFORM_TTY_START}" = "y" ]
then
    # If running from tty1 start WM
    if [ "$(tty)" = "/dev/tty1" ]; then
        exec ${HS_VAR_TTY_START_CMD}
    fi
fi
