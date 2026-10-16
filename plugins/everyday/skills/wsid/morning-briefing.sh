#!/bin/bash
# 아침 브리핑: 헤드리스 Claude로 wsid 빈손 호출 브리핑을 만들어 파일 저장 + macOS 알림.
# launchd(morning-briefing.plist)로 평일 아침 자동 실행. 수동 실행도 가능: bash morning-briefing.sh

set -u
export PATH="$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"

CLAUDE="$(command -v claude)"
OUT_DIR="$HOME/.claude/briefings"
LOG="$OUT_DIR/run.log"
TODAY=$(date +%F)
OUT_FILE="$OUT_DIR/briefing-$TODAY.md"

mkdir -p "$OUT_DIR"
echo "[$(date '+%F %T')] start" >> "$LOG"

PROMPT='wsid 스킬의 "빈손 호출" 브리핑 절차대로 오늘 아침 브리핑을 만들어라.
~/.claude/wsid/config.md 가 없으면 브리핑 대신 "먼저 Claude Code에서 /everyday:wsid 를 한 번 실행해 설정하세요" 한 줄만 출력하라.
이 실행에서는 어떤 파일도 수정하지 마라 (읽기만). 최종 출력은 브리핑 markdown 하나만. 다른 말 붙이지 마라.'

# 조회 도구만 허용 (파일·티켓·문서 수정 불가)
# YouTrack·구글 드라이브를 안 쓰면 해당 도구는 그냥 안 쓰인다.
# 연결된 도구 이름이 다르면 (/mcp 로 확인) 아래 이름을 맞춰 고칠 것.
"$CLAUDE" -p "$PROMPT" \
  --allowedTools "Read" "Glob" "Grep" "Skill" "Bash(git worktree list*)" "Bash(ls*)" \
    "mcp__youtrack-mcp__search_issues" "mcp__youtrack-mcp__get_current_user" "mcp__youtrack-mcp__get_issue" "mcp__youtrack-mcp__get_issue_comments" \
    "mcp__claude_ai_Google_Drive__read_file_content" "mcp__claude_ai_Google_Drive__search_files" \
  > "$OUT_FILE" 2>> "$LOG"

STATUS=$?
if [ $STATUS -eq 0 ] && [ -s "$OUT_FILE" ]; then
  PREVIEW=$(grep -A2 '추천' "$OUT_FILE" | grep -m1 '^[0-9-]' | cut -c1-80)
  osascript -e "display notification \"${PREVIEW:-브리핑 준비 완료}\" with title \"오늘 브리핑\" subtitle \"$OUT_FILE\"" 2>> "$LOG"
  echo "[$(date '+%F %T')] ok -> $OUT_FILE" >> "$LOG"
else
  osascript -e "display notification \"생성 실패 - $LOG 확인\" with title \"아침 브리핑 실패\"" 2>> "$LOG"
  echo "[$(date '+%F %T')] FAIL status=$STATUS" >> "$LOG"
fi

# 14일 지난 브리핑 정리
find "$OUT_DIR" -name 'briefing-*.md' -mtime +14 -delete 2>/dev/null
