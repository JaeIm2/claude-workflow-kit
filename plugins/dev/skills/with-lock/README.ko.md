# with-lock — 여러 Claude Code 세션의 무거운 작업을 한 번에 하나씩

[English](README.md) | 한국어

한 머신에서 Claude Code 세션을 여러 개 띄워두면, 두 세션이 동시에 전체 빌드나 테스트를 돌리다가 메모리가 바닥나는 일이 생긴다. 이 스킬은 무거운 명령(빌드·테스트·타입체크·전체 린트)을 작은 락 스크립트로 감싸게 해서, 동시에 돌지 않고 차례로 줄 서게 만든다.

## 필요한 것
- Claude Code
- macOS 또는 Linux (기본 bash만 있으면 됨, 추가 도구 없음)

## 설치
1. Claude Code에서 아래 두 줄 실행 (자세한 설치 방법은 [루트 README](../../../../README.ko.md))
   ```
   /plugin marketplace add JaeIm2/claude-workflow-kit
   /plugin install dev@claude-workflow-kit
   ```
2. 끝. 첫 실행 질문 없음.

## 쓰는 법
- 평소처럼 "빌드 돌려", "테스트 돌려"라고 하면 Claude가 알아서 락으로 감싸서 실행한다.
- 직접 부를 수도 있다: `/dev:with-lock yarn build`

이렇게 보인다:
- 다른 세션이 쉬고 있으면 바로 실행된다.
- 다른 세션이 락을 잡고 있으면 `[with-lock] another session is running a heavy task, waiting...`이 뜨고, 앞 작업이 끝나면 시작한다.

Claude는 이런 명령을 긴 타임아웃(또는 백그라운드)으로 돌리고, 테스트 러너 워커 수를 2개로 제한한다.

## 세부 사항
- 락 위치: `~/.claude/locks/heavy-task.lock` (주인 프로세스 ID가 든 폴더). 임시 폴더가 아니라 홈 아래에 두는 이유는, 샌드박스 세션마다 임시 폴더 경로가 다를 수 있어서다.
- 세션이 비정상 종료돼서 남은 락은 자동으로 정리된다.
- dev 서버처럼 계속 떠 있는 명령은 감싸지 않는다. 락을 영원히 잡고 있게 되기 때문.
