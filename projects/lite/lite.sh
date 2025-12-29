#!/bin/bash
hs_print "Source Lite(lt) project"
function ltactivate()
{
    local var_shell='bash'

    local env_term=xterm-256color
    local env_home="${HOME}"
    local env_vars="export TERM=${env_term} && export HOME=${env_home}"
    local pureshell_rc=~/.purebashrc
    local excute_cmd="echo 'Enter HSLite'"

    # if [ "${SHELL##*/}" = "zsh" ]
    # then
    #     var_shell='zsh'
    # elif [ "${SHELL##*/}" = "bash" ]
    # then
    #     var_shell='bash'
    # fi

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -s|--shell)
                var_shell="$2"
                shift 1
                ;;
            -d|--debug)
                excute_cmd="${excute_cmd} && export HSL_FLAG_DEBUG=true"
                ;;
            -h|--help)
                cli_helper -c "ltactivate" -cd "ltactivate function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "ltactivate [Options] [Other commands]"
                cli_helper -t "Options"
                # cli_helper -o "-s|--shell" -d "Specify shell, zsh/bash"
                cli_helper -o "-d|--debug" -d "Enable debug mode "
                cli_helper -o "-v|--verbose" -d "Verbose print "
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                # excute_cmd="$*"
                # break
                echo "Unknown options"
                return
                ;;
        esac
        shift 1
    done

    local var_src_lite_path="${HS_PATH_LIB}/projects/lite/hslite/"
    local var_src_init_path="${var_src_lite_path}/scripts/hslite.sh"
    excute_cmd="${excute_cmd} && export SHELL=${var_shell}"
    excute_cmd="${excute_cmd} && export HSL_ROOT_PATH=${var_src_lite_path}"

    if [ "${var_shell}" = "bash" ]
    then
        excute_cmd="${excute_cmd} && bash --init-file ${var_src_init_path}"

        env -i bash -c "export TERM=${env_term} && export HOME=${env_home} && bash --norc -c \"${excute_cmd}\""
    elif [ "${var_shell}" = "zsh" ]
    then
        excute_cmd="${excute_cmd} && source ${var_src_init_path} && zsh --no-rcs"
        env -i zsh -c "export TERM=${env_term} && export HOME=${env_home} && zsh --no-rcs -c \"${excute_cmd}\""
    fi
}
function ltsync()
{
    local var_remote_host=""
    local var_remote_path=""

    local var_src_host=""
    local var_src_lite_path="${HS_PATH_LIB}/projects/lite/hslite"

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -t|--target-host)
                var_remote_host=$2
                shift 1
                ;;
            -p|--target-path)
                var_remote_path=$2
                shift 1
                ;;
            -sh|--src-host)
                var_src_host=$2
                shift 1
                ;;
            -sp|--src-path)
                var_src_lite_path=$2
                shift 1
                ;;
            -b|--build)
                ltbuild
                ;;
            -h|--help)
                cli_helper -c "ltsync" -cd "ltsync function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "ltsync [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-t|--target-host" -d "Specify target host."
                cli_helper -o "-p|--target-path" -d "Specify target tools path."
                cli_helper -o "-sh|--src-host" -d "Specify src host."
                cli_helper -o "-sp|--src-path" -d "Specify src tools path."
                cli_helper -o "-b|--build" -d "Build lite scripts."
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                echo "Wrong args, $@"
                return -1
                ;;
        esac
        shift 1
    done
    if test -n "${var_remote_host}" && test -z "${var_remote_path}"; then
        var_remote_path="~/tools"
    fi

    echo "## INFO"
    echo "Target   :${var_remote_host}:${var_remote_path}"
    echo "Source   :${var_src_host}:${var_src_lite_path}"

    echo "## Sync"
    if test -n "${var_src_lite_path}" && test -n "${var_remote_path}"; then
        local tmp_file_sync_options=()
        test -n "${var_src_host}" && tmp_file_sync_options+=("-sh" "${var_src_host}")
        test -n "${var_remote_host}" && tmp_file_sync_options+=("-dh" "${var_remote_host}")

        echo filesync -s ${var_src_lite_path} -d ${var_remote_path} ${tmp_file_sync_options[@]}
        filesync -s ${var_src_lite_path} -d ${var_remote_path} ${tmp_file_sync_options[@]}
    fi

}
function ltbuild()
{
    local def_lite_name="hslite"
    local var_build_path="${HS_PATH_LIB}/../${def_lite_name}"
    local var_script_path="${var_build_path}/scripts"
    local var_configs_path="${var_build_path}/configs"
    local var_binary_path="${var_build_path}/bin"
    local var_init_script=""

    local var_script_list=()
    local var_config_list=()
    local var_binary_list=()

    ## Check path
    if test -d ~/tools/${def_lite_name}; then
        var_build_path="$(realpath ~/tools/${def_lite_name})"
        echo "Found exist path. Default set path to ${var_build_path}"
    fi

    ## Scripts files
    var_script_list+=("${HS_PATH_LIB}/tools/hslite/hslite.sh")

    ## configs files
    var_config_list+=("${HS_PATH_LIB}/configs/zellij/config_legacy.kdl")
    var_config_list+=("${HS_PATH_LIB}/configs/tmux/tmux.conf")
    var_config_list+=("${HS_PATH_IDE}/tools/vimlite.vim")

    ## binary files
    var_binary_list+=("${HS_PATH_LIB}/tools/filemanager/filemanager.sh")

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -p|--path)
                if test -d $2; then
                    var_build_path="$(realpath $2/${def_lite_name})"
                else
                    echo "Path not found. ${2}"
                    return -1
                fi
                shift 1
                ;;
            -i|--init-script)
                var_init_script="$2"
                shift 1
                ;;
            -s|--add-script)
                var_script_list+=("$2")
                shift 1
                ;;
            -c|--add-config)
                var_config_list+=("$2")
                shift 1
                ;;
            -b|--add-binary)
                var_binary_list+=("$2")
                shift 1
                ;;
            -v|--verbose)
                flag_verbose="y"
                shift 1
                ;;
            -h|--help)
                cli_helper -c "ltbuild" -cd "ltbuild function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "ltbuild [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-p|--path" -d "Specify build path root.(default will store path on ${var_build_path})"
                cli_helper -o "-i|--init-script" -d "add init script"
                cli_helper -o "-s|--add-script" -d "add extra script"
                cli_helper -o "-c|--add-config" -d "add extra config"
                cli_helper -o "-b|--add-binary" -d "add extra binary"
                # cli_helper -o "-v|--verbose" -d "Verbose print "
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                echo "Wrong args, $@"
                return -1
                ;;
        esac
        shift 1
    done

    # Update path
    var_script_path="${var_build_path}/scripts"
    var_configs_path="${var_build_path}/configs"
    var_binary_path="${var_build_path}/bin"

    ## Setup Dirs.
    test -d ${var_build_path} && rm -r ${var_build_path}
    mkdir ${var_build_path}
    if ! test -d ${var_build_path}; then
        echo "Can't create build path: ${var_build_path}."
        return -1
    fi

    mkdir ${var_script_path}
    mkdir ${var_configs_path}
    mkdir ${var_binary_path}

    ## Sync files Dirs.
    # Scripts
    for each_file in "${var_script_list[@]}"; do
        if test -f ${each_file}; then
            echo "Sync script file: ${each_file}"
            cp -f ${each_file} ${var_script_path}/
        else
            echo "${each_file} not found."
        fi
    done

    # Configs
    for each_file in "${var_config_list[@]}"; do
        if test -f ${each_file}; then
            echo "Sync config file: ${each_file}"
            cp -f ${each_file} ${var_configs_path}/
        else
            echo "${each_file} not found."
        fi
    done

    # Binary
    for each_file in "${var_binary_list[@]}"; do
        echo "Binary: ${each_file}"
        if test -f "${each_file}"; then
            local tmp_bin_file=$(basename ${each_file})
            echo "Sync binary file: ${each_file}"
            cp -f ${each_file} ${var_binary_path}/${tmp_bin_file%.sh}
        elif test -d "${each_file}"; then
            echo "Sync binary folder: ${each_file}"
            cp -f ${each_file}/* ${var_binary_path}/
        else
            echo "${each_file} not found."
        fi
    done

    # Compose init script
    if test -f "${var_init_script}"; then
        local tmp_init_file=$(basename "${var_init_script}")
        # check if file exist. we need to regenerate.
        test -f "${var_build_path}/${tmp_init_file}" && rm "${var_build_path}/${tmp_init_file}"
        # echo "Check file:${var_build_path}/${tmp_init_file}"

        echo "# Original init script from ${var_init_script}" > ${var_build_path}/${tmp_init_file}
        echo "############################################" >> ${var_build_path}/${tmp_init_file}
        cat ${var_init_script} >> ${var_build_path}/${tmp_init_file}
    fi

    echo "Build finished on ${var_build_path}"
}

