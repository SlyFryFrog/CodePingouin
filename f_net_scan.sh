#!/bin/bash

# Check if nmap is installed
if ! command -v nmap &> /dev/null; then
  echo "nmap is not installed. Please install it and try again."
  exit 1
fi

# Get the local subnet (e.g., 192.168.1.0/24)
read -p "Enter the local subnet to scan (e.g., 192.168.1.0/24): " subnet
if [ -z "$subnet" ]; then
  echo "No subnet provided. Exiting."
  exit 1
fi

echo "Scanning subnet $subnet for devices with SSH enabled..."

# Scan the subnet for devices with port 22 open
nmap -p 22 --open "$subnet" -oG - | awk '/22\/open/ {print $2}' > ssh_hosts.txt

# Display results
if [ -s ssh_hosts.txt ]; then
  echo "Devices with SSH enabled:"
  cat ssh_hosts.txt
else
  echo "No devices with SSH enabled found in subnet $subnet."
fi

# Cleanup
rm -f ssh_hosts.txt
