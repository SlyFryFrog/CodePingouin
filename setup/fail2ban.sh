#!/bin/bash

# Script to set up Fail2Ban on an Ubuntu server

# Update and upgrade the system
echo "Updating system..."
sudo apt update && sudo apt upgrade -y

# Install Fail2Ban
echo "Installing Fail2Ban..."
sudo apt install fail2ban -y

# Copy the default configuration file to jail.local
echo "Configuring Fail2Ban..."
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Add configuration to jail.local
sudo bash -c 'cat <<EOT >> /etc/fail2ban/jail.local

[DEFAULT]
bantime  = 10m
findtime = 10m
maxretry = 5

[sshd]
enabled = true
port    = ssh
logpath = %(sshd_log)s
maxretry = 3

EOT'

# Start and enable Fail2Ban service
echo "Starting and enabling Fail2Ban service..."
sudo systemctl start fail2ban
sudo systemctl enable fail2ban

# Display the status of Fail2Ban and SSH jail
echo "Fail2Ban status:"
sudo fail2ban-client status
echo "SSH jail status:"
sudo fail2ban-client status sshd

echo "Fail2Ban setup completed!"
