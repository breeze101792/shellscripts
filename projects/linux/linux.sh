hs_print "Source Linux(lx,ub) project"
function lx_ide()
{
    local arch=arm
    local target_dirs=("block" "certs" "crypto" "fs" "include" "init" "ipc" "kernel" "lib" "mm" "net" "security" "virt")

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -a|--arch)
                arch=$2
                shift 1
                ;;
            -h|--help)
                cli_helper -c "template" -cd "template function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "template [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-a|--arch" -d "Select arch(riscv, x86, arm, arm64, mips), defaut arm"
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                break
                ;;
        esac
        shift 1
    done
    target_dirs+=("arch/${arch}/")
    pvinit ${target_dirs}
}
function ub_ide()
{
    local arch=arm
    local target_dirs=("api" "cmd" "common" "disk" "drivers" "env" "fs" "include" "lib" "net" "post" "test" "tools")
    target_dirs+=("arch/${arch}/")
    pvinit ${target_dirs}
}
