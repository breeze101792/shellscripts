hs_print "Source Linux(lx) project"
function lx_ide()
{
    local arch=arm64
    local target_dirs=("block" "certs" "crypto" "fs" "include" "init" "ipc" "kernel" "lib" "mm" "net" "security" "virt")
    target_dirs+=("arch/${arch}/")
    pvinit ${target_dirs}
}
