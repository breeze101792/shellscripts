function mount_windisk()
{
    local var_disk=c
    local var_mount_path=/mnt/c
    sudo mount -t drvfs ${var_disk}: ${var_mount_path}
}
