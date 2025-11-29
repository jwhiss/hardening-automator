#! /bin/bash
# 
# basic hardening script

# environment setup
LOG_FOLDER=~/.local/share/hardening-automator/logs
LOG_FILE=$LOG_FOLDER/harden.log
export LOG_FILE
mkdir -p $LOG_FOLDER

echo "Running baseline security audit..."
sudo lynis audit system > $LOG_FOLDER/before_audit.log 2>&1


echo "Running baseline security checks..."
sudo apt update

echo "Configuring UFW..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow OpenSSH
sudo ufw --force enable

echo "Applying SSH hardening..."
./modules/ssh_hardening.sh

echo "Running final security audit..."
sudo lynis audit system > $LOG_FOLDER/after_audit.log 2>&1

