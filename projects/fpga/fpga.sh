function fpga_flash()
{
    local target_dev=/dev/$(lsblk -S |grep MBED |cut -d " " -f 1)
    local target_mount_path=/mnt/usb
    local target_file=""
    local var_tmp_file=$(ls | grep bin)
    if [ "$#" = 0 ] && [ -f ${var_tmp_file} ]
    then
        target_file=${var_tmp_file}
    elif [ "$#" = 1 ] && [ -f ${1} ]
    then
        target_file=${1}
    else
        echo "Target file not found."
        return 1
    fi

    echo "Flash ${target_file} to ${target_dev}"
    sudo umount ${target_mount_path}
    sudo mount ${target_dev} ${target_mount_path}
    sudo cp ${target_file} ${target_mount_path}
    sync
    echo "Flash finished."
}
function fpga_debug()
{
    sdebug -d /dev/ttyACM0
}
