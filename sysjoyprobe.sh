#AUTHOR: Raja Ramees
# Description: Script to gather system information
# DATE: 01/02/2024

echo "🚀 SYSTEM INFORMATION SCRIPT 🚀"

### TO GET THE INFORMATION OF CPU ###
echo "🔍 Information about CPU:"
lscpu
echo "###############################"
echo

### INFORMATION ABOUT THE SYSTEM ###
echo "🖥️ Print information about the system:"
uname -o
echo "###############################"
echo

### INFORMATION ABOUT THE LINUX DISTRIBUTION ###
echo "🐧 Linux distribution information:"
cat /etc/os-release
echo "###############################"
echo

### BLOCK INFORMATION ###
echo "💽 Block device information:"
lsblk
echo "###############################"
echo

### MEMINFO ###################
echo "📊 Memory information:"
free -m
echo "#############################"
echo

### DISK SPACE USAGE ###
echo "💾 Checking disk space:"
df -h
echo "#############################"
echo

### DISK USAGE ###
echo "📁 Checking disk usage:"
du -h
echo "############################"
echo

### NETWORK INFORMATION ###
echo "🌐 Checking network information:"
ip a
echo "############################"
echo

### REAL-TIME SYSTEM INFORMATION ###
echo "⏳ Checking real-time system information:"
# Add a loop or delay here if you want to continuously display real-time information

### LIST ALL RUNNING PROCESSES ###
echo "🔄 List of all running processes:"
ps aux
echo "###############################"
echo

### USER INFORMATION ###
echo "👤 Who is logged into the system:"
who
echo "#############################"
echo

### INFORMATION ABOUT LOGGED-IN USERS ###
echo "👥 Checking logged-in users:"
w
echo "#############################"
echo

# End of script


