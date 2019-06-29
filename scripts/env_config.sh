########################################################
########################################################
#####                                              #####
#####    For HS Env Vars Zone                      #####
#####                                              #####
########################################################
########################################################
# This file is for env setup
# Put var, function & alias will be needed before sourc base_shell file

# Vars
export HS_ENV_CONFIG="${HOME}/.cache/hs_config"
export HS_ENV_IDE_PATH="${HOME}/projects"
export HS_ENV_TFTP_PATH="${HOME}/tftp"
export HS_ENV_WORK_SCRIPTS="${HS_LIB_PATH}/../work_script/work.sh"
# enable HS System
export HS_ENV_ENABLE=true

# Terminal configs
export TERM="xterm-256color"

########################################################
########################################################
#####                                              #####
#####    For HS Config Zone                        #####
#####                                              #####
########################################################
########################################################
export HS_CONFIG_I3_PATCH=y
