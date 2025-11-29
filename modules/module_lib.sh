# Contains functions for repeated tasks
#
# Joel Whissel

log() {
	local level="$1"
	local msg="$2"
	echo "$(date '+%Y-%m-%d %H:%M:%S') [$level] $msg" | tee -a "$LOG_FILE"
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

update_or_append() {
	local file="$1"
	local key="$2"
	local value="$3"
	
	# key-value pair exists and is active
	if grep -Eq "^[[:space:]]*$key[[:space:]]+$value[[:space:]]*$" "$file"; then
		return 0
	fi
        
	# key exists but is inactive
	if grep -Eq "^[[:space:]]*#*[[:space:]]*$key\b" "$file"; then
		sed -i "s|^[[:space:]]*#*[[:space:]]*$key.*|$key $value|" "$file"
		log "INFO" "Activated $key $value in $file"
		return 0
	fi

	# key exists but value is wrong
	if grep -Eq "^[[:space:]]*$key\b" "$file"; then
		sed -i  "s|^[[:space:]]*$key.*|$key $value|" "$file"
		log "INFO" "Updated $key to $value in $file"
		return 0
	fi

	# key doesn't exist
	echo "$key $value" >> "$file"
	log "INFO" "Added $key $value to $file"
}
