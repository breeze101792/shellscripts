# Functions
testnset -e -v HS_PROJ_LITE    -c y
# DEV
testnset -e -v HS_PROJ_ANDROID -c n
testnset -e -v HS_PROJ_FPGA    -c n
# Host
testnset -e -v HS_PROJ_ZERO    -c n
testnset -e -v HS_PROJ_WSL     -c n
# OS
testnset -e -v HS_PROJ_LINUX   -c y
testnset -e -v HS_PROJ_DARWIN  -c n
testnset -e -v HS_PROJ_NIX     -c n

## Sourcing
if [ "${HS_PROJ_ANDROID}" = "y" ]
then
    source ${HS_PATH_LIB}/projects/android/android.sh
fi

if [ "${HS_PROJ_LINUX}" = "y" ]
then
    source ${HS_PATH_LIB}/projects/linux/linux.sh
fi

if [ "${HS_PROJ_DARWIN}" = "y" ]
then
    source ${HS_PATH_LIB}/projects/darwin/darwin.sh
fi

if [ "${HS_PROJ_NIX}" = "y" ]
then
    source ${HS_PATH_LIB}/projects/nix/nix.sh
fi

if [ "${HS_PROJ_FPGA}" = "y" ]
then
    source ${HS_PATH_LIB}/projects/fpga/fpga.sh
fi

if [ "${HS_PROJ_ZERO}" = "y" ]
then
    source ${HS_PATH_LIB}/projects/zero/zero.sh
fi

if [ "${HS_PROJ_WSL}" = "y" ]
then
    source ${HS_PATH_LIB}/projects/wsl/wsl.sh
fi

if [ "${HS_PROJ_LITE}" = "y" ]
then
    source ${HS_PATH_LIB}/projects/lite/lite.sh
fi
