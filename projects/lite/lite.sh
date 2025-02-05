#!/bin/bash
hs_print "Source Lite(lt) project"
function ltsync()
{
    local var_remote_host=""
    local var_remote_path=""

    local var_src_host=""
    local var_src_lite_path="${HS_PATH_LIB}/projects/lite/litetools"

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
        test -n "${var_src_host}" && tmp_file_sync_options+=("-sh ${var_src_host}")
        test -n "${var_remote_host}" && tmp_file_sync_options+=("-sh ${var_remote_host}")

        filesync -s ${var_src_lite_path} -d ${var_remote_path} ${tmp_file_sync_options[@]}
    fi

}
function ltbuild()
{
    local var_build_path="${HS_PATH_LIB}/projects/lite/litetools"
    local var_script_path="${var_build_path}/scripts"
    local var_configs_path="${var_build_path}/configs"
    local var_binary_path="${var_build_path}/bin"

    local var_script_list=()
    local var_config_list=()
    local var_binary_list=()

    ## Scripts files
    var_script_list+="${HS_PATH_LIB}/tools/hslite/hslite.sh"

    ## configs files
    var_config_list+="${HS_PATH_LIB}/configs/zellij/config_tmux.kdl"
    var_config_list+="${HS_PATH_LIB}/configs/tmux/tmux.conf"
    var_config_list+="${HS_PATH_IDE}/tools/vimlite.vim"

    ## binary files
    var_binary_list+="${HS_PATH_LIB}/tools/filemanager/filemanager.sh fm"

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -p|--path)
                var_build_path=$2
                shift 1
                ;;
            -s|--add-script)
                var_script_list+="$2"
                shift 1
                ;;
            -c|--add-config)
                var_script_list+="$2"
                shift 1
                ;;
            -b|--add-binary)
                var_script_list+="$2"
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
                cli_helper -o "-p|--path" -d "Specify build path root."
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
    for each_file in ${var_script_list[@]}; do
        if test -f ${each_file}; then
            echo "Sync script file: ${each_file}"
            cp ${each_file} ${var_script_path}/
        else
            echo "${each_file} not found."
        fi
    done

    # Configs
    for each_file in ${var_config_list[@]}; do
        if test -f ${each_file}; then
            echo "Sync config file: ${each_file}"
            cp ${each_file} ${var_configs_path}/
        else
            echo "${each_file} not found."
        fi
    done

    # Binary
    for each_cmd_file in ${var_binary_list[@]}; do
        local tmp_src_file_path="$(echo ${each_cmd_file} | cut -d ' ' -f 1 )"
        local tmp_target_file_path="${var_binary_path}/$(echo ${each_cmd_file} | cut -d ' ' -f 2 )"
        if test -f ${tmp_src_file_path}; then
            echo "Sync binary file: ${tmp_target_file_path}"
            cp ${tmp_src_file_path} ${tmp_target_file_path}
            chmod u+x ${tmp_target_file_path}
        else
            echo "${tmp_src_file_path} not found."
        fi
    done

    echo "Build finished on ${var_build_path}"
}

