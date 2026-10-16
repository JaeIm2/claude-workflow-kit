# weekly-report — 우리 팀 양식대로 주간보고 초안

[English](README.md) | 한국어

주간보고 초안을 써주는 Claude Code 스킬. 정해둔 곳에서 이번 주 작업을 모으고, 주차가 바뀌어도 이어서 추적할 수 있는 작업 단위로 묶고, 거기서 빠진 일은 물어본 뒤, 팀 양식에 맞춘 복붙용 초안을 출력한다. 제출은 직접 한다. 스킬은 아무것도 보내지 않는다.

## 필요한 것
- Claude Code
- (선택) 업무 관리 도구의 MCP 서버나 커넥터 (Jira, Linear, Notion, Asana, GitHub Issues, YouTrack 등)
- (선택) Claude Code 세션 기록을 훑으려면 Python 3

## 설치
1. Claude Code에서 아래 두 줄 실행 (자세한 설치 방법은 [루트 README](../../../../README.ko.md))
   ```
   /plugin marketplace add JaeIm2/claude-workflow-kit
   /plugin install everyday@claude-workflow-kit
   ```
2. `/everyday:weekly-report` 입력
3. 첫 실행 때 물어보는 것
   - 보고 양식 (지난주 보고나 빈 양식을 붙여넣기)
   - 보고 받는 사람이 싫어하거나 꼭 원하는 것 (예: 티켓 번호 쓰지 말 것)
   - 어디서 모을지: 할 일·작업 기록(`/everyday:wsid`가 관리하는 것), 레포 git 기록, 업무 관리 도구, Claude Code 세션 기록
   - 보고 기간과 마감
   - 제출 방법 (폼, 메일, 메신저, 시트)

설정은 `~/.claude/workflow/config.md`에 저장되고, 이 키트의 다른 스킬과 같이 쓴다. 바꾸고 싶으면 `/everyday:weekly-report 설정`.

## 쓰는 법
- `/everyday:weekly-report`, 또는 "주간보고 정리해줘"

진행 순서:
1. 지난주 보고를 읽어서 이어지는 작업은 이름을 글자 그대로 유지
2. 이번 주 작업을 모아 몇 개의 작업 단위로 묶음
3. 업무 관리 도구에 안 남은 세션·작업을 보여주고 넣을지 물어본 뒤, 화면 밖 작업(미팅, 방문 등)을 추가로 물어봄
4. 초안 표를 보고 고칠 곳을 고침
5. 최종 초안을 제출 1건당 복붙 블록 하나로 출력하고 `~/.claude/workflow/weekly-reports/`에 저장

양식 규칙은 알아서 검사한다: 고를 수 있는 값, 합이 100이어야 하는 칸, 지난주보다 낮아지면 안 되는 진척률 등.
저장한 보고 파일은 직접 고쳤을 수 있으니 묻지 않고 덮어쓰지 않는다.
