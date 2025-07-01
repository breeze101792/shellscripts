#!/usr/bin/env bash

# Simple touchpad debug script for X11 systems
# Requires: xinput, libinput, evtest

# List all devices identified as touchpads
list_touchpads() {
    echo "== Available Touchpads =="
    xinput list | grep -i 'touchpad'
    xinput list 
}

# Show device properties using xinput
show_props() {
    local dev="$1"
    echo "== xinput props for device '$dev' =="
    xinput list-props "$dev" 2>/dev/null || echo "Device not found"
}

# Check if device is enabled
check_enabled() {
    local dev="$1"
    state=$(xinput list-props "$dev" 2>/dev/null | grep "Device Enabled" | awk -F: '{print $2}' | xargs)
    if [[ "$state" == "1" ]]; then
        echo "✅ Touchpad '$dev' is ENABLED"
    elif [[ "$state" == "0" ]]; then
        echo "❌ Touchpad '$dev' is DISABLED"
    else
        echo "⚠️ Could not determine status for '$dev'"
    fi
}

# Show real-time event stream using libinput or evtest
stream_events() {
    local event_node="$1"
    if command -v libinput &>/dev/null; then
        echo "== Streaming libinput events for $event_node =="
        sudo libinput debug-events --device "$event_node"
    elif command -v evtest &>/dev/null; then
        echo "== Streaming evtest output for $event_node =="
        sudo evtest "$event_node"
    else
        echo "libinput or evtest not found"
    fi
}
help_menu() {
    echo "Usage:"
    echo "  $0 list                                # List touchpads"
    echo "  $0 props <device name or ID>           # Show properties"
    echo "  $0 status <device name or ID>          # Check if enabled"
    echo "  $0 stream <event device path>          # Show real-time events"
    echo "  $0 log                                 # Show relevant Xorg log entries"
    echo "  $0 real                                # Show real path of a specific device"
    echo "  $0 info                                # Show udevadm info for a specific device"
    echo "  $0 help                                # Show this help message"
}

# === Main ===
main() {
    # local var_path="/dev/input/by-id/usb-04d9_USB_Keyboard-event-if01"
    local var_path="/dev/input/by-id/usb-05ac_0265-if01-event-mouse"
    local var_real_dev_path="$(realpath "${var_path}")"
    local var_event=$(basename "${var_real_dev_path}")
    echo "Event:${var_event}"


    if [[ $# -eq 0 ]]; then
        list_touchpads
        echo ""
        help_menu
        exit 0
    fi

    case "$1" in
        list)
            list_touchpads
            ;;
        props)
            shift
            show_props "$1"
            ;;
        event)
            shift
            sudo libinput debug-events "${var_real_dev_path}"
            ;;
        status)
            shift
            check_enabled "$1"
            ;;
        stream)
            shift
            stream_events "${var_real_dev_path}"
            ;;
        log)
            cat /var/log/Xorg.0.log | grep -A10 "265"
            ;;
        real)
            realpath "${var_path}"
            ;;
        info)
            udevadm info "${var_real_dev_path}"
            ;;
        record)
            sudo libinput record "${var_real_dev_path}"
            ;;
        cal)
            touchpad-edge-detector 161x115 "${var_real_dev_path}"
            ;;
        help)
            help_menu
            ;;
        *)
            echo "❌ Unknown command: $1"
            exit 1
            ;;
    esac
}

main "$@"

