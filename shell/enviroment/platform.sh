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

if [ "${HS_PLATFORM_LOCAL_USR}" = "y" ]
then
    hs_print "Enable Local Usr"
    if [ -d "${HS_PATH_LOCAL_USR}/bin" ]
    then
        epath ${HS_PATH_LOCAL_USR}/bin
    fi

    if [ -d "${HS_PATH_LOCAL_USR}/lib" ]
    then
        LD_LIBRARY_PATH=${HS_PATH_LOCAL_USR}/lib:${LD_LIBRARY_PATH}
    fi
fi

if [ "${HS_PLATFORM_TTY_START}" = "y" ]
then
    # If running from tty1 start WM
    if [ "$(tty)" = "/dev/tty1" ]; then
        exec ${HS_VAR_TTY_START_CMD}
    fi
fi

if [ "${HS_PLATFORM_PRESERVE_DISK}" = "y" ]
then
    hs_print "Enable Platform save Disk write"
    # On Python, when you run it, it will not create __pycache__
    export PYTHONDONTWRITEBYTECODE=1
fi
