########################################################
########################################################
#####                                              #####
#####    For HS Lab Functions                      #####
#####                                              #####
########################################################
########################################################
function lab_printlc()
{
    # printf label and it's content
    local label=$1
    local content=$2
    local frame_width=64
    local label_width=$((24-1))
    local content_width=$((${frame_width}-${label_width}))
    local padding_char=' '
    local label_cnt=$(echo "${label}" | sed "s/[\(\)]/#/g"| wc -m)
    local content_cnt=$(echo "${content}" |sed "s/[\(\)]/#/g"| wc -m)
    local label_padding_cnt=$(( ${label_width} - ${label_cnt} ))
    local content_padding_cnt=$(( ${content_width} - ${content_cnt} ))
    local label_padding=$(seq -s'-' 0 ${label_padding_cnt} | tr -d '[:digit:]' | sed "s/-/${padding_char}/g")
    local content_padding=$(seq -s'-' 0 ${content_padding_cnt} | tr -d '[:digit:]' | sed "s/-/${padding_char}/g")
    # echo $1: $2
    # printf "%s%s:%s%s" ${label} ${label_padding} ${content} ${content_padding}
    echo -e "${label}${label_padding}:${content_padding}${content}"
}
function lab_sys_status()
{
    local cpu_num=$(nproc)
    local memory=$(free -h  | grep -i mem | tr -s ' ' | cut -d ' ' -f2)

    lab_printlc "Hostname" ${HOSTNAME}
    lab_printlc "CPU(s)" ${cpu_num}
    lab_printlc "Memory" ${memory}
}
function lab_elapse()
{
    local start_time=$2
    local end_time=$1
    date --date="${start_time} - ${end_time} " +%Y%m%d_%H%M%S
}
function lab_bash_color()
{
    txtred=$(echo -e '\e[0;31m')
    txtrst=$(echo -e '\e[0m')
    # bash | sed -e "s/FAIL/${txtred}FAIL${txtrst}/g"
    zsh | sed -e "s/FAIL/${txtred}FAIL${txtrst}/g"
}
function lab_unregex {
   # This is a function because dealing with quotes is a pain.
   # http://stackoverflow.com/a/2705678/120999
   sed -e 's/[]\/()$*.^|[]/\\&/g' <<< "$1"
}

function lab_fsed {
   local find=$(lab_unregex "$1")
   local replace=$(lab_unregex "$2")
   shift 2
   for each_file in $(grep -rn $find | cut -d ':' -f 1 )
   do
       echo -e "Replace in :$each_file"
       sed -i "s/$find/$replace/g" "$each_file"
   done
   # sed -i is only supported in GNU sed.
   #sed -i "s/$find/$replace/g" "$@"
   # perl -p -i -e "s/$find/$replace/g" "$@"
}
#function lab_fsed_resc {
#   local find=$(lab_unregex "$1")
#   local replace=$(lab_unregex "$2")
#   shift 2
#   for each_file in $(grep -rn $find | cut -d ':' -f 1 )
#   do
#       echo -e "Replace in :$each_file"
#       # sed -i "s/TTYControl((xsh.Screen.Send, xsh.Screen.WaitForString, xsh.Session.Sleep, xsh.Screen))/TTYControl(xsh.Screen.Send, xsh.Screen.WaitForString, xsh.Session.Sleep, xsh.Screen)/g" "$each_file"
#       # sed -i "s/((xsh.Screen.Send, xsh.Screen.WaitForString, xsh.Session.Sleep, xsh.Screen))/(xsh.Screen.Send, xsh.Screen.WaitForString, xsh.Session.Sleep, xsh.Screen)/g" "$each_file"
#       sed -i "s/(xsh.Screen.Send, xsh.Screen.WaitForString, None)/(xsh.Screen.Send, xsh.Screen.WaitForString, xsh.Session.Sleep, xsh.Screen)/g" "$each_file"
#   done
#   # sed -i is only supported in GNU sed.
#   #sed -i "s/$find/$replace/g" "$@"
#   # perl -p -i -e "s/$find/$replace/g" "$@"
#}
function lab_addMode()
{
    export width=$1
    export height=$2

    cvt --reduced $width $height 60
    local res=$(cvt --reduced $width $height 60|grep R | sed 's/Modeline//g' )
    echo xrandr --newmode $res
    #xrandr --addmode HDMI-0 $(echo $res|cut -d' ' -f 1)

}
function lab_mark_test()
{
    # local pattern_array=( "error" "fail" "fatl"  "undefined")
    local pattern_red=( "error" "fail" "fatl" "undefined")
    local pattern_yellow=( "warning" "test" )
    local pattern_array=( ${pattern_red[@]} ${pattern_yellow[@]}  )
    local filter_array=""
    # $@ 2>&1 | sed -E -e "s%undefined%$ccred&$ccend%ig" -e "s%fatl%$ccred&$ccend%ig" -e "s%error%$ccred&$ccend%ig" -e "s%fail%$ccred&$ccend%ig" -e "s%warning%$ccyellow&$ccend%ig"
    for each_pattern in ${pattern_array[@]}
    do
        mark 1 $each_pattern
    done

}
function lab_ret()
{
    return 1
}
# function __mark_genstr()
# {
#     local pattern_array=${1[@]}
#     local color_start=$(echo -e "\033[0;31m")
#     local color_end=$(echo -e "\033[0m")
#     local sed_str=""
#     echo ${1[*]}
#     for each_str in ${pattern_array[@]}
#     do
#         echo $each_str
#         $sed_str=echo -e "${sed_str} -e \"s%${each_str}%${ccred}&${ccend}%g\""
#     done
#     echo -e $sed_str

# }
# mark_test()
# {
#     local error_array=("[Ee]rr" "[Ee]rror")
#     local warning_array=("[Ww]arning")
#     __mark_genstr $error_array
#     return
#     local error_str="$(__mark_genstr $error_array)"
#     local warinig_str="$(__mark_genstr $warinig_array)"
#     # $@ 2>&1 | sed -E $error_array $warinig_array
#     echo -e "${error_array}"
#     $@ 2>&1 | sed -E $(__mark_genstr $error_array) $(__mark_genstr $warinig_array)

# }

# function pvinit_bak()
# {
#     local src_path=($@)
#     echo ${src_path[@]}
#     local count=0
#     rm cscope.db proj.files tags 2> /dev/null
#     while true
#     do
#         current_path=${src_path[$count]}
#         echo $count
#         echo "Searching path: ${current_path}"
#         if [ "$current_path" = "" ]
#         then
#             echo "Finished"
#             break
#         else
#             echo -e "Searching folder: $current_path"
#             find ${current_path} -type f -name "*.h" -o -name "*.c" -o -name "*.cpp" -o -name "*.java" >> proj.files
#         fi
#         let count++
#     done
#     cscope -b -i proj.files
#     ctags -L proj.files
#     mv cscope.out cscope.db
# }
