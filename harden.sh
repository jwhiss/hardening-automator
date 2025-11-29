#! /bin/bash
# 
# basic hardening script

audit_dir=~/.local/share/hardening-automator/logs
mkdir -p $audit_dir

echo "Running baseline security audit..."
sudo lynis audit system > $audit_dir/before_audit.log 2>&1


echo "Running baseline security checks..."
sudo apt update

echo "Configuring UFW..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow OpenSSH
sudo ufw --force enable

echo "Applying SSH hardening..."
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl reload sshd 2>/dev/null || sudo systemctl reload ssh

echo "Running final security audit..."
sudo lynis audit system > $audit_dir/after_audit.log 2>&1

