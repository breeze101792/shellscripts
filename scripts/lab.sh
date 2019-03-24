function lab_ancon()
{
    local dev_ip="192.168.7.19"
    adb disconnect $dev_ip
    adb connect $dev_ip
    sleep 0.5
    adb root
    adb connect $dev_ip
}
function lab_tftp_set()
{
    rm ${HOME}/tftp
    ln -sf  `pwd`/$1 ${HOME}/tftp
    ls -al ${HOME} | grep tftp
}
function lab_vm_init()
{
    VBoxClient --clipboard
}
function lab_bash_color()
{
    txtred=$(echo -e '\e[0;31m')
    txtrst=$(echo -e '\e[0m')
    bash | sed -e "s/FAIL/${txtred}FAIL${txtrst}/g"
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
function lab_an_relink()
{

    ln -sf ./build/soong/bootstrap.bash ./bootstrap.bash
    ln -sf ./build/soong/root.bp ./Android.bp
    cd build
    echo `pwd`
    ln -sf ./make/buildspec.mk.default ./buildspec.mk.default
    ln -sf ./make/core ./core
    ln -sf ./make/tools ./tools
    ln -sf ./make/target ./target
    ln -sf ./make/CleanSpec.mk ./CleanSpec.mk
    ln -sf ./make/envsetup.sh ./envsetup.sh
    cd ..
}
function lab_i3_reload()
{
    i3-msg reload
    i3-msg restart
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
