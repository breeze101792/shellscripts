hs_print "Source Linux(lx,ub) project"
alias lcd="lxcd "
function lxide()
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
                cli_helper -c "lxide" -cd "lxide function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "lxide [Options] [Value]"
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
    pvinit ${target_dirs[@]}
}
function lxcd()
{
    echo "Linux Enhanced cd"
    local cpath=$(pwd)
    local target_path=${cpath}

    local lx_root_path=""

    ############################################################
    ####    Path Finder
    ############################################################
    if froot -m ".git" > /dev/null || froot -m "kernel" > /dev/null && froot -m "arch" > /dev/null  && froot -m "mm" > /dev/null
    then
        lx_root_path=$(pwd)
        echo "Locate Linux root: $lx_root_path"
    else
        cd ${cpath}
        echo "Linux not recognize"
        return 1
    fi

    # [ -z ${lx_fs_path} ] && lx_fs_path=${lx_root_path}/fs

    target_path=${lx_root_path}

    ############################################################
    ####    Checking Path
    ############################################################
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -i|--include|include|inc)
                local tmp_path=$(echo ${lx_root_path}/include)
                if [ -n "${2}" ] && [ -d "${tmp_path}/${2}" ]
                then
                    target_path=${tmp_path}/${2}
                elif [ -n "${2}" ] && [ -d "$(realpath ${tmp_path}/${2}*)" ]
                then
                    target_path=$(realpath ${tmp_path}/${2}*)
                else
                    target_path=${tmp_path}
                    break
                fi
                if [ -n "${2}" ]
                then
                    shift 1
                fi
                ;;
            -a|--arch|arch)
                local tmp_path=$(echo ${lx_root_path}/arch)
                if [ -n "${2}" ] && [ -d "${tmp_path}/${2}" ]
                then
                    target_path=${tmp_path}/${2}
                elif [ -n "${2}" ] && [ -d "$(realpath ${tmp_path}/${2}*)" ]
                then
                    target_path=$(realpath ${tmp_path}/${2}*)
                else
                    target_path=${tmp_path}
                    break
                fi
                if [ -n "${2}" ]
                then
                    shift 1
                fi
                ;;
            -d|--driver|driver|drv)
                local tmp_path=$(echo ${lx_root_path}/Documentation)
                if [ -n "${2}" ] && [ -d "${tmp_path}/${2}" ]
                then
                    target_path=${tmp_path}/${2}
                elif [ -n "${2}" ] && [ -d "$(realpath ${tmp_path}/${2}*)" ]
                then
                    target_path=$(realpath ${tmp_path}/${2}*)
                else
                    target_path=${tmp_path}
                    break
                fi
                if [ -n "${2}" ]
                then
                    shift 1
                fi
                ;;
            --document|doc)
                local tmp_path=$(echo ${lx_root_path}/drivers)
                if [ -n "${2}" ] && [ -d "${tmp_path}/${2}" ]
                then
                    target_path=${tmp_path}/${2}
                elif [ -n "${2}" ] && [ -d "$(realpath ${tmp_path}/${2}*)" ]
                then
                    target_path=$(realpath ${tmp_path}/${2}*)
                else
                    target_path=${tmp_path}
                    break
                fi
                if [ -n "${2}" ]
                then
                    shift 1
                fi
                ;;
            -h|--help)
                echo "lx_cd|lcd"
                printlc -cp false -d "->" "-i|--include|include|inc" "cd to target path"
                printlc -cp false -d "->" "-a|--arch|arch" "cd to target path"
                printlc -cp false -d "->" "-d|--driver|driver|drv" "cd to target path"
                printlc -cp false -d "->" "--document|doc" "cd to target path"
                return 0
                ;;

            *)
                echo test
                if [ -d "${lx_root_path}/${1}" ]
                then
                    target_path=${lx_root_path}/${1}
                else
                    target_path=${lx_root_path}/${1}*
                fi
                ;;
        esac
        shift 1
    done
    echo ${target_path}

    target_path=$(file ${target_path} | cut -d ":" -f 1)

    if [ -d "${target_path}" ]
    then
        echo goto ${target_path} | mark -s green ${target_path}
        # eval "cd ${target_path}"
        cd ${target_path}
        ls
        return 0
    else
        echo "Can't find ${target_path}"
        cd ${cpath}
        return 1
    fi
}
function ubide()
{
    local arch=arm
    local target_dirs=("api" "cmd" "common" "disk" "drivers" "env" "fs" "include" "lib" "net" "post" "test" "tools")
    target_dirs+=("arch/${arch}/")
    pvinit ${target_dirs}
}
