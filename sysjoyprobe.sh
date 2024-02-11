#!/bin/bash

# Function to display section headers
function display_header {
    echo "###############################"
    echo "### $1"
    echo "###############################"
    echo
}

# Function to display block device information
function block_device_info {
    display_header "💽 Block device information:"
    lsblk
    echo
}

# Function to display memory information
function memory_info {
    display_header "📊 Memory information:"
    free -m
    echo
}

# Function to display disk space usage
function disk_space_usage {
    display_header "💾 Checking disk space:"
    df -h
    echo
}

# Function to display disk usage
function disk_usage {
    display_header "📁 Checking disk usage:"
    du -h
    echo
}

# Function to display network information
function network_info {
    display_header "🌐 Checking network information:"
    ip a
    echo
}

# Function to display real-time system information
function real_time_info {
    display_header "⏳ Checking real-time system information:"
    for ((i=1; i<=5; i++)); do
        # Replace this with the real-time system information command
        echo "Iteration $i: Real-time information"
        sleep 1
    done
    echo
}

# Function to display list of running processes
function running_processes {
    display_header "🔄 List of all running processes:"
    ps aux
    echo
}

# Function to display information about logged-in users
function logged_in_users {
    display_header "👥 Checking logged-in users:"
    w
    echo
    display_header "🔍 Shell information of logged-in users:"
    # Check the shell of each user
    for user in $(who | awk '{print $1}'); do
        user_shell=$(getent passwd $user | cut -d: -f7)
        echo "User: $user | Shell: $user_shell"
    done
    echo
}

# Function to check and start SSH service if not running
function check_and_start_ssh {
    if ! systemctl is-active --quiet sshd; then
        echo "🚀 Starting SSH service..."
        sudo systemctl start sshd
        SSH_PID=$(pgrep -o sshd)
        echo "SSH process started with PID: $SSH_PID"
    else
        echo "✅ SSH service is already running."
        SSH_PID=$(pgrep -o sshd)
        echo "SSH process is running with PID: $SSH_PID"
    fi
    echo
}

# Function to check and start HTTPd service if not running
function check_and_start_httpd {
    if ! systemctl is-active --quiet httpd; then
        echo "🚀 Starting HTTPd service..."
        sudo systemctl start httpd
        HTTPD_PID=$(pgrep -o httpd)
        echo "HTTPd process started with PID: $HTTPD_PID"
    else
        echo "✅ HTTPd service is already running."
        HTTPD_PID=$(pgrep -o httpd)
        echo "HTTPd process is running with PID: $HTTPD_PID"
    fi
    echo
}

# Function to kill SSH and HTTPd processes
function kill_processes {
    if [ -n "$SSH_PID" ] || [ -n "$HTTPD_PID" ]; then
        echo "🔪 Killing SSH and HTTPd processes..."
        if [ -n "$SSH_PID" ]; then
            echo "Killing SSH process with PID: $SSH_PID"
            sudo kill $SSH_PID
            echo "✅ SSH process killed."
        fi
        if [ -n "$HTTPD_PID" ]; then
            echo "Killing HTTPd process with PID: $HTTPD_PID"
            sudo kill $HTTPD_PID
            echo "✅ HTTPd process killed."
        fi
        echo "⏰ Sleeping for 5 seconds..."
        sleep 5
        echo
        read -p "Press 1 to start services again: " user_input
        if [ "$user_input" = "1" ]; then
            check_and_start_ssh
            check_and_start_httpd
        else
            echo "Services not restarted."
        fi
    else
        echo "No processes to kill."
    fi
    echo
}

# Main script
block_device_info
memory_info
disk_space_usage
disk_usage
network_info
real_time_info
running_processes
logged_in_users

# Check and start SSH and HTTPd services
check_and_start_ssh
check_and_start_httpd

# Display status of SSH and HTTPd services
echo "🔍 Status of SSH service:"
sudo systemctl status sshd --no-pager
echo

echo "🔍 Status of HTTPd service:"
sudo systemctl status httpd --no-pager
echo

# Kill SSH and HTTPd processes and optionally start again
kill_processes

# Display status of SSH and HTTPd services after restarting
echo "🔍 Status of SSH service after restart:"
sudo systemctl status sshd --no-pager
echo

echo "🔍 Status of HTTPd service after restart:"
sudo systemctl status httpd --no-pager
echo

# End of script

