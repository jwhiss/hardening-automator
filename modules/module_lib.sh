# Contains functions for repeated tasks
#
# Joel Whissel

log() {
	local level="$1"
	local msg="$2"
	echo "$(date '+%Y-%m-%d %H:%M:%S') [$level\ $msg" tee -a "$LOG_FILE"
}

require_binary() {
	local bin="$1"
	if ! command -v "$bin" >/dev/null 2>&1; then
		log "ERROR" "Required binary '$bin' not found."
		return 1
	fi
}

backup_file() {
	local file="$1"
	if [ -f "$file" ]; then
		local backup="${file}.bak.$(date +%s)"
		cp "$file" "$backup"
		log "INFO" "Backup created: $backup"
	fi
}
