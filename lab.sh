
alias mdebug="screen -S debug -L -Logfile debug_`tstamp`.log /dev/ttyUSB1 115200 "
alias sdebug="screen -S debug_s -L -Logfile debug_`tstamp`.log"
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
   local find=$(unregex "$1")
   local replace=$(unregex "$2")
   shift 2
   # sed -i is only supported in GNU sed.
   #sed -i "s/$find/$replace/g" "$@"
   perl -p -i -e "s/$find/$replace/g" "$@"
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
