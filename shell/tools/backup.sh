

########################################################
#####    VIM                                      #####
########################################################
function pvupdate()
{
    local cpath=${PWD}
    local var_proj_folder="vimproj"
    local var_list_file="proj.files"

    local var_tags_file="tags"
    local var_cscope_file="cscope.db"
    local var_cctree_file="cctree.db"
    local var_tmp_folder="tmp_db_$(tstamp)"
    local flag_error_happen='y'

    local flag_system_include='n'

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -si|--system-include)
                flag_system_include='y'
                ;;
            -v|--verbose)
                flag_verbose="y"
                shift 1
                ;;
            -h|--help)
                cli_helper -c "pvupdate" -cd "pvupdate function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "pvupdate [Options] [Value]"
                cli_helper -t "Options"
                # cli_helper -o "-a|--append" -d "append file extension on search"
                # cli_helper -o "-v|--verbose" -d "Verbose print "
                cli_helper -o "-si|--system-include" -d "Add linux system include "
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
    var_cscope_cmd+=("-U")

    if [ "${flag_system_include}" = "n" ]
    then
        var_cscope_cmd+=("-k")
    fi

    if froot -m ${var_proj_folder} && test -f "${var_proj_folder}/${var_list_file}"
    then
        cd ${var_proj_folder}
        var_list_file=$(realpath "${var_list_file}")

        echo "Found ${var_list_file} in $(pwd)"
    elif froot -m ${var_proj_folder} && test -f "${var_proj_folder}/${var_list_file}"
    then
        var_list_file=$(realpath "${var_list_file}")

        echo "Found ${var_list_file} in $(pwd)"
    else
        echo "${var_list_file} not found."
        return 1
    fi

    # [ -f ${var_cscope_file} ] && rm ${var_cscope_file} 2> /dev/null
    # [ -f ${var_cctree_file} ] && rm ${var_cctree_file} 2> /dev/null
    # [ -f ${var_tags_file} ] && rm ${var_tags_file} 2> /dev/null
    [ -d ${var_tmp_folder} ] && rm -rf ${var_tmp_folder} 2> /dev/null

    mkdir -p ${var_tmp_folder}
    pushd ${var_tmp_folder}
    ########################################
    # Add c(uncompress) for fast read

    ## Ctags
    # ctags -L proj.files
    $(ctags -R --c++-kinds=+p --C-kinds=+p --fields=+iaS --extra=+q -L ${var_list_file} || echo 'catg run fail' && flag_error_happen='n' )&
    # ctags -R  --C-kinds=+p --fields=+aS --extra=+q
    # ctags -R -f ~/.vim/${var_tags_file}/c  --C-kinds=+p --fields=+aS --extra=+q

    ## Cscope
    # cscope -c -b -i ${var_list_file} -f ${var_cscope_file} || echo 'cscope run fail' && flag_error_happen='n'
    cscope -c -b -R -q ${var_cscope_cmd[@]} -i ${var_list_file} -f ${var_cscope_file} || echo 'cscope run fail' && flag_error_happen='n'

    wait
    # command -V ccglue && ccglue -S cscope.out -o ${var_cctree_file}
    command -V ccglue && ccglue -S ${var_cscope_file} -o ${var_cctree_file}
    # mv cscope.out ${var_cscope_file}
    ########################################
    popd
    if [ "${flag_error_happen}" = "n" ]
    then
        cp -rf ${var_tmp_folder}/${var_tags_file} .
        cp -rf ${var_tmp_folder}/*.db .
        cp -rf ${var_tmp_folder}/${var_cscope_file}* .
        echo "Tag generate successfully."
    else
        ls ${var_tmp_folder}
        echo "Fail to generate tag"
        test -f ${var_tags_file} || echo 'Update ctags' && cp -f ${var_tmp_folder}/${var_tags_file} ${var_tmp_folder}
        test -f ${var_cscope_file} || echo 'Update cscope' && cp -f ${var_tmp_folder}/${var_cscope_file}* ${var_tmp_folder}
        test -f ${var_cctree_file} || echo 'Update cctree' && cp -f ${var_tmp_folder}/${var_cctree_file} ${var_tmp_folder}
    fi

    rm -rf ${var_tmp_folder} 2> /dev/null

    cd ${cpath}
}
function pvinit()
{
    local var_cpath=$(pwd)
    local var_proj_path="."
    local var_proj_folder="vimproj"
    local var_list_file="proj.files"
    local var_list_header_file="proj_header.files"

    local var_tags_file="tags"
    local var_cscope_file="cscope.db"
    local var_cctree_file="cctree.db"
    local var_config_file="proj.vim"

    local header_rule=()
    local src_path=()
    local file_ext=()
    local file_exclude=()
    local path_exclude=()
    local find_cmd=""
    local flag_append=n
    local flag_header=n

    # path_exclude+=("-not -path '*/.repo/*'")
    # ignore all hiden files
    path_exclude+=("-not -path '*/.*'")

    file_exclude+=("-iname '*.pyc'")

    file_ext+=("-iname '*.c'")
    file_ext+=("-o -iname '*.cc'")
    file_ext+=("-o -iname '*.c++'")
    file_ext+=("-o -iname '*.cxx'")
    file_ext+=("-o -iname '*.cpp'")

    file_ext+=("-o -iname '*.h'")
    file_ext+=("-o -iname '*.hh'")
    file_ext+=("-o -iname '*.h++'")
    file_ext+=("-o -iname '*.hxx'")
    file_ext+=("-o -iname '*.hpp'")
    file_ext+=("-o -iname '*.iig'")

    file_ext+=("-o -iname '*.java'")

    header_rule+=("-iname 'include'")
    header_rule+=("-o -iname 'inc'")

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -a|--append)
                flag_append="y"
                ;;
            -e|--extension)
                file_ext+=("-o -iname \"*.${2}\"")
                shift 1
                ;;
            -x|--exclude)
                file_exclude+=("-o -iname \"${2}\"")
                shift 1
                ;;
            -xp|--exclude-path)
                path_exclude+=("-not -path \"*/${2}/*\"")
                shift 1
                ;;
            -c|--clean)
                local tmp_file_array=("${var_list_file}" "${var_tags_file}" "${var_cscope_file}" "${var_cctree_file}" "pvinit.err" )
                for each_file in "${tmp_file_array[@]}"
                do
                    if [ -f "${each_file}" ]
                    then
                        echo "remove ${each_file}"
                        rm ${each_file}
                    fi
                done
                test -d ${var_proj_folder} && rm -rf ${var_proj_folder}

                # return 0
                ;;
            -H|--header)
                flag_header=y
                ;;
            -h|--help)
                cli_helper -c "pvinit"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "pvinit [Options] [Dirs]"
                cli_helper -t "Options"
                cli_helper -o "-a|--append" -d "append more fire in file list"
                cli_helper -o "-e|--extension" -d "add file extension on search"
                cli_helper -o "-x|--exclude" -d "exclude file on search"
                cli_helper -o "-xp|--exclude-path" -d "exclude file path on search"
                cli_helper -o "-c|--clean" -d "Clean related files"
                cli_helper -o "-H|--header" -d "Add header vim code"
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                break
                ;;
        esac
        shift 1
    done
    # prechecking
    if [ "$#" = "0" ]
    then
        echo "Please enter folder name"
        return -1
    else
        src_path=($@)
    fi

    # path checking
    if ! froot -m ${var_proj_folder}
    then
        froot -m ".repo" || froot -m ".git"
        mkdir -p ${var_proj_folder}
    fi
    var_proj_path="$(realpath .)"
    var_proj_folder="${var_proj_path}/${var_proj_folder}"
    var_list_file="${var_proj_folder}/${var_list_file}"
    var_config_file="${var_proj_folder}/${var_config_file}"
    var_list_header_file="${var_proj_folder}/${var_list_header_file}"

    # file cleaning
    if [ "${flag_append}" = "n" ]
    then
        if [ -f "${var_list_file}" ]
        then
            rm "${var_list_file}" 2> /dev/null
        fi
    fi

    echo "################################################################"
    echo "Searching Path    : ${#src_path[@]}:${src_path[@]}"
    echo "file_ext          : ${file_ext[@]}"
    echo "Project List File : ${var_list_file}"
    echo "Project file path : ${var_proj_path}"
    echo "################################################################"

    cd ${var_cpath}
    for each_path in ${src_path[@]}
    do
        # echo "Searching path: ${each_path}"
        if [ ! -e ${each_path} ]
        then
            printc -c red "folder not found: "
            echo -e "${each_path}"
            continue
        else
            local tmp_path=$(realpath "${each_path}")

            ## Searcing srouce file
            printc -c green "Searching folder: "
            echo -e "$tmp_path"
            find_cmd="find ${tmp_path} \( -type f ${file_ext[@]} \) -not \( ${file_exclude[@]} \) ${path_exclude[@]} | xargs realpath -q >> \"${var_list_file}\""
            echo ${find_cmd}
            eval "${find_cmd}"

            ## Search inlcude
            if [ "${flag_header}" = "y" ]
            then
                find_cmd="find ${tmp_path} \( -type d ${header_rule[@]} \) ${path_exclude[@]} | xargs realpath -q >> \"${var_list_header_file}\""
                echo ${find_cmd}
                eval "${find_cmd}"
            fi
        fi
    done

    ## Remove duplication
    local tmp_file="${var_proj_folder}/tmp.files"
    # resort file list
    cat "${var_list_file}" | sort | uniq > "${tmp_file}"
    mv "${tmp_file}" "${var_list_file}"

    # update vim script file
    if [ "${flag_header}" = "y" ] && test -f ${var_list_header_file}
    then
        cat "${var_list_header_file}" | sort | uniq > "${tmp_file}"
        mv "${tmp_file}" "${var_list_header_file}"

        cat ${var_list_header_file} | sed "s/^/set path+=/g" > ${var_config_file}
    fi

    test -f "${var_config_file}" || touch ${var_config_file}

    pvupdate
    cd ${var_cpath}
    echo Vim project create on ${var_proj_path}
}

function pvim()
{
    # if [ -d $1 ]
    # then
    #     echo "Please enter a file name"
    # fi
    local vim_args=( "" )
    local cpath=`pwd`
    local cmd_args=()
    local flag_cctree=n
    local flag_proj_vim=y
    local flag_time=n
    local var_timestamp="$(tstamp)"

    local var_proj_folder="vimproj"
    local var_list_file="proj.files"

    local var_tags_file="tags"
    local var_cscope_file="cscope.db"
    local var_cctree_file="cctree.db"
    local var_config_file="proj.vim"

    local var_vim_distro="${HS_VAR_VIM}"

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -p|--pure-mode)
                cmd_args+=("-u NONE")
                ;;
            -s|--session)
                if [[ "$#" > 1 ]]
                then
                    tmp_var=$2
                    if [ "${tmp_var}" = "def" ] || [ "${tmp_var}" = "default" ] ||
                        [ "${tmp_var}" = "as" ] || [ "${tmp_var}" = "autosave" ]
                    then
                        export VIDE_SH_SESSION_RESTORE=$2
                        shift 1
                    else
                        export VIDE_SH_SESSION_RESTORE='autosave'
                    fi
                else
                    export VIDE_SH_SESSION_RESTORE='autosave'
                fi
                ;;
            -e|--extra-command)
                cmd_args+=("$2")
                shift 1
                ;;
            -m|--map)
                flag_cctree=y
                ;;
            -l|--lite)
                cmd_args+=("-u $HS_PATH_IDE/tools/vimlite.vim")
                ;;
            -t|--time)
                flag_time=y
                cmd_args+=("-X --startuptime startup_${var_timestamp}.log")
                hs_varconfig -s "${HS_VAR_LOGFILE}" "startup_${var_timestamp}.log"
                ;;
            -c|--clip)
                shift 1
                local buf_tmp="$@"
                [ -f "${buf_tmp}" ] && buf_tmp=$(realpath ${buf_tmp})
                [ -f "${HOME}/.vim/clip" ] && rm -f ${HOME}/.vim/clip

                # printf "V\n%s" "${buf_tmp}" | sed '$ s/$.*//g' > ${HOME}/.vim/clip
                printf "V\n%s\n" "${buf_tmp}" > ${HOME}/.vim/clip
                return 0
                ;;
            --buffer-file|buffer|buf)
                vim_args+="$(hs_varconfig -g ${HS_VAR_LOGFILE})"
                ;;
            # ENV
            p|plugin)
                if [[ "$#" > 1 ]]
                then
                    tmp_var=$2
                    if [ "${tmp_var}" = "y" ] || [ "${tmp_var}" = "n" ]
                    then
                        export VIDE_SH_PLUGIN_ENABLE=$2
                    else
                        export VIDE_SH_PLUGIN_ENABLE='y'
                    fi
                else
                    echo 'fail to read args. $@'
                    return -1
                fi
                shift 1
                ;;
            sc|schars)
                if [[ "$#" > 1 ]]
                then
                    tmp_var=$2
                    if [ "${tmp_var}" = "y" ] || [ "${tmp_var}" = "n" ]
                    then
                        export VIDE_SH_SPECIAL_CHARS=$2
                    else
                        export VIDE_SH_SPECIAL_CHARS='y'
                    fi
                else
                    echo 'fail to read args. $@'
                    return -1
                fi
                shift 1
                ;;
            -d|--distro)
                var_vim_distro="${2}"
                shift 1
                ;;
            -h|--help)
                cli_helper -c "pvim"
                cli_helper -d "pvim [Options] [File]"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "pvim [Options] [File]"
                cli_helper -t "Options"
                cli_helper -o "-m|--map" -d "Load cctree in vim"
                cli_helper -o "-s|--session" -d "Restore session"
                cli_helper -o "-d|--distro" -d "select vim runtint, default use ${HS_VAR_VIM}."
                cli_helper -o "-p|--pure-mode" -d "Load withouth ide file"
                cli_helper -o "--buffer-file|buffer|buf" -d "Open file with hs var(${HS_VAR_LOGFILE})"
                cli_helper -o "-t|--time" -d "Enable startup debug mode"
                cli_helper -o "-c|--clip" -d "Save file in vim buffer file"
                cli_helper -o "-e|--extra-command" -d "pass extra command to vim"
                cli_helper -o "-h|--help" -d "Print help function "
                cli_helper -t "Options"
                cli_helper -o "p|plugin" -d "Plugin disable/enable, plugin y/n"
                cli_helper -o "sc|schars" -d "Special chars disable/enable, schars y/n"
                cli_helper -t "vim-Options"
                cli_helper -o "-R" -d "vim read only mode"
                return 0
                ;;
            *)
                break
                ;;
        esac
        shift 1
    done

    vim_args+=$@

    # unset var
    unset VIDE_SH_TAGS_DB
    unset VIDE_SH_CSCOPE_DB
    unset VIDE_SH_CCTREE_DB
    unset VIDE_SH_PROJ_SCRIPT

    if froot -m ${var_proj_folder}
    then
        var_proj_folder="$(realpath ${var_proj_folder})"
    else
        var_proj_folder="$(realpath .)"
    fi
    cd ${var_proj_folder}

    export VIDE_SH_PROJ_DATA_PATH=$(realpath ${var_proj_folder})

    if test -f "${var_tags_file}"
    then
        export VIDE_SH_TAGS_DB=$(realpath ${var_tags_file})
        # printf "Project %- 6s: %s\n" "Ctag" "${VIDE_SH_TAGS_DB}"
    # else
    #     printf "Project %- 6s: %s\n" "Ctag" "not found"
    fi

    if test -f "${var_cscope_file}"
    then
        export VIDE_SH_CSCOPE_DB=$(realpath ${var_cscope_file})
        # printf "Project %- 6s: %s\n" "CScope" "${VIDE_SH_CSCOPE_DB}"
    # else
    #     printf "Project %- 6s: %s\n" "CScope" "not found"
    fi

    if [ "${flag_proj_vim}" = "y" ] && test -f "${var_config_file}"
    then
        export VIDE_SH_PROJ_SCRIPT=$(realpath ${var_config_file})
        # printf "Project %- 6s: %s\n" "Script" "${VIDE_SH_PROJ_SCRIPT}"
    fi

    if [ "${flag_cctree}" = "y" ] && test -f "${var_cctree_file}"
    then
        echo "Don't forget to use cctreeupdate"
        export VIDE_SH_CCTREE_DB=$(realpath ${var_cctree_file})
        # printf "Project %- 6s: %s\n" "CCTree" "${VIDE_SH_CCTREE_DB}"
    fi

    cd $cpath
    eval ${var_vim_distro} ${cmd_args[@]} ${vim_args[@]}
    printf "Launching %s: %s\n" "${VIDE_SH_PROJ_DATA_PATH}" "${var_vim_distro} ${cmd_args[@]} ${vim_args[@]}"

    # unset var
    unset VIDE_SH_PROJ_DATA_PATH
    unset VIDE_SH_SESSION_RESTORE
    unset VIDE_SH_TAGS_DB
    unset VIDE_SH_CSCOPE_DB
    unset VIDE_SH_CCTREE_DB
    unset VIDE_SH_PROJ_SCRIPT

    unset VIDE_SH_SPECIAL_CHARS
    unset VIDE_SH_PLUGIN_ENABLE

    if [ "${flag_time}" = "y" ]
    then
        grep "STARTED" startup_${var_timestamp}.log
    fi
}
