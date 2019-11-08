#!/usr/bin/env bash
# shell options
# parse_git_branch()
# {
#     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
# }

# set_current_path()
# {
#     if [ -e "${HS_ENV_CONFIG}" ] && [ -f "${HS_ENV_CONFIG}" ]
#     then
#         echo `pwd` > ${HS_ENV_CONFIG}
#     else
#         echo "[Set Current path fail]"
#     fi
# }
# function check_cmd_status()
# {
#     RETVAL=$1
#     case $RETVAL in
#         1)
#             echo -e "-[\033[33;5;11mError\033[38;5;15m\033[00m]"
#             return $RETVAL
#             ;;
#         0)
#             return 0
#             ;;
#         *)
#             return $RETVAL
#             ;;
#     esac
# }
export PS1="[\[$(tput sgr0)\]\[\033[38;5;11m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;10m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\]]-[\d \t]\$(check_cmd_status \$?)\$(item_promote \$(parse_git_branch))\$(set_working_path -s)[\[$(tput sgr0)\]\[\033[38;5;6m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]]\n->\[$(tput sgr0)\]"

#shopt -s cdable_vars

if [ "${HS_CONFIG_CHANGE_DIR}" = "y" ]
then
    set_working_path -g
    # if [ -e ${HS_ENV_CONFIG} ] && [ -f "${HS_ENV_CONFIG}" ] && [ -d "$(cat ${HS_ENV_CONFIG})" ]
    # then
    #     cd "$(cat $HS_ENV_CONFIG)"
    # else
    #     echo "Goto Current path fail $(cat ${HS_ENV_CONFIG})"
    # fi
fi
