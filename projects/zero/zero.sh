#!/bin/bash
hs_print "Source Zero project"
function zero_info()
{
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -f|--freq|freq)
                echo "# Show Frequency info"
                echo "----------------------------------------------------------------"
                for src in arm core h264 isp v3d uart pwm emmc pixel vec hdmi dpi ; do \
                    echo -e "$src:\t$(vcgencmd measure_clock $src)" ; \
                done
                ;;
            -v|--voltage|voltage)
                echo "# Show Voltage info"
                echo "----------------------------------------------------------------"
                for id in core sdram_c sdram_i sdram_p ; do \
                    echo -e "$id:\t$(vcgencmd measure_volts $id)" ; \
                done
            ;;
            -t|--temp|temp)
                echo "# Show Temperature info"
                echo "----------------------------------------------------------------"
                vcgencmd measure_temp
            ;;
            -c|--config|config)
                echo "# Show Config info"
                echo "----------------------------------------------------------------"
                vcgencmd get_config int
            ;;
            -m|--mem|mem)
                echo "# Show Memory Config info"
                echo "----------------------------------------------------------------"
                vcgencmd get_mem arm && vcgencmd get_mem
            ;;
            --codec|codec)
                echo "# Show Codec info"
                echo "----------------------------------------------------------------"
                for codec in H264 MPG2 WVC1 MPG4 MJPG WMV9 ; do \
                    echo -e "$codec:\t$(vcgencmd codec_enabled $codec)" ; \
                done
            ;;
            # -v|--verbose)
            #     flag_verbose="y"
            #     shift 1
            #     ;;
            -h|--help)
                cli_helper -c "zero_info" -cd "zero_info function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "zero_info [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-f|--freq|freq"       -d "Show freqs info"
                cli_helper -o "-v|--voltage|voltage" -d "Show volatge info"
                cli_helper -o "-t|--temp|temp"       -d "Show temperature info"
                cli_helper -o "-c|--config|config"   -d "Show configs info"
                cli_helper -o "-m|--mem|mem"         -d "Show memory info"
                # cli_helper -o "-v|--verbose"         -d "Verbose print "
                cli_helper -o "-h|--help"            -d "Print help function "
                cli_helper -o "--codec|codec"        -d "Show codec info"
                return 0
                ;;
            *)
                echo "Wrong args, $@"
                return -1
                ;;
        esac
        shift 1
    done
}

