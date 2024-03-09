testnset -e -v HS_PROJ_ANDROID -c y
testnset -e -v HS_PROJ_LINUX   -c y
testnset -e -v HS_PROJ_FPGA    -c y
testnset -e -v HS_PROJ_ZERO    -c y

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

if [ "${HS_PROJ_ZERO}" = "y" ]
then
    source ${HS_PATH_LIB}/projects/zero/zero.sh
fi
