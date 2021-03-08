export HS_PROJ_ANDROID=y
export HS_PROJ_LINUX=y

if [ "${HS_PROJ_ANDROID}" = "y" ]
then
    source ${HS_PATH_LIB}/projects/android/android.sh
fi

if [ "${HS_PROJ_LINUX}" = "y" ]
then
    source ${HS_PATH_LIB}/projects/linux/linux.sh
fi
