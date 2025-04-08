#!/bin/bash

# --- Configuration ---
IDLE_MINUTES=10          # Suspend if idle for this many minutes
CHECK_INTERVAL=20        # How often to check (seconds)
CPU_THRESHOLD=20          # % CPU usage to be considered "idle"
NET_THRESHOLD=10000      # Bytes sent+received to be considered "idle"
# LOG="/var/log/auto_suspend.log"
LOG="/tmp/auto_suspend.log"
IFACE=""                 # Will be selected by user
DEBUG=false               # Enable/disable verbose log

# vars
last_ssh_count=0
max_idle_checks=3600

# --- Debug logging ---
log_debug() {
    if [[ "$DEBUG" == true ]]; then
        echo "[DEBUG] $1"
    fi
}

# --- Select interface function ---
select_interface() {
    echo "Available network interfaces:"
    interfaces=($(ls /sys/class/net | grep -v lo))
    for i in "${!interfaces[@]}"; do
        echo "  [$i] ${interfaces[$i]}"
    done
    read -p "Select the number of the interface to monitor: " idx
    IFACE="${interfaces[$idx]}"
    echo "Selected interface: $IFACE"
    log_debug "Monitoring interface set to: $IFACE"
}

# --- Helper: CPU usage ---
get_cpu_usage() {
    # log_debug "Sampling CPU usage..."
    usage=$(top -bn2 | grep "Cpu(s)" | tail -n1 | awk '{print 100 - $8}')
    # log_debug "CPU usage = $usage%"
    echo "$usage"
}

# --- Helper: Network usage ---
get_network_usage() {
    # log_debug "Measuring network usage on $IFACE..."
    RX1=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)
    TX1=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)
    sleep 1
    RX2=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)
    TX2=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)
    total=$(( (RX2 - RX1) + (TX2 - TX1) ))
    # log_debug "Network usage = $total bytes/sec"
    echo "$total"
}

# --- Helper: SSH session count ---
get_ssh_usage() {
    # ssh_count=$(pgrep -f "sshd:.*@pts" | wc -l)
    ssh_count=$(ps -eo comm,args | grep -E "sshd(-session)?:.*@pts" | grep -v grep | wc -l)
    echo "$ssh_count"
}

# --- Idle check function ---
is_system_idle() {
    logged_in_count=$(who | wc -l)
    cpu_usage=$(get_cpu_usage)
    net_usage=$(get_network_usage)
    ssh_count=$(get_ssh_usage)

    log_debug "CPU Load: $cpu_usage"
    log_debug "Net triffic: $net_usage"
    log_debug "Logged-in users: $logged_in_count"
    log_debug "SSH session count: $ssh_count"

    if [[ "$DEBUG" != true ]]; then
        echo "$(date): CPU=${cpu_usage}%, NET=${net_usage}B, USERS=${logged_in_count}, SSH=${ssh_count}" >> "$LOG"
    fi

    # Only update SSH activity state if count changed
    if [[ "$ssh_count" -ne "$last_ssh_count" ]]; then
        ssh_activity_counter=1
        last_ssh_count=$ssh_count
        log_debug "SSH activity detected (count changed)."
    else
        # ssh_activity_counter=$((ssh_activity_counter + 1))
        ssh_activity_counter=0
        log_debug "No SSH activity change for $ssh_activity_counter check(s)."
    fi

    # Debug
    # if [[ $logged_in_count -eq 0 ]]; then
    #     echo "Active detect. logged_in_count:$logged_in_count"
    # fi
    if [[ $(echo "$cpu_usage >= $CPU_THRESHOLD" | bc) -eq 1 ]]; then
        echo "Active detect. cpu_usage:$cpu_usage"
    fi
    if [[ $net_usage -ge $NET_THRESHOLD ]]; then
        echo "Active detect. net_usage:$net_usage"
    fi
    if [[ $ssh_activity_counter -ne 0 ]]; then
        echo "Active detect. ssh_activity_counter:$ssh_activity_counter"
    fi
    # if [[ $logged_in_count -eq 0 && $(echo "$cpu_usage < $CPU_THRESHOLD" | bc) -eq 1 && $net_usage -lt $NET_THRESHOLD && $ssh_activity_counter -eq 0 ]]; then
    if [[ $(echo "$cpu_usage < $CPU_THRESHOLD" | bc) -eq 1 && $net_usage -lt $NET_THRESHOLD && $ssh_activity_counter -eq 0 ]]; then
        log_debug "System is idle."
        return 0
    else
        log_debug "System is active."
        return 1
    fi
}

# --- Main logic ---
main() {
    log_debug "Starting auto-suspend idle monitor script..."
    select_interface

    idle_counter=0
    ssh_activity_counter=0
    last_ssh_count=$(get_ssh_usage)
    max_idle_checks=$((IDLE_MINUTES * 60 / CHECK_INTERVAL))

    log_debug "Configured to suspend after $IDLE_MINUTES minutes of idleness."

    while true; do
        log_debug "## Running idle check loop... ##"
        if is_system_idle; then
            idle_counter=$((idle_counter + 1))
            log_debug "Idle count: $idle_counter / $max_idle_checks"
            echo "$(date): Idle check $idle_counter / $max_idle_checks" >> "$LOG"
            if [[ $idle_counter -ge $max_idle_checks ]]; then
                echo "$(date): System idle for $IDLE_MINUTES minutes. Suspending..." >> "$LOG"
                log_debug "Triggering system suspend..."
                systemctl suspend
                exit 0
            fi
        else
            log_debug "Resetting idle counter to 0."
            idle_counter=0
        fi
        sleep "$CHECK_INTERVAL"
    done
}

# --- Run ---
main
