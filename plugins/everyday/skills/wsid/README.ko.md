# wsid — 만능 접수창구 + 할 일·작업 기록 + 아침 브리핑

[English](README.md) | 한국어

메시지·메일·회의 메모·요청을 그냥 붙여넣으면 분류해서 처리하고, 그 과정에서 생긴 할 일과 진행 상황을 자동으로 기록하는 Claude Code 스킬.
빈손으로 부르면 기록과 연결된 자료를 모아 "오늘 뭐부터 할지" 브리핑을 만든다. 아침 자동 실행을 걸어두면 출근 전에 브리핑이 준비된다.

**언제 쓰나:** 일이 들어왔는데 어떻게 처리할지 모를 때, 할 일 목록을 알아서 관리받고 싶을 때, 아침에 뭐부터 할지 모를 때.

**이렇게 말해보기:**
- "오늘 뭐하지" (또는 그냥 `/everyday:wsid`)
- 메시지를 붙여넣고 "이거 뭐임"
- "이거 할 일에 넣어줘"
- "그거 끝났어"

**준비물:** 시작할 때는 없음. 업무 관리 도구나 문서 커넥터가 있으면 브리핑에 더 많이 담긴다. 아침 자동 실행은 macOS 전용.

## 필요한 것
- Claude Code
- (선택) 업무 관리 도구의 MCP 서버나 커넥터 (Jira, Linear, Notion, Asana, GitHub Issues, YouTrack 등). 없으면 wsid 자체 할 일 목록과 작업 기록만으로 동작
- (선택) 개인 기록 문서가 온라인에 있다면 그곳의 커넥터 (구글 드라이브, Notion 등)

## 설치
1. Claude Code에서 아래 두 줄 실행 (자세한 설치 방법은 [루트 README](../../../../README.ko.md))
   ```
   /plugin marketplace add JaeIm2/claude-workflow-kit
   /plugin install everyday@claude-workflow-kit
   ```
2. `/everyday:wsid` 입력
3. 첫 실행 때 몇 가지를 물어본다. 답하면 설정이 끝난다.
   - 업무를 어디서 관리하는지 (그 서비스가 연결돼 있는지 확인함)
   - 평소 업무를 적어두는 문서가 있는지 (로컬 경로나 링크)
   - 할 일 목록과 작업 기록을 어디에 둘지 (기본 `~/.claude/workflow/`)

설정은 `~/.claude/workflow/config.md`에 저장되고, 이 키트의 다른 스킬과 같이 쓴다. 바꾸고 싶으면 `/everyday:wsid 설정`.

## 쓰는 법
- `/everyday:wsid` — 오늘 뭐부터 할지 브리핑
- `/everyday:wsid` + 슬랙 메시지·메일·회의 메모 붙여넣기 — 요지 정리, 답변 초안, 할 일 자동 추가
- "이거 할 일에 넣어줘", "그거 끝났어" — 할 일 목록 갱신
- "견적 건 이어서 하자" — 작업 기록을 읽고 이어서 진행

할 일은 `todo.md` 한 파일에, 하루 넘게 걸리는 업무는 `notes/` 아래 업무별 파일에 기록된다.
메시지 전송, 메일 발송, 업무 관리 도구에 항목 등록 같은 외부 작업은 초안까지만 만들고 승인 후 실행한다.

## 아침 자동 실행 (선택, macOS)
먼저 위 설치와 첫 실행 설정을 끝낸 뒤 진행.

1. 터미널에서 스크립트와 설정 파일 받기
   ```
   mkdir -p ~/.claude/scripts
   curl -fsSL https://raw.githubusercontent.com/JaeIm2/claude-workflow-kit/main/plugins/everyday/skills/wsid/morning-briefing.sh -o ~/.claude/scripts/morning-briefing.sh
   curl -fsSL https://raw.githubusercontent.com/JaeIm2/claude-workflow-kit/main/plugins/everyday/skills/wsid/morning-briefing.plist -o ~/Library/LaunchAgents/morning-briefing.plist
   ```
2. `~/Library/LaunchAgents/morning-briefing.plist`의 `YOUR_NAME`을 본인 계정명으로 수정 (터미널에서 `whoami`)
3. `launchctl load ~/Library/LaunchAgents/morning-briefing.plist`
4. 바로 테스트: `bash ~/.claude/scripts/morning-briefing.sh` → `~/.claude/briefings/`에 파일이 생기면 성공

평일 08:45에 실행되고, 결과는 `~/.claude/briefings/briefing-YYYY-MM-DD.md`에 저장되며 알림이 뜬다. 14일 지난 파일은 자동 삭제.
자동 실행은 읽기만 한다 (할 일·기록·업무 관리 도구를 수정하지 않음). 설정 때 기록해둔 조회용 도구만 쓴다.
