#!/bin/bash
# Morning briefing: runs the wsid "called with nothing" briefing in headless Claude, saves it to a file, and shows a macOS notification.
# Runs on weekday mornings via launchd (morning-briefing.plist). Can also be run by hand: bash morning-briefing.sh

set -u
export PATH="$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"

CLAUDE="$(command -v claude)"
OUT_DIR="$HOME/.claude/briefings"
LOG="$OUT_DIR/run.log"
TODAY=$(date +%F)
OUT_FILE="$OUT_DIR/briefing-$TODAY.md"

mkdir -p "$OUT_DIR"
echo "[$(date '+%F %T')] start" >> "$LOG"

PROMPT='Create this morning'"'"'s briefing following the "called with nothing" briefing procedure of the wsid skill.
Write it in the language used in ~/.claude/workflow/config.md and the work records.
If ~/.claude/workflow/config.md does not exist, output only one line instead of a briefing: "Run /everyday:wsid once in Claude Code to set it up first."
Do not modify any file in this run (read only). The final output is the briefing markdown only. Add nothing else.'

# Read-only tools only (cannot modify files, tickets, or documents)
TOOLS=("Read" "Glob" "Grep" "Skill" "Bash(git worktree list*)" "Bash(ls*)")
# Plus the read-only tools for your work tracker and notes documents, recorded by wsid setup
# in the "Briefing read-only tools:" line of the config (e.g. mcp__jira__search_issues, ...)
EXTRA=$(grep -m1 'Briefing read-only tools:' "$HOME/.claude/workflow/config.md" 2>/dev/null | sed 's/.*Briefing read-only tools://')
IFS=',' read -ra EXTRA_TOOLS <<< "$EXTRA"
for t in "${EXTRA_TOOLS[@]}"; do
  t=$(echo "$t" | tr -d ' `')
  [[ "$t" == mcp__* ]] && TOOLS+=("$t")
done

"$CLAUDE" -p "$PROMPT" --allowedTools "${TOOLS[@]}" > "$OUT_FILE" 2>> "$LOG"

STATUS=$?
if [ $STATUS -eq 0 ] && [ -s "$OUT_FILE" ]; then
  # The recommendation is the only numbered list in the briefing; preview its first item
  PREVIEW=$(grep -m1 -E '^[0-9]+\.' "$OUT_FILE" | cut -c1-80)
  osascript -e "display notification \"${PREVIEW:-Briefing ready}\" with title \"Today's briefing\" subtitle \"$OUT_FILE\"" 2>> "$LOG"
  echo "[$(date '+%F %T')] ok -> $OUT_FILE" >> "$LOG"
else
  osascript -e "display notification \"Failed - see $LOG\" with title \"Morning briefing failed\"" 2>> "$LOG"
  echo "[$(date '+%F %T')] FAIL status=$STATUS" >> "$LOG"
fi

# Delete briefings older than 14 days
find "$OUT_DIR" -name 'briefing-*.md' -mtime +14 -delete 2>/dev/null
