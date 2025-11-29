#! /bin/bash
#
# Configures SSH for access control, attack surface reduction, protocol hyeine, and auditability
# 
# Joel Whissel

source "$(dirname "$0")/module_lib.sh"

require_binary "sshd" 
require_binary "systemctl"

backup_file /etc/ssh/sshd_config

update_or_append /etc/ssh/sshd_config "PasswordAuthentication" "no"
update_or_append /etc/ssh/sshd_config "PubkeyAuthentication" "yes"

if systemctl list-unit-files | grep -q "^ssh.service"; then
    systemctl restart ssh
else
    systemctl restart sshd
fi
log "INFO" "Restarted SSH service due to configuration changes."
