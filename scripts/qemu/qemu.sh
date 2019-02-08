#!/bin/bash
## Configs
# source config.sh
QEMU_EXC="qemu-system-x86_64"
QEMU_BIOS=("")
QEMU_GRAPHIC=("")
QEMU_CPU=("-enable-kvm" "-cpu host")
QEMU_MEMORY=("")

QEMU_DRIVE=("")
QEMU_USB=("-device nec-usb-xhci,id=xhci")
QEMU_USB+=("-device usb-tablet")
QEMU_NET=("")
# QEMU_NET+=("-netdev tap,id=mynet0")
## Golbal Var
G_MONITOR_TYPE="spice"
G_MONITOR_SPICE_PORT=5900
G_CONFIG_FILE="./config.sh"
G_USB_COUNT=0
G_DRIVE_COUNT=2
## Functions
function fEnvInit()
{
    QEMU_CPU+=("-smp cores=${CONFIG_CPU_NUM}")
    QEMU_MEMORY=("-m 1G,slots=4,maxmem=${CONFIG_MEM_SIZE}")
}
function fAddUSB()
{
    local vendor_id=`echo $1 | cut -d':' -f1`
    local product_id=`echo $1 | cut -d':' -f2`
    QEMU_USB+=("-device usb-host,vendorid=0x${vendor_id},productid=0x${product_id},id=hostdev0,bus=xhci.$G_USB_COUNT")
}
## Config
function fConfigBIOS()
{
    if [ "${CONFIG_BIOS_MODE}" == "uefi" ]
    then
        if [ ! -f "./OVMF_VARS.fd" ]
        then
            cp /usr/share/ovmf/x64/OVMF_VARS.fd .
        fi
        QEMU_BIOS+=("-drive if=pflash,format=raw,file=./OVMF_VARS.fd")
        QEMU_BIOS=("-drive if=pflash,format=raw,readonly,file=/usr/share/ovmf/x64/OVMF_CODE.fd")
    fi
    # echo -e "Leave it empty to legacy bios"
}
function fConfigQraphic()
{
    local $CONFIG_GRAPHIC_GPU=$1
    case $CONFIG_GRAPHIC_GPU in
        qxl)
            QEMU_GRAPHIC+=("-vga qxl")
            ;;
        std)
            QEMU_GRAPHIC+=("-vga std")
            ;;
        circus)
            QEMU_GRAPHIC+=("-vga circus")
            ;;
        vmware)
            QEMU_GRAPHIC+=("-vga vmware")
            ;;
        spice)
            QEMU_GRAPHIC+=("-vga qxl")
            ;;
        curses)
            QEMU_GRAPHIC+=("-curses")
            QEMU_GRAPHIC+=("-serial mon:stdio")
            G_MONITOR_TYPE="qemu"
            ;;
        none)
            QEMU_GRAPHIC+=("-nographic")
            G_MONITOR_TYPE="qemu"
            ;;
        *)
            echo "Error Qraphic Settings"
            exit 1
            ;;
    esac
    if [ "${G_MONITOR_TYPE}" == "spice" ]
    then
        QEMU_GRAPHIC+=("-spice port=5900,addr=127.0.0.1,disable-ticketing")
    fi


}
function fConfigNet()
{
    QEMU_NET+=("-netdev user,id=net0,hostfwd=tcp::4096-:22")
    QEMU_NET+=("-device virtio-net-pci,romfile=/usr/share/qemu/efi-virtio.rom,netdev=net0")
}
function fRunSpice()
{
    sleep 1
    local exec_str="remote-viewer spice://127.0.0.1:${G_MONITOR_SPICE_PORT}"
    if [ "${G_MONITOR_TYPE}" == "spice" ]
    then
        exec ${exec_str}
    fi
}
function fRun()
{
    local exec_str="$QEMU_EXC ${QEMU_BIOS[@]} ${QEMU_GRAPHIC[@]} ${QEMU_CPU[@]} ${QEMU_MEMORY[@]} ${QEMU_NET[@]} ${QEMU_DRIVE[@]} ${QEMU_USB[@]} $@"
    echo -e "\"${exec_str}\"\n"
    fRunSpice &
    exec ${exec_str}
}
function main()
{
    echo Starting $CONFIG_HOST_NAME
    local G_DRIVE_COUNT=2

    # source galobal settings
    if [ "$1" == "-s" ]
    then
        G_CONFIG_FILE=$2
        shift 2
    fi
    source $G_CONFIG_FILE

    while true
    do
        case $1 in
            -u|--usb)
                fAddUSB $2
                shift 2
                ;;
            -b|--bios)
                CONFIG_BIOS_MODE=$2
                shift 2
                ;;
            -c|--cdrom)
                QEMU_DRIVE+=("-drive file=${2},index=1,media=cdrom,if=virtio")
                shift 2
                ;;
            -d|--disk)
                # QEMU_DRIVE+=("-drive file=${2},index=${G_DRIVE_COUNT},media=disk,cache=none,if=virtio,format=qcow2")
                QEMU_DRIVE+=("-drive file=${2},index=${G_DRIVE_COUNT},media=disk,cache=writeback,if=virtio,format=qcow2")
                G_DRIVE_COUNT=$(($G_DRIVE_COUNT + 1))
                shift 2
                ;;
            -q|--graphic)
                CONFIG_GRAPHIC_GPU=$2
                shift 2
                ;;
            -s|--setting)
                echo -e "config file should be in the first paramater"
                exit 2
                ;;
            -h|--help)
                echo Help function
                exit 0
                ;;
            *)
                break;
                ;;
        esac
    done

    echo Start Programs
    fConfigBIOS
    fConfigQraphic
    fConfigNet
    fEnvInit
    fRun $@
}
main $@
exit
# new
    -drive file=$cdrom,index=1,media=cdrom,if=virtio
    -virtfs local,path=/path/to/share,mount_tag=host0,security_model=passthrough,id=host0
# old
    -hda ubuntu.img\
    -drive file=ubuntu.img,index=2,media=disk,cache=none,if=virtio,format=raw\
    -netdev user,id=n1,ipv6=off -device e1000,netdev=n1,mac=52:54:98:76:54:32
    -device virtio-scsi-pci,id=scsi0 -drive file=/dev/sdc,if=none,format=raw,discard=unmap,aio=native,cache=none,id=someid -device scsi-hd,drive=someid,bus=scsi0.0\
    -net nic,vlan=0 -net user,vlan=0\
    -drive file=cdrom.img,mdeia=cdrom,index=2\
    -drive file=test.img,if=virtio\
    -device nec-usb-xhci,id=xhci\
    -device usb-tablet,bus=ehci.0\
    -device ich9-usb-ehci2,id=ehci,bus=pci.0,addr=0x4\
    -device usb-host,vendorid=0x0951,productid=0x1697,id=hostdev0,bus=xhci.0\
    -device nec-usb-xhci,id=xhci\
    -device usb-ehci,id=usb,bus=pci.0,addr=0x4\
    -device usb-host,vendorid=0x048d,productid=0x1327,id=hostdev0,bus=ehci.0\
    -hda windows.img\
note:
-usbdevice host:0ca6:0010
-soundhw all
