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
export HS_ENV_SHELL=""
export HS_ENV_VER=0.2.6
export HS_ENV_TITLE="DO IT NOW"
export HS_ENV_SILENCE=n
# enable HS System
export HS_ENV_ENABLE=true
export HS_ENV_MAIL=""
export HS_ENV_CPU_NUMBER="8"

########################################################
########################################################
#####                                              #####
#####    For HS Config Zone                        #####
#####                                              #####
########################################################
########################################################
export HS_CONFIG_CHANGE_DIR=y
# Only work on bash
export HS_CONFIG_FUNCTION_EXPORT=n
########################################################
########################################################
#####                                              #####
#####    For HS Platform Config Zone               #####
#####                                              #####
########################################################
########################################################
export HS_PLATFORM_WSL=n
export HS_PLATFORM_VM=n

########################################################
########################################################
#####                                              #####
#####    Path Setting Zone                         #####
#####                                              #####
########################################################
########################################################
# export HS_PATH_LIB=$
export HS_PATH_DOWNLOAD="${HOME}/downloads"
export HS_PATH_DOCUMENT="${HOME}/documents"
export HS_PATH_LAB="${HOME}/lab"
export HS_PATH_BUILD="${HOME}/build"
export HS_PATH_PROJ="${HOME}/projects"
export HS_PATH_WORK="${HS_PATH_LIB}/../work"
export HS_PATH_SLINK="${HOME}/slink"
export HS_PATH_LOG="${HOME}/log"

export HS_PATH_PYTHEN_ENV="${HOME}/env/pyenv"
# ECD
export HS_VAR_ECD_NAME_0="tmp"
export HS_PATH_ECD_0="/tmp"
export HS_VAR_ECD_NAME_1="@(h|home)"
export HS_PATH_ECD_1="${HOME}"

########################################################
########################################################
#####                                              #####
#####    FILE Setting Zone                         #####
#####                                              #####
########################################################
########################################################
export HS_FILE_CONFIG="${HOME}/.cache/hs_config"

########################################################
########################################################
#####                                              #####
#####    Config Vars                               #####
#####                                              #####
########################################################
########################################################
export HS_VAR_CURRENT_DIR="CURRENT_DIR"
export HS_VAR_CLIPBOARD="CLIPBOARD"

########################################################
########################################################
#####                                              #####
#####    Others Settings                           #####
#####                                              #####
########################################################
########################################################

# Terminal configs
export TERM="xterm-256color"
export LANG="en_US.utf8"

## home user bin to PATH ##
# export PATH=$PATH:$HOME/bin/

## Default Editor  ##
export EDITOR=vim
export VISUAL=vim

# source other files
# source-file /path/to/tmux.conf.common
