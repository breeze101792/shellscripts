#!/bin/bash
function lab_option()
{
    name=${1//\//\\/}
    value=${2//\//\\/}
    sed -i \
        -e '/^#\?\(\s*'"${name}"'\s*=\s*\).*/{s//\1'"${value}"'/;:a;n;ba;q}' \
        -e '$a'"${name}"'='"${value}" $3
}

function bitcalc()
{
    local var_ori_value=0
    local var_bit_low=0
    local var_bit_heigt=0
    local var_target_value=0
    local var_target_size=0
    local var_mask=0
    local var_action="set"

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -o|--ori-value)
                var_ori_value=${2}
                shift 1
                ;;
            -l|--low-bit)
                var_bit_low=${2}
                shift 1
                ;;
            -h|--heigh-bit)
                var_bit_heigt=${2}
                shift 1
                ;;
            -v|--target-value)
                var_target_value=${2}
                shift 1
                ;;
            -a|--append)
                cmd_args+=("${2}")
                shift 1
                ;;
            -v|--verbose)
                flag_verbose="y"
                shift 1
                ;;
            -h|--help)
                cli_helper -c "bitcalc" -cd "bitcalc function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "bitcalc [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-a|--append" -d "append file extension on search"
                cli_helper -o "-v|--verbose" -d "Verbose print "
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
    if test -z "${var_bit_heigt}"
    then
        var_bit_heigt=${var_bit_low}
    fi

    # echo "value: $var_ori_value, $var_bit_low, $var_bit_heigt, $var_target_value, $var_taarget_size"
    echo seq ${var_bit_low} ${var_bit_heigt}
    for each_bit in $(seq ${var_bit_low} ${var_bit_heigt})
    do
        echo ${each_bit}
        var_mask=$((${var_mask} | 0x1 << ${each_bit}))
    done
    printf "var_mask: %x\n" ${var_mask}
    local tmp_value="$(( ${var_target_value} << ${var_bit_low} ))"
    printf "tmp_value: %x\n" ${tmp_value}
    tmp_value="$(( ${var_target_value} & ${var_mask} ))"

    if [ "${var_action}" = "set" ]
    then
        # printf "%x\n" "$((${var_ori_value} & ~${var_mask}))"
        printf "0x%x\n" "$(((${var_ori_value} & ~${var_mask}) | $tmp_value))"
    fi
}
