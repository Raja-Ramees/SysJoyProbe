
#!/bin/bash

# Advanced System Monitoring Script with Logging

# Log file
log_file="system_monitoring_log_$(date +"%Y%m%d_%H%M%S").txt"

# Function to log messages
log_message() {
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[${timestamp}] $1" >> "$log_file"
}

# Function to get CPU usage percentage
get_cpu_usage() {
    log_message "Fetching CPU usage."
    cpu_percentage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | awk -F. '{print $1}')
    echo "CPU Usage: ${cpu_percentage}%"
}

# Function to get memory usage
get_memory_usage() {
    log_message "Fetching memory usage."
    memory_usage=$(free -m | awk '/Mem:/ {printf "%dMB used, %dMB free\n", $3, $4}')
    echo "Memory Usage: ${memory_usage}"
}

# Function to get disk space usage
get_disk_usage() {
    log_message "Fetching disk space usage."
    disk_usage=$(df -h | awk '$NF=="/" {printf "Disk Usage: %s used, %s free\n", $3, $4}')
    echo "${disk_usage}"
}

# Function to get network statistics
get_network_statistics() {
    log_message "Fetching network statistics."
    ifstat_installed=$(command -v ifstat)
    if [ -n "$ifstat_installed" ]; then
        network_stats=$(ifstat 1 1 | tail -n 1 | awk '{printf "Network: Rx %s, Tx %s\n", $3, $5}')
        echo "${network_stats}"
    else
        log_message "Error: 'ifstat' is not installed. Unable to fetch network statistics."
        echo "Error: 'ifstat' is not installed. Please install it to display network statistics."
    fi
}

# Function to display running processes
get_running_processes() {
    log_message "Fetching running processes."
    processes=$(ps aux --sort=-%cpu | head -n 10)
    echo "Top 10 CPU-Intensive Processes:"
    echo "${processes}"
}

# Function to monitor specific processes
monitor_processes() {
    log_message "Monitoring specific processes."
    read -p "Enter the process names (comma-separated): " process_names
    for process_name in $(echo "$process_names" | tr ',' ' '); do
        process_info=$(pgrep -fl "$process_name")
        if [ -n "$process_info" ]; then
            echo "Process '$process_name' is running: $process_info"
            log_message "Process '$process_name' is running: $process_info"
        else
            echo "Process '$process_name' is not running."
            log_message "Process '$process_name' is not running."
        fi
    done
}

# Function to generate a detailed system report
generate_detailed_system_report() {
    log_message "Generating detailed system report."
    report_file="detailed_system_report_$(date +"%Y%m%d_%H%M%S").txt"
    {
        echo "=== Detailed System Report - $(date) ==="
        get_cpu_usage
        get_memory_usage
        get_disk_usage
        get_system_uptime
        get_network_statistics
        get_running_processes
        echo "==============================="
        monitor_processes
        echo "==============================="
    } > "${report_file}"
    if [ $? -eq 0 ]; then
        echo "Report file generated successfully: ${report_file}"
        log_message "Report file generated successfully: ${report_file}"
    else
        echo "Error: Unable to generate the report file."
        log_message "Error: Unable to generate the report file."
    fi
}

# Function to display system uptime
get_system_uptime() {
    log_message "Fetching system uptime."
    uptime=$(uptime -p)
    echo "System Uptime: ${uptime}"
}

# Function to display a menu
display_menu() {
    echo "==================== Advanced System Monitoring Menu ===================="
    echo "1. Display CPU Usage"
    echo "2. Display Memory Usage"
    echo "3. Display Disk Space Usage"
    echo "4. Display Network Statistics"
    echo "5. Display Running Processes"
    echo "6. Monitor Specific Processes"
    echo "7. Generate Detailed System Report"
    echo "8. Exit"
    echo "========================================================================"
}

# Main execution
while true; do
    display_menu
    read -p "Enter your choice (1-8): " choice

    if [[ "$choice" =~ ^[1-8]$ ]]; then
        case $choice in
            1) get_cpu_usage ;;
            2) get_memory_usage ;;
            3) get_disk_usage ;;
            4) get_network_statistics ;;
            5) get_running_processes ;;
            6) monitor_processes ;;
            7) generate_detailed_system_report ;;
            8)
                echo "Exiting. Goodbye!"
                log_message "Exiting the script."
                exit
                ;;
        esac
        read -p "Press Enter to continue..."
        clear
    else
        echo "Error: Invalid choice. Please enter a number between 1 and 8."
        log_message "Error: Invalid menu choice entered."
    fi
done

