
########################################################
########################################################
#####                                              #####
#####    Others                                    #####
#####                                              #####
########################################################
########################################################
function i3_reload()
{
    i3-msg reload
    i3-msg restart
}
function lg_patch
{
    cvt --reduced 2440 1028 60
    xrandr --newmode "2440x1028R"  164.75  2440 2488 2520 2600  1028 1031 1041 1058 +hsync -vsync
    xrandr --addmode HDMI-0 "2440x1028R"
}
function vm_init()
{
    VBoxClient --clipboard
}
########################################################
########################################################
#####                                              #####
#####    Canditate functions                       #####
#####                                              #####
########################################################
########################################################

function sed_replace()
{
    local pattern=$1
    local target_string=$2

    for each_file in $(grep -rn ${pattern} | cut -d ":" -f 1 | sort | uniq)
    do
        echo "Replacing ${pattern} with ${target_string} in ${each_file}"
        sed -i "s/${pattern}/${target_string}/g" $(realpath ${each_file})
    done
}
