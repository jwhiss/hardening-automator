#! /bin/bash
# 
# basic hardening script

echo "Running baseline security checks..."
sudo apt update

echo "Configuring UFW..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow OpenSSH
sudo ufw --force enable

echo "Applying SSH hardening..."
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl reload sshd

echo "Running security audit..."
sudo lynis audit system
