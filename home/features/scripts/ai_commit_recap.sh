#!/bin/bash

set -e

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

# Default values
TIMEZONE_RAW=$(date +"%z")
# Convert from -0500 format to -05:00 format
if [[ ${#TIMEZONE_RAW} -eq 5 ]]; then
	TZ_OFFSET="${TIMEZONE_RAW:0:3}:${TIMEZONE_RAW:3:2}"
else
	TZ_OFFSET="$TIMEZONE_RAW"
fi
AUTHOR=""
DATE=""
VERBOSE=false
NO_COLOR=false

# Functions
usage() {
	echo -e "${BOLD}AI Commit Recap Generator${RESET}"
	echo
	echo -e "${BOLD}USAGE:${RESET}"
	echo "    $0 [OPTIONS] DATE"
	echo
	echo -e "${BOLD}DESCRIPTION:${RESET}"
	echo "    Generates AI-powered conventional commit summaries for all commits on a given date."
	echo "    Uses aichat to analyze git diffs and suggest conventional commit messages."
	echo
	echo -e "${BOLD}ARGUMENTS:${RESET}"
	echo "    DATE                    Date in YYYY-MM-DD format (e.g., 2024-01-15)"
	echo
	echo -e "${BOLD}OPTIONS:${RESET}"
	echo "    -a, --author AUTHOR     Filter commits by author name or email"
	echo "    -v, --verbose          Enable verbose output"
	echo "    -n, --no-color         Disable colored output"
	echo "    -h, --help             Show this help message"
	echo
	echo -e "${BOLD}EXAMPLES:${RESET}"
	echo "    # Generate recap for today"
	echo "    $0 \$(date +%Y-%m-%d)"
	echo
	echo "    # Generate recap for specific date"
	echo "    $0 2024-01-15"
	echo
	echo "    # Filter by author"
	echo "    $0 --author \"john.doe@example.com\" 2024-01-15"
	echo "    $0 -a \"John Doe\" 2024-01-15"
	echo
	echo "    # Combine options"
	echo "    $0 -a \"jane@example.com\" -v 2024-01-15"
	echo
	echo -e "${BOLD}NOTES:${RESET}"
	echo "    - Requires 'aichat' command with OpenAI API access"
	echo "    - Times are calculated from 00:00:00 to 23:59:59 in system timezone"
	echo "    - Author matching is case-insensitive and supports partial matches"
	echo
}

log_info() {
	if [[ "$NO_COLOR" == "true" ]]; then
		echo "INFO: $1"
	else
		echo -e "${BLUE}ℹ${RESET} $1"
	fi
}

log_success() {
	if [[ "$NO_COLOR" == "true" ]]; then
		echo "SUCCESS: $1"
	else
		echo -e "${GREEN}✓${RESET} $1"
	fi
}

log_warning() {
	if [[ "$NO_COLOR" == "true" ]]; then
		echo "WARNING: $1"
	else
		echo -e "${YELLOW}⚠${RESET} $1"
	fi
}

log_error() {
	if [[ "$NO_COLOR" == "true" ]]; then
		echo "ERROR: $1" >&2
	else
		echo -e "${RED}✗${RESET} $1" >&2
	fi
}

log_verbose() {
	if [[ "$VERBOSE" == "true" ]]; then
		if [[ "$NO_COLOR" == "true" ]]; then
			echo "VERBOSE: $1"
		else
			echo -e "${DIM}${CYAN}→${RESET} ${DIM}$1${RESET}"
		fi
	fi
}

print_header() {
	local text="$1"
	local length=${#text}
	local separator=$(printf '=%.0s' $(seq 1 $length))

	if [[ "$NO_COLOR" == "true" ]]; then
		echo "$separator"
		echo "$text"
		echo "$separator"
	else
		echo -e "${BOLD}${PURPLE}$separator${RESET}"
		echo -e "${BOLD}${WHITE}$text${RESET}"
		echo -e "${BOLD}${PURPLE}$separator${RESET}"
	fi
}

print_subheader() {
	local text="$1"
	local length=${#text}
	local separator=$(printf -- '-%.0s' $(seq 1 $length))

	if [[ "$NO_COLOR" == "true" ]]; then
		echo "$separator"
		echo "$text"
		echo "$separator"
	else
		echo -e "${CYAN}$separator${RESET}"
		echo -e "${BOLD}${CYAN}$text${RESET}"
		echo -e "${CYAN}$separator${RESET}"
	fi
}

# Validate date format
validate_date() {
	local date_str="$1"
	if ! date -d "$date_str" >/dev/null 2>&1; then
		log_error "Invalid date format: $date_str"
		log_info "Please use YYYY-MM-DD format (e.g., 2024-01-15)"
		exit 1
	fi
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
	case $1 in
	-a | --author)
		AUTHOR="$2"
		shift 2
		;;
	-v | --verbose)
		VERBOSE=true
		shift
		;;
	-n | --no-color)
		NO_COLOR=true
		shift
		;;
	-h | --help)
		usage
		exit 0
		;;
	-*)
		log_error "Unknown option: $1"
		echo
		usage
		exit 1
		;;
	*)
		if [[ -z "$DATE" ]]; then
			DATE="$1"
		else
			log_error "Too many arguments"
			echo
			usage
			exit 1
		fi
		shift
		;;
	esac
done

# Check if date is provided
if [[ -z "$DATE" ]]; then
	log_error "Date argument is required"
	echo
	usage
	exit 1
fi

# Validate date
validate_date "$DATE"

# Calculate time range
SINCE="${DATE}T00:00:00${TZ_OFFSET}"
UNTIL=$(date -d "$DATE +1 day" +"%Y-%m-%dT00:00:00${TZ_OFFSET}")

log_verbose "Time range: $SINCE to $UNTIL"

# Build git log command
GIT_CMD="git log --since=\"$SINCE\" --until=\"$UNTIL\" --reverse --format=\"%H\""
if [[ -n "$AUTHOR" ]]; then
	GIT_CMD="$GIT_CMD --author=\"$AUTHOR\""
	log_verbose "Filtering by author: $AUTHOR"
fi

log_verbose "Git command: $GIT_CMD"

# AI prompt
PROMPT='You are an AI developer assistant. Based on the following Git diff, generate a concise list of Conventional Commit messages that summarize the changes. Use bullet points. Follow the Conventional Commits standard (e.g., feat:, fix:, chore:, refactor:, style:, test:, docs:). Your output should be clean, meaningful, and not overly verbose.

DO NOT include descriptions, explanations, footers, commit hashes, file names, or any unnecessary text. ONLY output the commit messages as bullet points.

Keep the number of commit messages proportional to the size and scope of the diff:
- One small diff should return one commit message.
- Larger diffs can return multiple logically grouped commit messages.

Here is the diff:

'

# Human-readable recap prompt
HUMAN_PROMPT='You are an assistant generating human-readable daily work logs.
Based on the following commit summaries (which follow Conventional Commits),
rewrite them as clear, simple bullet points that a project manager can easily understand.

Guidelines:
- Keep the same number of bullet points as the original.
- Use plain language, no technical jargon.
- Focus on what was done or accomplished (not how).
- Write in past tense.
- Do not include commit hashes, file names, or code details.
- Output ONLY bullet points.

Here are the commit summaries:

'

# Get commits
log_info "Searching for commits on $DATE..."
COMMITS=$(eval "$GIT_CMD")

if [[ -z "$COMMITS" ]]; then
	log_warning "No commits found on $DATE"
	if [[ -n "$AUTHOR" ]]; then
		log_info "Try removing the author filter or check the author name/email"
	fi
	exit 0
fi

# Count commits
COMMIT_COUNT=$(echo "$COMMITS" | wc -l)
log_success "Found $COMMIT_COUNT commit(s)"

# Check if aichat is available
if ! command -v aichat >/dev/null 2>&1; then
	log_error "aichat command not found"
	log_info "Please install aichat and configure it with OpenAI API access"
	exit 1
fi

# Array to store all responses
declare -a ALL_RESPONSES=()
declare -a ALL_HASHES=()
declare -a ALL_DATES=()

echo
print_header "AI Commit Recap for $DATE"

if [[ -n "$AUTHOR" ]]; then
	log_info "Author filter: $AUTHOR"
fi
echo

current_commit=1
for COMMIT in $COMMITS; do
	DIFF=$(git show --no-color "$COMMIT")
	SHORT_HASH=$(git rev-parse --short=8 "$COMMIT")
	COMMIT_DATE=$(git show -s --format="%ad" --date=format-local:"%Y-%m-%d %H:%M:%S %z" "$COMMIT")
	COMMIT_AUTHOR=$(git show -s --format="%an <%ae>" "$COMMIT")

	echo
	print_subheader "Commit $current_commit/$COMMIT_COUNT - $SHORT_HASH"

	if [[ "$NO_COLOR" == "true" ]]; then
		echo "Date: $COMMIT_DATE"
		echo "Author: $COMMIT_AUTHOR"
	else
		echo -e "${DIM}Date:${RESET}   $COMMIT_DATE"
		echo -e "${DIM}Author:${RESET} $COMMIT_AUTHOR"
	fi

	log_verbose "Processing commit $SHORT_HASH..."

	# Get AI response and store it
	log_info "Generating AI summary..."
	RESPONSE=$(echo "${PROMPT}${DIFF}" | aichat --model openai:gpt-4.1)

	if [[ "$NO_COLOR" == "true" ]]; then
		echo "$RESPONSE"
	else
		echo -e "${GREEN}$RESPONSE${RESET}"
	fi

	# Store for summary
	ALL_RESPONSES+=("$RESPONSE")
	ALL_HASHES+=("$SHORT_HASH")
	ALL_DATES+=("$COMMIT_DATE")

	((current_commit++))
done

echo
print_header "SUMMARY - ALL COMMITS FOR $DATE"

for i in "${!ALL_RESPONSES[@]}"; do
	# Parse each line of the response and append commit hash
	while IFS= read -r line; do
		if [[ "$line" =~ ^[[:space:]]*-[[:space:]]* ]]; then
			# This is a bullet point, append the commit hash
			if [[ "$NO_COLOR" == "true" ]]; then
				echo "$line (${ALL_HASHES[$i]})"
			else
				echo -e "${YELLOW}$line${RESET} ${DIM}(${ALL_HASHES[$i]})${RESET}"
			fi
		elif [[ -n "$line" ]]; then
			# Non-empty line that's not a bullet point, still append hash
			if [[ "$NO_COLOR" == "true" ]]; then
				echo "- $line (${ALL_HASHES[$i]})"
			else
				echo -e "${YELLOW}- $line${RESET} ${DIM}(${ALL_HASHES[$i]})${RESET}"
			fi
		fi
	done <<<"${ALL_RESPONSES[$i]}"
done

echo
print_header "HUMAN-READABLE DAILY SUMMARY"

ALL_TEXT=$(printf "%s\n" "${ALL_RESPONSES[@]}")

HUMAN_RECAP=$(echo "${HUMAN_PROMPT}${ALL_TEXT}" | aichat --model openai:gpt-4.1)

if [[ "$NO_COLOR" == "true" ]]; then
	echo "$HUMAN_RECAP"
else
	echo -e "${WHITE}$HUMAN_RECAP${RESET}"
fi

echo
log_success "Recap complete! Processed $COMMIT_COUNT commit(s)"
