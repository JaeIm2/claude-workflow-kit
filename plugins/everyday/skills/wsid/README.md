# wsid — 만능 접수창구 + 할 일·작업 기록 + 아침 브리핑

메시지·메일·회의 메모·요청을 그냥 붙여넣으면 분류해서 처리하고, 그 과정에서 생긴 할 일과 진행 상황을 자동으로 기록하는 Claude Code 스킬.
빈손으로 부르면 기록과 연결된 자료를 모아 "오늘 뭐부터 할지" 브리핑을 만든다. 아침 자동 실행을 걸어두면 출근 전에 브리핑이 준비된다.

## 필요한 것
- Claude Code
- (선택) YouTrack 연결 — 업무를 YouTrack으로 관리한다면
- (선택) 구글 드라이브 연결 — 개인 기록을 구글 문서에 둔다면

## 설치
1. Claude Code에서 아래 두 줄 실행 (자세한 설치 방법은 [루트 README](../../../../README.md))
   ```
   /plugin marketplace add JaeIm2/claude-workflow-kit
   /plugin install everyday@claude-workflow-kit
   ```
2. `/everyday:wsid` 입력
3. 첫 실행 때 몇 가지를 물어본다. 답하면 설정이 끝난다.
   - 업무를 YouTrack으로 관리하는지
   - 평소 업무를 적어두는 문서가 있는지 (로컬 경로나 링크)
   - 할 일 목록과 작업 기록을 어디에 둘지 (기본 `~/.claude/wsid/`)

설정은 `~/.claude/wsid/config.md`에 저장된다. 바꾸고 싶으면 `/everyday:wsid 설정`.

## 쓰는 법
- `/everyday:wsid` — 오늘 뭐부터 할지 브리핑
- `/everyday:wsid` + 슬랙 메시지·메일·회의 메모 붙여넣기 — 요지 정리, 답변 초안, 할 일 자동 추가
- "이거 할 일에 넣어줘", "그거 끝났어" — 할 일 목록 갱신
- "견적 건 이어서 하자" — 작업 기록을 읽고 이어서 진행

할 일은 `todo.md` 한 파일에, 하루 넘게 걸리는 업무는 `notes/` 아래 업무별 파일에 기록된다.
메시지 전송, 메일 발송, 티켓 등록 같은 외부 작업은 초안까지만 만들고 승인 후 실행한다.

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
자동 실행은 읽기만 한다 (할 일·기록·티켓을 수정하지 않음).
