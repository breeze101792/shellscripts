test -z  "${HS_PROJ_ANDROID}" && export HS_PROJ_ANDROID=y
test -z  "${HS_PROJ_LINUX}" && export HS_PROJ_LINUX=y
test -z  "${HS_PROJ_FPGA}" && export HS_PROJ_FPGA=y

if [ "${HS_PROJ_ANDROID}" = "y" ]
then
    source ${HS_PATH_LIB}/projects/android/android.sh
fi

if [ "${HS_PROJ_LINUX}" = "y" ]
then
    source ${HS_PATH_LIB}/projects/linux/linux.sh
fi

if [ "${HS_PROJ_FPGA}" = "y" ]
then
    source ${HS_PATH_LIB}/projects/fpga/fpga.sh
fi
