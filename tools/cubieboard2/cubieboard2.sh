export ROOT_PATH=$(realpath .)
# device settings
export TARGET_DEVICE=/dev/sdx
export TARGET_DEVICE_PARTITION=1
# Path settings
export IMAGE_PATH=${ROOT_PATH}/imgs
export TMP_MOUNT_POINT=${ROOT_PATH}/mnt

# if [ "${HS_ENV_ENABLE}" != "true" ]
# then
#     alias printt="echo $@"
# fi
alias printt="echo $@"

# functions
function fPrepareDisk()
{
    printt ${FUNCNAME[0]}
    echo "This command should be use with caution."
    exit 1
    cd ${ROOT_PATH}
    # dd if=/dev/zero of=/dev/sdX bs=1M count=8
    sudo umount ${TARGET_DEVICE}*
    echo -e "o\nn\np\n1\n\nw" | sudo fdisk ${TARGET_DEVICE}
    # echo -e "o\nn\np\n1\n\n\nw" | echo
    sudo mkfs.ext4 ${TARGET_DEVICE}${TARGET_DEVICE_PARTITION}
    sudo mount ${TARGET_DEVICE}${TARGET_DEVICE_PARTITION} ${TMP_MOUNT_POINT}
}
function fDownloadAll()
{
    printt ${FUNCNAME[0]}
    cd ${ROOT_PATH}
    if [ ! -d ${IMAGE_PATH} ]
    then
        mkdir ${IMAGE_PATH}
    fi
    pushd ${IMAGE_PATH}
    {
        if [ ! -f "${IMAGE_PATH}/ArchLinuxARM-armv7-latest.tar.gz" ]
        then
            wget http://os.archlinuxarm.org/os/ArchLinuxARM-armv7-latest.tar.gz
        fi
        if [ ! -f "${IMAGE_PATH}/u-boot-sunxi-with-spl.bin" ]
        then
            wget http://os.archlinuxarm.org/os/sunxi/boot/cubieboard2/u-boot-sunxi-with-spl.bin
        fi
        if [ ! -f "${IMAGE_PATH}/boot.scr" ]
        then
            wget http://os.archlinuxarm.org/os/sunxi/boot/cubieboard2/boot.scr
        fi
    }
    popd
}
function fInstallSystem()
{
    printt ${FUNCNAME[0]}
    cd ${ROOT_PATH}
    sudo bsdtar -xpf ${IMAGE_PATH}/ArchLinuxARM-armv7-latest.tar.gz -C ${TMP_MOUNT_POINT}/
    sync
}
function fInstallBootloader()
{
    printt ${FUNCNAME[0]}
    cd ${ROOT_PATH}
    sudo dd if=${IMAGE_PATH}/u-boot-sunxi-with-spl.bin of=${TARGET_DEVICE} bs=1024 seek=8
    sudo cp ${IMAGE_PATH}/boot.scr ${TMP_MOUNT_POINT}/boot/boot.scr
    sync
}
function fPostInstall()
{
    printt ${FUNCNAME[0]}
    sudo umount mnt
    sync
}
function fSystemInit()
{
    printt ${FUNCNAME[0]}
    # for pacman init
    pacman-key --init
    pacman-key --populate archlinuxarm
    pacman -Syu uboot-cubieboard2
}

function fmain()
{
    printt ${FUNCNAME[0]}
    local flag_prepare=""
    local flag_system=""
    local flag_bootload=""
    while true
    do
        case $1 in
            -a|--all)
                flag_prepare="y"
                flag_system="y"
                flag_bootload="y"
                ;;
            -s|--system)
                flag_system="y"
                ;;
            -b|--bootloader)
                flag_bootload="y"
                ;;
            -d)
                TARGET_DEVICE=$2
                shift 1
                ;;
            *)
                break
                ;;
        esac
        shift 1
    done
    echo "Install in Target Disk:$TARGET_DEVICE"
    fDownloadAll
    if [ "${flag_prepare}" = "y"]
    then
        fPrepareDisk
    fi
    if [ "${flag_system}" = "y"]
    then
        fInstallSystem
    fi
    if [ "${flag_bootload}" = "y"]
    then
        fInstallBootloader
    fi
    fPostInstall
}

fmain $@
