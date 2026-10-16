# claude-workflow-kit

일하는 방식을 담은 Claude Code 스킬 모음.
회사·개인 정보 없이 만들었고, 처음 실행할 때 몇 가지를 물어본 뒤 각자 환경에 맞춰 동작한다.

## 설치

Claude Code에서 아래 두 줄을 실행한다.

```
/plugin marketplace add JaeIm2/claude-workflow-kit
/plugin install everyday@claude-workflow-kit
```

설치 범위(나만 / 이 프로젝트만)를 고르는 창이 뜨면 고르면 된다. 이미 열려 있던 세션이면 `/reload-plugins`.

터미널에서 설치해도 된다.

```
claude plugin marketplace add JaeIm2/claude-workflow-kit
claude plugin install everyday@claude-workflow-kit
```

업데이트는 `/plugin marketplace update claude-workflow-kit`.

## 들어 있는 것

### everyday — 누구나

| 스킬 | 하는 일 | 설명 |
|---|---|---|
| `/everyday:wsid` | 붙여넣은 메시지·메일·요청을 분류해서 처리, 할 일·작업 기록 자동 관리, 빈손으로 부르면 오늘 할 일 브리핑 | [README](plugins/everyday/skills/wsid/README.md) |

### 준비 중

- everyday: 이슈 작성, 주간보고, 기획서 작성
- dev (개발자용): 작업 착수·마무리, QA 반려 대응, UI 작업, 외부 리뷰, push 확인, 무거운 명령 순서 대기

## 원칙

- 메시지 전송, 메일 발송, 티켓 등록, push 같은 외부 작업은 초안까지만 만들고 승인 후 실행한다.
- 회사마다 다른 값(업무 도구, 기록 위치 등)은 첫 실행 때 묻고 설정 파일에 저장한다.

## 라이선스

[MIT](LICENSE). 출처 표시만 남기면 자유롭게 쓰고 고쳐도 된다.
