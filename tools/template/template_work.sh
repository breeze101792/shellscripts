#!/bin/bash


################################################################################
##
##    Env
##
################################################################################
hs_print Work Script


# scripts env
testnset -e -v HS_WORK_TOOLS -c "${HS_PATH_WORK}/tools"
testnset -e -v HS_WORK_SCRIPT -c "${HS_PATH_WORK}/scripts"

testnset -e -v HS_WORK_ZERO -c "zero.eth"

################################################################################
##
##    Alias
##
################################################################################

################################################################################
##
##    Tools
##
################################################################################

################################################################################
##
##    Customize Function
##
################################################################################

################################################################################
##
##    Hosts Settings
##
################################################################################
case $(hostname) in
    "zero"|${HS_WORK_ZERO})
        if -f "${HS_PATH_WORK}/hosts/zero.sh"
        then
            source ${HS_PATH_WORK}/hosts/zero.sh
        else
            echo "zero.sh not found."
        fi
        ;;
    "*")
        if -f "${HS_PATH_WORK}/hosts/$(hostname)"
        then
            source "${HS_PATH_WORK}/hosts/$(hostname)"
        fi
        ;;
esac

# source hosts
if -f "${HS_PATH_WORK}/hosts/$(hostname)"
then
    source ${HS_PATH_WORK}/wlab.sh
fi

# source tools
if -f "${HS_WORK_TOOLS}"
then
    epath ${HS_WORK_TOOLS}
fi

# source scripts
for each_scripts in ${HS_WORK_SCRIPT}/*.sh;
do
    source ${each_scripts};
done
