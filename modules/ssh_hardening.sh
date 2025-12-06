#! /bin/bash
#
# Configures SSH for access control, attack surface reduction, protocol hygiene, and auditability
# 
# Joel Whissel

source "$(dirname "$0")/module_lib.sh"

require_binary "sshd" 
require_binary "systemctl"

backup_file /etc/ssh/sshd_config

update_or_append /etc/ssh/sshd_config "PasswordAuthentication" "no"
update_or_append /etc/ssh/sshd_config "PubkeyAuthentication" "yes"
update_or_append /etc/ssh/sshd_config "PermitRootLogin" "no"
update_or_append /etc/ssh/sshd_config "Protocol" "2"
update_or_append /etc/sshd_config "KexAlgorithms" "curve25519-sha256,curve25519-sha256@libssh.org"
update_or_append /etc/ssh/sshd_config "Ciphers" "chacha20-poly1305@openssh.com,aes256-gcm@openssh.com"
update_or_append /etc/ssh/sshd_config "MACs" "hmac-sha2-512,hmac-sha2-256"

if systemctl list-unit-files | grep -q "^ssh.service"; then
    systemctl restart ssh
else
    systemctl restart sshd
fi
log "INFO" "Restarted SSH service."
