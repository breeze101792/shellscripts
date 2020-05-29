#!/bin/bash
## Profile config
if [ -z "${CONFIG_HOST_NAME}" ]
then
    export CONFIG_HOST_NAME="Linux"
fi
if [ -z "${CONFIG_BIOS_MODE}" ]
then
    export CONFIG_BIOS_MODE="bios"
fi
if [ -z "${CONFIG_GRAPHIC_GPU}" ]
then
    export CONFIG_GRAPHIC_GPU="qxl"
fi
if [ -z "${CONFIG_CPU_NUM}" ]
then
    export CONFIG_CPU_NUM=4
fi
if [ -z "${CONFIG_MEM_SIZE}" ]
then
    export CONFIG_MEM_SIZE=4G
fi
if [ -z "${CONFIG_NET_SSH}" ]
then
    export CONFIG_NET_SSH=4000
fi
if [ -z "${CONFIG_AUDIO}" ]
then
    export CONFIG_AUDIO="none"
fi
## Qemu Configs
QEMU_EXC="qemu-system-x86_64"
QEMU_BIOS=("")
QEMU_GRAPHIC=("")
QEMU_CPU=("-enable-kvm" "-cpu host")
QEMU_MEMORY=("")
QEMU_AUDIO=("")
QEMU_DRIVE=("")
QEMU_USB=("-device nec-usb-xhci,id=xhci")
QEMU_USB+=("-device usb-tablet")
QEMU_NET=("")
# QEMU_NET+=("-netdev tap,id=mynet0")
QEMU_OTHER=("")
## Golbal Var
G_MONITOR_TYPE="spice"
G_MONITOR_SPICE_PORT=5900
G_CONFIG_FILE="./config.sh"
G_USB_COUNT=0
G_DRIVE_COUNT=2
## Functions
function fHelp()
{
            
    printf "qemu help\n"
    printf "    %s %s\n" "-b|--bios" "Options: bios, uefi"
    printf "    %s %s\n" "-q|--graphic" "Options: qxl, std, circus, virtio, vmware, spice, curses, none"
    printf "    %s %s\n" "-a|--audio" "Options: all, hda, none"
    printf "    %s %s\n" "-u|--usb" "Options: vendorID:productID ex.1d6b:0003"
    printf "    %s %s\n" "-c|--cdrom" "Options: /path/to/your/file"
    printf "    %s %s\n" "-d|--disk" "Options: /path/to/your/file"
    printf "    %s %s\n" "--create-disk" "Options: --create-disk disk_name disk_size(M,G)"
    printf "    %s %s\n" "-pd|--physical-disk" "Options: /path/to/your/file"
    printf "    %s %s\n" "-o|--other" "Options: Other options"
    printf "    %s %s\n" "-s|--setting" "Options: "
    printf "    %s\n" "Settings config:
    CONFIG_HOST_NAME='Linux'
    CONFIG_BIOS_MODE='bios'
    CONFIG_GRAPHIC_GPU='spice'
    CONFIG_CPU_NUM=12
    CONFIG_MEM_SIZE=16G
    CONFIG_NET_SSH=4096"
    printf "    %s %s\n" "-h|--help" "Options: "
}
function fEnvInit()
{
    QEMU_CPU+=("-smp cores=${CONFIG_CPU_NUM}")
    # QEMU_MEMORY=("-m 1G,slots=4,maxmem=${CONFIG_MEM_SIZE}")
    QEMU_MEMORY=("-m ${CONFIG_MEM_SIZE}")
}
function fAddUSB()
{
    local vendor_id=`echo $1 | cut -d':' -f1`
    local product_id=`echo $1 | cut -d':' -f2`
    QEMU_USB+=("-device usb-host,vendorid=0x${vendor_id},productid=0x${product_id},id=hostdev0,bus=xhci.$G_USB_COUNT")
}
function fCreateDisk()
{
    local disk_name=$1
    local disk_size=$2

    # qemu-img create -f qcow2 linux.img 8G
    qemu-img create -f qcow2 ${disk_name} ${disk_size}
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
    elif [ "${CONFIG_BIOS_MODE}" == "bios" ]
    then
        echo "Use Bios"
    fi
    # echo -e "Leave it empty to legacy bios"
}
function fConfigGraphic()
{
    case $CONFIG_GRAPHIC_GPU in
        qxl)
            QEMU_GRAPHIC+=("-vga qxl")
            G_MONITOR_TYPE="spice"
            ;;
        std)
            QEMU_GRAPHIC+=("-vga std")
            G_MONITOR_TYPE="qemu"
            ;;
        circus)
            QEMU_GRAPHIC+=("-vga circus")
            G_MONITOR_TYPE="qemu"
            ;;
        virtio)
            QEMU_GRAPHIC+=("-vga virtio")
            G_MONITOR_TYPE="sdl"
            ;;
        vmware)
            QEMU_GRAPHIC+=("-vga vmware")
            G_MONITOR_TYPE="qemu"
            ;;
        spice)
            QEMU_GRAPHIC+=("-vga qxl")
            G_MONITOR_TYPE="spice"
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
    elif [ "${G_MONITOR_TYPE}" == "sdl" ]
    then
        QEMU_GRAPHIC+=("-display sdl,gl=on")
    elif [ "${G_MONITOR_TYPE}" == "gtk" ]
    then
        # QEMU_GRAPHIC+=("-display sdl,gl=on")
        QEMU_GRAPHIC+=("-display gtk,gl=on")
    fi
}
function fConfigAudio()
{
    case ${CONFIG_AUDIO} in
        all)
            QEMU_AUDIO+=("-soundhw all")
            ;;
        hda)
            QEMU_AUDIO+=("-soundhw hda")
            ;;
        none)
            # None audio will be added
            # QEMU_AUDIO+=("")
            ;;
        *)
            echo "Error Audio Settings"
            echo "Fallback to all"
            QEMU_AUDIO+=("-soundhw all")
            ;;
    esac
}
function fConfigNet()
{
    # QEMU_NET+=("-netdev user,id=net0,hostfwd=tcp::${CONFIG_NET_SSH}-:22")
    QEMU_NET+=("-netdev user,id=net0,net=192.168.76.0/24,dhcpstart=192.168.76.9,hostfwd=tcp::${CONFIG_NET_SSH}-:22")
    -netdev user,id=mynet0,net=192.168.76.0/24,dhcpstart=192.168.76.9
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
    local exec_str="$QEMU_EXC ${QEMU_BIOS[@]} ${QEMU_GRAPHIC[@]} ${QEMU_CPU[@]} ${QEMU_MEMORY[@]} ${QEMU_AUDIO[@]} ${QEMU_NET[@]} ${QEMU_DRIVE[@]} ${QEMU_USB[@]} ${QEMU_OTHER[@]} $@"
    echo -e "\"${exec_str}\"\n"
    fRunSpice &
    exec ${exec_str}
}
function main()
{
    local G_DRIVE_COUNT=2

    # source galobal settings
    if [ "$1" == "-s" ]
    then
        G_CONFIG_FILE=$2
        shift 2
    fi
    if [ -f "${G_CONFIG_FILE}" ]
    then
        source $G_CONFIG_FILE
    fi

    while [[ $# != 0 ]]
    do
        case $1 in
            --create-disk)
                fCreateDisk $2 $3
                shift 2
                return 0
                ;;
            -u|--usb)
                fAddUSB $2
                shift 1
                ;;
            -b|--bios)
                CONFIG_BIOS_MODE=$2
                shift 1
                ;;
            -c|--cdrom)
                QEMU_DRIVE+=("-drive file=${2},index=1,media=cdrom,if=virtio")
                shift 1
                ;;
            -d|--disk)
                # QEMU_DRIVE+=("-drive file=${2},index=${G_DRIVE_COUNT},media=disk,cache=none,if=virtio,format=qcow2")
                QEMU_DRIVE+=("-drive file=${2},index=${G_DRIVE_COUNT},media=disk,cache=writeback,if=virtio,format=qcow2")
                G_DRIVE_COUNT=$(($G_DRIVE_COUNT + 1))
                shift 1
                ;;
            -pd|--physical-disk)
                QEMU_DRIVE+=("-drive file=${2},index=${G_DRIVE_COUNT},media=disk,cache=writeback,if=virtio,format=raw")
                G_DRIVE_COUNT=$(($G_DRIVE_COUNT + 1))
                shift 1
                ;;
            -q|--graphic)
                CONFIG_GRAPHIC_GPU=$2
                shift 1
                ;;
            -a|--audio)
                CONFIG_AUDIO=$2
                shift 1
                ;;
            -s|--setting)
                echo -e "config file should be in the first paramater"
                exit 2
                ;;
            -o|--other)
                shift 1
                QEMU_OTHER+=($@)
                break
                ;;
            -h|--help)
                fHelp
                return 0
                ;;
            *)
                fHelp
                return 1
                ;;
        esac
        shift 1
    done

    echo Starting $CONFIG_HOST_NAME
    fConfigBIOS
    fConfigGraphic
    fConfigNet
    fConfigAudio
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
