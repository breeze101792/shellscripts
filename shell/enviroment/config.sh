########################################################
########################################################
#####                                              #####
#####    For HS Env Vars Zone                      #####
#####                                              #####
########################################################
########################################################
# This file is for env setup
# Put var, function & alias will be needed before sourc base_shell file
# Don't Set this flags
# Vars
export HS_ENV_VER=0.3.1
export HS_ENV_TITLE="DO IT NOW"

# test -z "${HS_ENV_OS}" && export HS_ENV_OS="LINUX"
case "$(uname -s)" in
    Linux*)     HS_ENV_OS="LINUX";;
    Darwin*)    HS_ENV_OS="DARWIN";;
    CYGWIN*)    HS_ENV_OS="CYGWIN";;
    MINGW*)     HS_ENV_OS="MINGW";;
    MSYS_NT*)   HS_ENV_OS="GIT";;
    *)          HS_ENV_OS="UNKNOWN:$(uname -s)"
esac

test -z "${HS_ENV_SHELL}" && export HS_ENV_SHELL=""
test -z "${HS_ENV_SILENCE}" && export HS_ENV_SILENCE=n
# enable HS System
test -z "${HS_ENV_ENABLE}" && export HS_ENV_ENABLE=true
test -z "${HS_ENV_MAIL}" && export HS_ENV_MAIL=""

########################################################
########################################################
#####                                              #####
#####    For HS Config Zone                        #####
#####                                              #####
########################################################
########################################################
test -z "${HS_CONFIG_ADVANCED_PROMOTE}" && export HS_CONFIG_ADVANCED_PROMOTE=y
test -z "${HS_CONFIG_CHANGE_DIR}" && export HS_CONFIG_CHANGE_DIR=y
test -z "${HS_CONFIG_SHELL_GIT_PARSE}" && export HS_CONFIG_SHELL_GIT_PARSE=y
test -z "${HS_CONFIG_SAFE_COMMAND_REPLACEMENT}" && export HS_CONFIG_SAFE_COMMAND_REPLACEMENT=n

# Only work on bash
test -z "${HS_CONFIG_FUNCTION_EXPORT}" && export HS_CONFIG_FUNCTION_EXPORT=n
test -z "${HS_CONFIG_IGNORE_SUBSHELL_FUNCTION_SOURCE}" && export HS_CONFIG_IGNORE_SUBSHELL_FUNCTION_SOURCE=n
########################################################
########################################################
#####                                              #####
#####    For HS Platform Config Zone               #####
#####                                              #####
########################################################
########################################################
# Default on
test -z "${HS_PLATFORM_LOCAL_USR}" && export HS_PLATFORM_LOCAL_USR=y
# Default off
test -z "${HS_PLATFORM_PRESERVE_DISK}" && export HS_PLATFORM_PRESERVE_DISK=n
test -z "${HS_PLATFORM_TTY_START}" && export HS_PLATFORM_TTY_START=n
test -z "${HS_PLATFORM_WSL}" && export HS_PLATFORM_WSL=n

########################################################
########################################################
#####                                              #####
#####    Path Setting Zone                         #####
#####                                              #####
########################################################
########################################################
# HS_PATH_LIB already setting on source.sh
test -z "${HS_PATH_DOWNLOAD}" && export HS_PATH_DOWNLOAD="${HOME}/downloads"
test -z "${HS_PATH_DOCUMENT}" && export HS_PATH_DOCUMENT="${HOME}/documents"
test -z "${HS_PATH_MEDIA}" && export HS_PATH_MEDIA="${HOME}/media"
test -z "${HS_PATH_LAB}" && export HS_PATH_LAB="${HOME}/lab"
test -z "${HS_PATH_BUILD}" && export HS_PATH_BUILD="${HOME}/build"
test -z "${HS_PATH_PROJ}" && export HS_PATH_PROJ="${HOME}/projects"
test -z "${HS_PATH_WORK}" && export HS_PATH_WORK="${HS_PATH_LIB}/../work"
test -z "${HS_PATH_IDE}" && export HS_PATH_IDE="${HS_PATH_LIB}/../vim-ide"
test -z "${HS_PATH_SLINK}" && export HS_PATH_SLINK="${HOME}/slink"
test -z "${HS_PATH_LOG}" && export HS_PATH_LOG="${HOME}/log"
# it's better to set tmp to ramdisk
test -z "${HS_PATH_TMP}" && export HS_PATH_TMP="${HOME}/.cache/hs_temp"

test -z "${HS_PATH_LOCAL_USR}" && export HS_PATH_LOCAL_USR="${HOME}/.usr"

test -z "${HS_PATH_PYTHEN_ENV}" && export HS_PATH_PYTHEN_ENV="${HOME}/env/pyenv"
# ECD
# export HS_VAR_ECD_CNT=2
test -z "${HS_VAR_ECD_NAME_0}" && export HS_VAR_ECD_NAME_0="@(tmp|t)"
test -z "${HS_PATH_ECD_0}" && export HS_PATH_ECD_0="/tmp"
test -z "${HS_VAR_ECD_NAME_1}" && export HS_VAR_ECD_NAME_1="h"
test -z "${HS_PATH_ECD_1}" && export HS_PATH_ECD_1="${HOME}"
# Add more commands
# addecd "tmp" "/tmp"
########################################################
########################################################
#####                                              #####
#####    Config Vars                               #####
#####                                              #####
########################################################
########################################################
test -z "${HS_VAR_CURRENT_DIR}" && export HS_VAR_CURRENT_DIR="CURRENT_DIR"
test -z "${HS_VAR_CLIPBOARD}" && export HS_VAR_CLIPBOARD="CLIPBOARD"
test -z "${HS_VAR_TTY_START_CMD}" && export HS_VAR_TTY_START_CMD="echo start WM"
test -z "${HS_VAR_VIM}" && export HS_VAR_VIM="vim"
test -z "${HS_VAR_LOGFILE}" && export HS_VAR_LOGFILE="LOGFILE"

########################################################
########################################################
#####                                              #####
#####    Tmp Setting Zone                          #####
#####                                              #####
########################################################
########################################################
# FIXME, this should move out to the config file
export HS_TMP_SESSION_PATH="${HS_PATH_TMP}/session"
export HS_TMP_FILE_CONFIG="${HS_PATH_TMP}/hs_config"
# export HS_FILE_CONFIG="${HOME}/.cache/hs_config"
