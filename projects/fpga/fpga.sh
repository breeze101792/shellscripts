function fpga_flash()
{
    local target_dev=/dev/$(lsblk -S |grep MBED |cut -d " " -f 1)
    local target_mount_path=/mnt/usb
    local target_file=$1

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
