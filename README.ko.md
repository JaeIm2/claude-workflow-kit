# claude-workflow-kit

[English](README.md) | 한국어

일하는 방식을 담은 Claude Code 스킬 모음.
회사·개인 정보 없이 만들었고, 처음 실행할 때 몇 가지를 물어본 뒤 각자 환경에 맞춰 동작한다.

## 설치

Claude Code에서 아래 두 줄을 실행한다.

```
/plugin marketplace add JaeIm2/claude-workflow-kit
/plugin install everyday@claude-workflow-kit
```

개발자라면 `dev` 플러그인도 같이 설치한다.

```
/plugin install dev@claude-workflow-kit
```

설치 범위(나만 / 이 프로젝트만)를 고르는 창이 뜨면 고르면 된다. 이미 열려 있던 세션이면 `/reload-plugins`.

터미널에서 설치해도 된다.

```
claude plugin marketplace add JaeIm2/claude-workflow-kit
claude plugin install everyday@claude-workflow-kit
claude plugin install dev@claude-workflow-kit
```

업데이트는 `/plugin marketplace update claude-workflow-kit`.

## 들어 있는 것

### everyday — 누구나

| 스킬 | 하는 일 | 설명 |
|---|---|---|
| `/everyday:wsid` | 붙여넣은 메시지·메일·요청을 분류해서 처리, 할 일·작업 기록 자동 관리, 빈손으로 부르면 오늘 할 일 브리핑 | [README](plugins/everyday/skills/wsid/README.ko.md) |
| `/everyday:waid` | 세션 여러 개를 동시에 돌릴 때, 이 세션에서 뭘 하던 중이었는지 요약 하나로 보여줌 | [README](plugins/everyday/skills/waid/README.ko.md) |
| `/everyday:issue-writer` | 요청·버그·막연한 아이디어를 업무 관리 도구용 이슈로 정리, 초안 승인 후에만 등록 | [README](plugins/everyday/skills/issue-writer/README.ko.md) |
| `/everyday:weekly-report` | 작업 기록·레포·업무 관리 도구에서 한 주 작업을 모아 팀 양식대로 보고 초안 작성 | [README](plugins/everyday/skills/weekly-report/README.ko.md) |
| `/everyday:plan-doc` | 개발에 바로 쓸 수 있는 기획서 작성. 화면별 상태 체크리스트, QA 시나리오, 미정 사항 TBD 표시 포함 | [README](plugins/everyday/skills/plan-doc/README.ko.md) |

### dev — 개발자

| 스킬 | 하는 일 | 설명 |
|---|---|---|
| `/dev:task-start` | 작업 착수: 항목 읽기, 새 브랜치·워크트리 안전하게 만들기, 작업 기록 열기 | [README](plugins/dev/skills/task-start/README.ko.md) |
| `/dev:task-finish` | 작업 마무리: 검사, 커밋, 승인 후 push·PR, 배포 확인 후 QA 전달 | [README](plugins/dev/skills/task-finish/README.ko.md) |
| `/dev:qa-reject` | QA 반려 대응: 최신 반려 사유 확인, 재현, 수정, 다시 전달 | [README](plugins/dev/skills/qa-reject/README.ko.md) |
| `/dev:ui-work` | 레포 UI 규칙 문서대로 작업(없으면 초안 작성), 구조 먼저 확인, 끝나기 전 브라우저로 직접 확인 | [README](plugins/dev/skills/ui-work/README.ko.md) |
| `/dev:outsider` | 나와 내 지침을 전혀 모르는 격리된 읽기 전용 Claude에게 리뷰 받기 | [README](plugins/dev/skills/outsider/README.ko.md) |
| `/dev:with-lock` | 빌드·테스트·린트 같은 무거운 명령을 컴퓨터 전체 세션에서 한 번에 하나씩 실행 | [README](plugins/dev/skills/with-lock/README.ko.md) |
| push-guard (훅) | `git push` 전에 항상 확인을 받음 | [README](plugins/dev/hooks/README.ko.md) |

## 원칙

- 메시지 전송, 메일 발송, 티켓 등록, push 같은 외부 작업은 초안까지만 만들고 승인 후 실행한다.
- 회사마다 다른 값(업무 도구, 기록 위치 등)은 첫 실행 때 묻고 설정 파일에 저장한다.
- 스킬은 사용자가 쓰는 언어로 답한다. 한국어로 말하면 한국어로 답한다.

## 라이선스

[MIT](LICENSE). 출처 표시만 남기면 자유롭게 쓰고 고쳐도 된다.
