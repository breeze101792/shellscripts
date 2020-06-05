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
export HS_ENV_VER=0.2.4
export HS_ENV_TITLE="DO IT NOW"
export HS_ENV_SILENCE=n
# enable HS System
export HS_ENV_ENABLE=true

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
# export HS_PATH_IDE_PATH="${HOME}/projects"

export HS_PATH_PYTHEN_ENV="${HOME}/env/pyenv"
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

## home user bin to PATH ##
# export PATH=$PATH:$HOME/bin/

## Default Editor  ##
export EDITOR=vim
export VISUAL=vim

# source other files
# source-file /path/to/tmux.conf.common
