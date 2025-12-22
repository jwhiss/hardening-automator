# Hardening Automator
Hardening Automator is a hybrid Bash and Python project that applies a set of foundational security hardening steps to a
Linux system, with automated evaluation using Lynis. The tool is currently under active development and supports SSH 
configuration hardening, firewall setup, and pre- and post-audit comparison.

## Features

### Baseline and Final Security Audits
The project runs Lynis twice:
1. Before any changes are applied (baseline)
2. After all hardening steps are completed

Audit output and logs are stored in the local data directory (assuming the script is run with sudo privileges: 
`/root/.local/share/hardening_automator/logs`).

### Baseline Security Checks
The baseline checks include:
- Verifying that Lynis is installed; if not, it installs Lynis using the system package manager.
- Updating the system package lists and upgrading installed packages to their latest versions.

### Firewall Configuration (UFW)
The main hardening script:
- Sets incoming traffic to deny by default
- Allows outgoing traffic by default
- Allows the OpenSSH profile
- Enables UFW in non-interactive mode

### SSH Hardening Module
The SSH hardening logic, located in `modules/ssh_hardening.sh`, updates `sshd_config` using idempotent key-value 
manipulation functions provided by `module_lib.sh`. These updates enforce stricter SSH security settings while avoiding 
duplicate or conflicting entries.

### Lynis Hardening Index Comparison
`reporting/lynis_parser.py` parses the baseline and final Lynis audit logs and extracts:
- Baseline hardening index
- Final hardening index
- Net improvement after hardening

## Requirements
- Ubuntu or another Debian-based Linux distribution
- Lynis (will be installed if not present)
- Python 3
- UFW (will be installed if not present)
- Sudo privileges

## Notes
This project is a work in progress, does not cover all aspects of system hardening, and has no guarantee of effectiveness. 
Users are encouraged to review the applied changes and customize the hardening steps as needed for their specific environments.

Planned future enhancements include:
- Auditd configuration and monitoring
- Filesystem and permission hardening
- More comprehensive reporting and logging
- Support for additional Linux distributions