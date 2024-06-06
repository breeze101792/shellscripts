
fSoftLink()
{
    local var_src_path=$1
    local var_dst_path=$2

    if test -L "${var_dst_path}"
    then
        echo -e "${DEF_COLOR_YELLOW} Ignore links, (${var_src_path} to ${var_dst_path})${DEF_COLOR_NORMAL}"
        return 0
    elif test -e "${var_dst_path}"
    then
        echo -e "${DEF_COLOR_RED} File exist & not symbolic link (${var_src_path} to ${var_dst_path})${DEF_COLOR_NORMAL}"
        return 1
    else
        echo "Link ${var_src_path} to ${var_dst_path}."
        ln -s ${var_src_path} ${var_dst_path}
        return 0
    fi
}
