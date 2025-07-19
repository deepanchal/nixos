#!/bin/bash

set -e

if [ -z "$1" ]; then
	echo "Usage: $0 YYYY-MM-DD"
	exit 1
fi

DATE="$1"

# Central time offset
TZ_OFFSET="-05:00"

SINCE="${DATE}T00:00:00${TZ_OFFSET}"
UNTIL=$(date -d "$DATE +1 day" +"%Y-%m-%dT00:00:00${TZ_OFFSET}")

PROMPT='You are an AI developer assistant. Based on the following Git diff, generate a concise list of Conventional Commit messages that summarize the changes. Use bullet points. Follow the Conventional Commits standard (e.g., feat:, fix:, chore:, refactor:, style:, test:, docs:). Your output should be clean, meaningful, and not overly verbose.

DO NOT include descriptions, explanations, footers, commit hashes, file names, or any unnecessary text. ONLY output the commit messages as bullet points.

Keep the number of commit messages proportional to the size and scope of the diff:
- One small diff should return one commit message.
- Larger diffs can return multiple logically grouped commit messages.

Here is the diff:

'

COMMITS=$(git log --since="$SINCE" --until="$UNTIL" --reverse --format="%H")

if [ -z "$COMMITS" ]; then
	echo "No commits found on $DATE"
	exit 0
fi

# Array to store all responses
declare -a ALL_RESPONSES=()
declare -a ALL_HASHES=()
declare -a ALL_DATES=()

echo "-------------------------------"
echo "Conventional Commits for $DATE"
echo "------------------------------"

for COMMIT in $COMMITS; do
	DIFF=$(git show --no-color "$COMMIT")
	SHORT_HASH=$(git rev-parse --short=8 "$COMMIT")
	COMMIT_DATE=$(git show -s --format="%ad" --date=format-local:"%Y-%m-%d %H:%M:%S %z" "$COMMIT")

	echo ""
	echo "--------------------"
	echo "$SHORT_HASH ($COMMIT_DATE)"
	echo "--------------------"

	# Get AI response and store it
	RESPONSE=$(echo "${PROMPT}${DIFF}" | aichat --model openai:gpt-4.1)
	echo "$RESPONSE"

	# Store for summary
	ALL_RESPONSES+=("$RESPONSE")
	ALL_HASHES+=("$SHORT_HASH")
	ALL_DATES+=("$COMMIT_DATE")
done

echo ""
echo "==============================="
echo "SUMMARY - ALL COMMITS FOR $DATE"
echo "==============================="

for i in "${!ALL_RESPONSES[@]}"; do
	# Parse each line of the response and append commit hash
	while IFS= read -r line; do
		if [[ "$line" =~ ^[[:space:]]*-[[:space:]]* ]]; then
			# This is a bullet point, append the commit hash
			echo "$line (${ALL_HASHES[$i]})"
		elif [[ -n "$line" ]]; then
			# Non-empty line that's not a bullet point, still append hash
			echo "- $line (${ALL_HASHES[$i]})"
		fi
	done <<<"${ALL_RESPONSES[$i]}"
done
