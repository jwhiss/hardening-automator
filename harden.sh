#! /bin/bash
# 
# basic hardening script

# environment setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FOLDER=~/.local/share/hardening_automator/logs
LOG_FILE=$LOG_FOLDER/harden.log
source "$SCRIPT_DIR/modules/module_lib.sh"
export LOG_FOLDER
export LOG_FILE
mkdir -p $LOG_FOLDER

echo "Running baseline security audit..."
require_binary lynis "INFO" || {
    log "INFO" "Installing Lynis..."
    apt-get update && apt-get install -y lynis
}
sudo lynis audit system > $LOG_FOLDER/before_audit.log 2>&1

echo "Running baseline security checks..."
sudo apt update
sudo apt upgrade -y
require_binary fail2ban "INFO" || {
    log "INFO" "Installing fail2ban..."
    apt-get update && apt-get install -y fail2ban
}

echo "Configuring UFW..."
require_binary ufw "INFO" || {
    log "INFO" "Installing UFW..."
    apt-get update && apt-get install -y ufw
}
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow OpenSSH
sudo ufw --force enable

echo "Applying SSH hardening..."
"$SCRIPT_DIR"/modules/ssh_hardening.sh

echo "Running final security audit..."
sudo lynis audit system > $LOG_FOLDER/after_audit.log 2>&1

"$SCRIPT_DIR"/reporting/lynis_parser.py

