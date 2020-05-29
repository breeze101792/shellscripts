#!/bin/bash
###############################################
###############################################
####    Build Configs
###############################################
###############################################
export BUILD_ROOT_PATH="$(pwd)"
export BUILD_JOBS="12"

###############################################
###############################################
####    Configs
###############################################
###############################################
export CONFIG_DOWNLOAD_THREAD=32
export CONFIG_DOWNLOAD_DEPTH=10

###############################################
###############################################
####    Android Config
###############################################
###############################################
export ANDROID_ROOT_PATH="${BUILD_ROOT_PATH}/aosp"
export ANDROID_MANIFEST="https://android.googlesource.com/platform/manifest"
export ANDROID_BRANCH="android-10.0.0_r32"
export ANDROID_TARGET="aosp_crosshatch-userdebug"

###############################################
###############################################
####    Patch Functions
###############################################
###############################################
function print_title()
{
    echo "###############################################"
    echo "###############################################"
    echo "####    $@"
    echo "###############################################"
    echo "###############################################"
}
function error_check()
{
    return 0
}

###############################################
###############################################
####    Functions
###############################################
###############################################
function fDownload()
{
    print_title "${FUNCNAME[0]}"
    local init_args=()
    local sync_args=()
    init_args+=("--depth=${CONFIG_DOWNLOAD_DEPTH}")
    sync_args+=("")
    cd ${BUILD_ROOT_PATH}
    if [ ! -d "${ANDROID_ROOT_PATH}" ]
    then
        mkdir ${ANDROID_ROOT_PATH}
        pushd ${ANDROID_ROOT_PATH}
        {
            repo init -u ${ANDROID_MANIFEST} -b ${ANDROID_BRANCH} ${init_args[@]}
            error_check ${FUNCNAME[0]} ${LINENO}

            repo sync -j ${CONFIG_DOWNLOAD_THREAD} ${sync_args[@]}
            error_check ${FUNCNAME[0]} ${LINENO}
        }
        popd
    else
        echo "File already exist!!!"
        echo "Skip download."
    fi
    return 0
}

function fBuild()
{
    print_title "${FUNCNAME[0]}"
    cd ${ANDROID_ROOT_PATH}

    source ${ANDROID_ROOT_PATH}/build/envsetup.sh
    error_check ${FUNCNAME[0]} ${LINENO}

    lunch ${ANDROID_TARGET}
    error_check ${FUNCNAME[0]} ${LINENO}

    m
    error_check ${FUNCNAME[0]} ${LINENO}
    return 0
}

function fHelp()
{
    printf "Android Build Script\n"
    printf "[Options]\n"
    printf "    %s\t %s\n" "-b|--build" "build android"
    printf "    %s\t %s\n" "-h|--help"  "print help info"
    return 0
}

function fMain()
{
    local flag_build=n
    local flag_download=n
    while [[ ${#} > 0 ]]
    do
        case ${@} in
            -d|--download)
                flag_download=y
                ;;
            -b|--build)
                flag_build=y
                ;;
            -h|--help)
                fHelp
                exit 0
                ;;
            *)
                echo "Unknown Args"
                exit 1
                ;;
        esac
        shift 1
    done

    if [ "${flag_download}" = "y" ]
    then
        fDownload
    fi

    if [ "${flag_build}" = "y" ]
    then
        fBuild
    fi
}
fMain $@
