# Contains functions for repeated tasks
#
# Joel Whissel

log() {
	local level="s1"
	local msg="s2"
	echo "$(date '+%Y-%m-%d %H:%M:%S') [$level\ $msg" tee -a "$LOG_FILE"
}
