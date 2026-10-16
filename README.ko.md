# claude-workflow-kit

[English](README.md) | 한국어

일하는 방식을 담은 Claude Code 스킬 모음. 메시지 정리, 할 일 관리, 티켓·주간보고·기획서 작성, 그리고 개발자라면 작업 착수부터 마무리까지 안전하게 처리해준다. 회사·개인 정보는 하나도 들어 있지 않다. 스킬을 처음 쓸 때 몇 가지를 물어본 뒤 각자 일하는 방식에 맞춰 동작한다. 밖으로 나가는 작업은 항상 확인을 받는다.

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

업데이트는 터미널에서 아래를 실행한 뒤 Claude Code를 다시 시작하면 된다 (바뀐 내용은 [CHANGELOG](CHANGELOG.md)).

```
claude plugin marketplace update claude-workflow-kit
claude plugin update everyday@claude-workflow-kit
claude plugin update dev@claude-workflow-kit   # dev를 설치했다면
```

처음이라면 `/everyday:doctor`를 한 번 실행하면 된다. 설정 상태를 점검하고, 아직 아무 설정이 없으면 한 번에 설정하자고 제안한다.

## 상황별로 고르기

스킬 이름을 외울 필요 없다. 평소 말투로 말해도 알아듣는다.

| 이럴 때 | 스킬 | 이렇게 말하기 |
|---|---|---|
| 아침에 뭐부터 할지 모르겠다 | wsid | 그냥 `/everyday:wsid`, 또는 "오늘 뭐하지" |
| 메시지·메일을 받았는데 어떻게 처리할지 모르겠다 | wsid | 붙여넣고 "이거 뭐임" |
| 할 일이 생겼다, 또는 끝냈다 | wsid | "이거 할 일에 넣어줘", "그거 끝났어" |
| 세션을 오가다 뭘 하던 중인지 잊었다 | waid | "여기서 뭐 하던 중이었지" |
| 티켓이나 버그 리포트를 써야 한다 | issue-writer | "이거 티켓 만들어줘", "버그 등록해줘: ..." |
| 주간보고 마감이다 | weekly-report | "주간보고 정리해줘" |
| 기능 기획서가 필요하다 | plan-doc | "이 기능 기획해줘: ..." |
| 뭔가 안 된다, 또는 처음 써본다 | doctor | "설정 점검", "왜 안 되지", 또는 `/everyday:doctor` |
| (개발) 새 작업을 받았다 | task-start | "PROJ-123 시작하자" |
| (개발) 코드는 다 짰고 올리고 싶다 | task-finish | "push 준비됐어" |
| (개발) QA에서 반려됐다 | qa-reject | "PROJ-123 QA에서 까임" |
| (개발) 화면을 만들거나 고친다 | ui-work | "설정 페이지에 삭제 확인 다이얼로그 추가해줘" |
| (개발) 제3자 시선의 리뷰를 받고 싶다 | outsider | "이 브랜치 외부 리뷰 받아봐" |

## 들어 있는 것

### everyday — 누구나

| 스킬 | 하는 일 | 설명 |
|---|---|---|
| `/everyday:wsid` | 붙여넣은 메시지·메일·요청을 분류해서 처리, 할 일·작업 기록 자동 관리, 빈손으로 부르면 오늘 할 일 브리핑 | [README](plugins/everyday/skills/wsid/README.ko.md) |
| `/everyday:waid` | 세션 여러 개를 동시에 돌릴 때, 이 세션에서 뭘 하던 중이었는지 요약 하나로 보여줌 | [README](plugins/everyday/skills/waid/README.ko.md) |
| `/everyday:issue-writer` | 요청·버그·막연한 아이디어를 업무 관리 도구용 이슈로 정리, 초안 승인 후에만 등록 | [README](plugins/everyday/skills/issue-writer/README.ko.md) |
| `/everyday:weekly-report` | 작업 기록·레포·업무 관리 도구에서 한 주 작업을 모아 팀 양식대로 보고 초안 작성 | [README](plugins/everyday/skills/weekly-report/README.ko.md) |
| `/everyday:plan-doc` | 개발에 바로 쓸 수 있는 기획서 작성. 화면별 상태 체크리스트, QA 시나리오, 미정 사항 TBD 표시 포함 | [README](plugins/everyday/skills/plan-doc/README.ko.md) |
| `/everyday:doctor` | 설정과 연결 상태를 점검하고 고치는 법을 알려줌, 처음이면 한 번에 설정 | [README](plugins/everyday/skills/doctor/README.ko.md) |

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

## 스킬별로 필요한 것

git 말고는 전부 선택. 연결이 없어도 스킬은 동작하고, 건너뛴 부분을 알려준다.

| 필요한 것 | 쓰는 스킬 | 없으면 |
|---|---|---|
| 추가로 필요한 것 없음 | waid, doctor, with-lock, push-guard | — |
| 업무 관리 도구 연결 (연결된 MCP 서버나 커넥터라면 뭐든: Jira, Linear, Notion, GitHub Issues 등) | wsid, issue-writer, weekly-report, task-start, task-finish, qa-reject | 내용을 붙여넣거나, 복사용 초안을 받음 |
| 문서 도구 커넥터 (구글 문서, Notion, Confluence 등) | wsid (온라인 기록 문서), plan-doc (그쪽에 문서 생성) | 로컬 파일로 진행 |
| git | task-start, task-finish, qa-reject, outsider (diff 리뷰), weekly-report (커밋 기록) | 개발 작업 스킬에는 필수 |
| 브라우저 도구 (예: Playwright MCP) | ui-work (화면 직접 확인), plan-doc (운영 중인 제품 둘러보기) | ui-work는 확인 못 한 부분을 알려줌 |
| macOS | wsid 아침 자동 브리핑만 | wsid 자체는 어디서나 동작 |

## 이렇게 쓴다

메시지 정리:

```
나:     (붙여넣기) "업체 견적 비교표 수정본 목요일까지 보내주실 수 있을까요?"
Claude: 업무 요청: 견적 비교표 수정본, 목요일 마감.
        할 일 추가: 업체 견적 비교표 수정본 보내기 (목요일까지)
        확인 답장 초안 써줄까?
```

개발 작업, 시작부터 마무리까지:

```
나:     PROJ-123 시작하자
Claude: PROJ-123: 주문 목록에 CSV 내보내기 추가.
        별도 워크트리에 feature/PROJ-123-csv-export 브랜치 생성 (upstream 확인 완료).
        작업 기록 열어둠. PROJ-123을 진행 중으로 바꿀까?
나:     응
        ... (작업 후) ...
나:     push 준비됐어
Claude: 리베이스, 검사 전부 통과, 커밋 완료.
        feature/PROJ-123-csv-export push 준비됨. 올릴까?
```

## 원칙

- 메시지 전송, 메일 발송, 티켓 등록, push 같은 외부 작업은 초안까지만 만들고 승인 후 실행한다.
- 회사마다 다른 값(업무 도구, 기록 위치 등)은 첫 실행 때 묻고 설정 파일에 저장한다.
- 스킬은 사용자가 쓰는 언어로 답한다. 한국어로 말하면 한국어로 답한다.

## 내 방식에 맞추기

공용 스킬이라 모든 사람에게 딱 맞지는 않는다. 원하지 않는 단계가 있거나, 빠뜨리거나, 실수하면 그냥 말하면 된다 ("요약 댓글은 달지 마", "커밋 전에 타입 검사도 항상 돌려", "배포 확인 안 했잖아"). 스킬이 이를 `~/.claude/workflow/rules/<스킬>.md`에 규칙으로 적고, 다음부터 자기 지침에 더해 그 규칙대로 동작한다. 키트를 업데이트해도 이 파일은 그대로 남는다. 다른 사람에게도 도움이 될 규칙은 `~/.claude/workflow/suggestions.md`에도 모아두니, 원할 때 한 번에 이슈로 보내면 된다. 단, 밖으로 나가는 작업 전에 확인받는 것만은 규칙으로도 끌 수 없다.

## 새 소식

[CHANGELOG.md](CHANGELOG.md) 참고.

## 라이선스

[MIT](LICENSE). 출처 표시만 남기면 자유롭게 쓰고 고쳐도 된다.
