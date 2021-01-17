#!/bin/bash
###################################################################################
###################################################################################
####    Build Configs
###################################################################################
###################################################################################
# export BUILD_JOBS="$(($(nproc) - 2))"

# if [ -z "${BUILD_LUNCH}" ]
# then
#     export BUILD_LUNCH=""
# fi
# if [ -z "${BUILD_COMPILE}" ]
# then
#     export BUILD_COMPILE=""
# fi

###################################################################################
###################################################################################
####    Configs
###################################################################################
###################################################################################
export CONFIG_DOWNLOAD_THREAD=32
export CONFIG_DOWNLOAD_DEPTH=10

###################################################################################
###################################################################################
####    Android Config
###################################################################################
###################################################################################
if [ -z "${ANDROID_DISTRO}" ]
then
    export ANDROID_DISTRO="aosp"
fi
if [ -z "${ANDROID_MANIFEST}" ]
then
    export ANDROID_MANIFEST="https://android.googlesource.com/platform/manifest"
fi
if [ -z "${ANDROID_BRANCH}" ]
then
    export ANDROID_BRANCH="android-10.0.0_r32"
fi
if [ -z "${ANDROID_TARGET}" ]
then
    export ANDROID_TARGET="aosp_crosshatch-userdebug"
fi
###################################################################################
###################################################################################
####    Path Config
###################################################################################
###################################################################################
export PATH_BUILD_ROOT="$(pwd)"
export PATH_ANDROID_ROOT="${PATH_BUILD_ROOT}/${ANDROID_DISTRO}"

###################################################################################
###################################################################################
####    Compile Config
###################################################################################
###################################################################################
# export OUT_DIR_COMMON_BASE=<path-to-your-out-directory>

###################################################################################
###################################################################################
####    Base Functions
###################################################################################
###################################################################################
function fPrint_title()
{
    echo "###################################################################################"
    echo "###################################################################################"
    echo "####    $@"
    echo "###################################################################################"
    echo "###################################################################################"
    echo ""
}
function fError_check()
{
    return 0
}
function fEnvSetup()
{
    fPrint_title "${FUNCNAME[0]}"
    if [ -d "${PATH_BUILD_ROOT}/bin" ]
    then
        mkdir -p ${PATH_BUILD_ROOT}/bin
    fi
    PATH="${PATH_BUILD_ROOT}/bin:${PATH}"

    if [ -f "${PATH_BUILD_ROOT}/bin/repo" ]
    then
        curl https://storage.googleapis.com/git-repo-downloads/repo > ${PATH_BUILD_ROOT}/bin/repo
        chmod a+rx ${PATH_BUILD_ROOT}/bin/repo
    fi

}
function fBuild_Info()
{
    echo "###################################################################################"
    echo "####    Build Info"
    echo "###################################################################################"
    echo "####    Manifest        :${ANDROID_MANIFEST}"
    echo "####    Branch          :${ANDROID_BRANCH}"
    echo "####    Target          :${ANDROID_TARGET}"
    echo "###################################################################################"
}
function fBuild_Summary()
{
    echo "###################################################################################"
    echo "####    Build Summary"
    echo "###################################################################################"
    echo "####    Manifest        :${ANDROID_MANIFEST}"
    echo "####    Branch          :${ANDROID_BRANCH}"
    echo "####    Target          :${ANDROID_TARGET}"
    echo "###################################################################################"
    echo "####    Out             :${PATH_ANDROID_ROOT}/out/target/product/${ANDROID_TARGET}"
    echo "###################################################################################"
}

###################################################################################
###################################################################################
####    Functions
###################################################################################
###################################################################################
function fDownload_Android()
{
    fPrint_title "${FUNCNAME[0]}"
    local init_args=()
    local sync_args=()
    init_args+=("--depth=${CONFIG_DOWNLOAD_DEPTH}")
    sync_args+=("--no-clone-bundle -f")
    cd ${PATH_BUILD_ROOT}
    if [ ! -d "${PATH_ANDROID_ROOT}/framework" ]
    then
        mkdir ${PATH_ANDROID_ROOT}
        cd ${PATH_ANDROID_ROOT}
        echo "repo init -u ${ANDROID_MANIFEST} -b ${ANDROID_BRANCH} ${init_args[@]}"
        repo init -u ${ANDROID_MANIFEST} -b ${ANDROID_BRANCH} ${init_args[@]}
        fError_check ${FUNCNAME[0]} ${LINENO}

        echo "repo sync -j ${CONFIG_DOWNLOAD_THREAD} ${sync_args[@]}"
        repo sync -j ${CONFIG_DOWNLOAD_THREAD} ${sync_args[@]}
        fError_check ${FUNCNAME[0]} ${LINENO}
    else
        echo "File already exist!!!"
        echo "Skip download."
    fi
    return 0
}
function fDownload_DeviceBlobs()
{
    fPrint_title "${FUNCNAME[0]}"
    if [ "${ANDROID_DISTRO}" = "lineage" ] && [ "${ANDROID_TARGET}" = "z3c" ]
    then
        local vendor_name="sony"
        cd ${PATH_ANDROID_ROOT}/vendor
        if [ ! -d "${PATH_ANDROID_ROOT}/vendor/${vendor_name}" ]
        then
            git clone https://github.com/TheMuppets/proprietary_vendor_sony.git -b ${ANDROID_BRANCH} ${vendor_name} --depth=${CONFIG_DOWNLOAD_DEPTH}
        fi
    elif [ "${ANDROID_DISTRO}" = "lineage" ] && [ "${ANDROID_TARGET}" = "flo" ]
    then
        local vendor_name="asus"
        cd ${PATH_ANDROID_ROOT}/vendor
        if [ ! -d "${PATH_ANDROID_ROOT}/vendor/${vendor_name}" ]
        then
            git clone https://github.com/TheMuppets/proprietary_vendor_asus.git -b ${ANDROID_BRANCH} ${vendor_name} --depth=${CONFIG_DOWNLOAD_DEPTH}
        fi
    fi
    return 0
}
function fDownload()
{
    fPrint_title "${FUNCNAME[0]}"
    fDownload_Android
    fDownload_DeviceBlobs
}

function fPatch()
{
    fPrint_title "${FUNCNAME[0]}"
}

function fBuild_lineage()
{
    fPrint_title "${FUNCNAME[0]}"
    cd ${PATH_ANDROID_ROOT}

    source ${PATH_ANDROID_ROOT}/build/envsetup.sh
    fError_check ${FUNCNAME[0]} ${LINENO}

    breakfast ${ANDROID_TARGET}
    fError_check ${FUNCNAME[0]} ${LINENO}

    brunch z3c
    fError_check ${FUNCNAME[0]} ${LINENO}
    return 0
}
function fBuild_aosp()
{
    fPrint_title "${FUNCNAME[0]}"
    cd ${PATH_ANDROID_ROOT}

    source ${PATH_ANDROID_ROOT}/build/envsetup.sh
    fError_check ${FUNCNAME[0]} ${LINENO}

    lunch ${ANDROID_TARGET}
    fError_check ${FUNCNAME[0]} ${LINENO}

    m
    fError_check ${FUNCNAME[0]} ${LINENO}
    return 0
}

function fBuild()
{
    fPrint_title "${FUNCNAME[0]}"
    cd ${PATH_ANDROID_ROOT}
    if [ "${ANDROID_DISTRO}" = "lineage" ]
    then
        fBuild_lineage
    else
        fBuild_aosp
    fi
    return 0
}

function fHelp()
{
    printf "Android Build Script\n"
    printf "[Options]\n"
    printf "    %s\t %s\n" "-a|--all|all" "Do All"
    printf "    %s\t %s\n" "-d|--download|down|download" "download android"
    printf "    %s\t %s\n" "-p|--patch|patch" "patch android"
    printf "    %s\t %s\n" "-b|--build|build" "build android"
    # printf "[Config]\n"
    # printf "    %s\t %s\n" "-h|--help"  "print help info"
    printf "[Others]\n"
    printf "    %s\t %s\n" "-h|--help"  "print help info"
    return 0
}

function fMain()
{
    local flag_build=n
    local flag_download=n
    local flag_patch=n
    while [[ ${#} > 0 ]]
    do
        case ${@} in
            -a|--all|all)
                flag_download=y
                flag_build=y
                ;;
            -p|--patch|patch)
                flag_patch=y
                ;;
            -d|--download|down|download)
                flag_download=y
                ;;
            -b|--build|build)
                flag_build=y
                ;;
            -h|--help)
                fHelp
                exit 0
                ;;
            *)
                echo "Unknown Args"
                fHelp
                exit 1
                ;;
        esac
        shift 1
    done
    fBuild_Info
    fEnvSetup

    if [ "${flag_download}" = "y" ]
    then
        fDownload
    fi

    if [ "${flag_patch}" = "y" ]
    then
        fPatch
    fi

    if [ "${flag_build}" = "y" ]
    then
        fBuild
    fi
    cd ${PATH_BUILD_ROOT}
    fBuild_Summary
}
fMain $@
