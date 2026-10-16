# outsider — 나를 모르는 리뷰어

[English](README.md) | 한국어

평소 쓰는 Claude 세션은 내 지침, 메모리, 그동안 설명한 배경을 다 알고 있다. 편하지만, 그만큼 빈 곳을 내 방식대로 채워서 읽는다. 이 스킬은 그런 걸 하나도 모르는 별도의 격리된 Claude를 띄워서 코드나 기획 문서를 맨눈으로 리뷰하게 한다. 적혀 있지 않은 배경이 있어야만 이해되는 선택이 있으면 그걸 짚어준다.

**언제 쓰나:** 코드나 기획서를 남에게 넘기기 전에, 배경을 모르는 사람이 봐도 이해되는지 알고 싶을 때.

**이렇게 말해보기:**
- "이 브랜치 외부 리뷰 받아봐"
- "제3자 시선으로 봐줘" + 파일이나 폴더
- "모르는 사람이 보면 어때"

**준비물:** `claude` CLI (최신 버전), diff 리뷰라면 git. macOS 또는 Linux.

## 필요한 것
- Claude Code (`claude` CLI가 `PATH`에 있어야 하고, `--safe-mode`와 `--restricted`를 지원하는 버전이어야 함. `claude --help`로 확인)
- `git` (diff 리뷰할 때)
- bash가 있는 macOS 또는 Linux

## 설치
1. Claude Code에서 아래 두 줄 실행 (자세한 설치 방법은 [루트 README](../../../../README.ko.md))
   ```
   /plugin marketplace add JaeIm2/claude-workflow-kit
   /plugin install dev@claude-workflow-kit
   ```
2. 끝. 이 키트의 다른 스킬을 써본 적이 있으면 `~/.claude/workflow/config.md`에 저장된 언어로, 아니면 영어로 리뷰가 나온다.

## 쓰는 법
- `/dev:outsider` + "이 브랜치 리뷰해줘" — 현재 브랜치의 변경분 리뷰
- `/dev:outsider` + 파일이나 폴더 — 코드 리뷰
- `/dev:outsider` + 기획서·스펙·설계 문서 — 기획 리뷰
- 그냥 "외부 리뷰 받아봐", "제3자 시선으로 봐줘"라고 해도 된다

Claude는 아웃사이더가 쓴 리뷰를 그대로 보여주고, 자기 의견이 있으면 따로 구분해서 덧붙인다. 무엇을 고칠지 정하기 전에는 손대지 않는다.

리뷰는 `~/.claude/outsider/reviews/`에도 저장된다.

## 어떻게 격리하나
- `--safe-mode`: CLAUDE.md, 메모리, 스킬, 훅, 플러그인, 커스텀 에이전트 전부 끔
- `--restricted` + Read·Grep·Glob 도구만 허용: 작업 폴더 안 파일 읽기만 가능, 명령 실행이나 수정 불가
- `--strict-mcp-config`: MCP 서버 끔
- 넘기는 건 경로나 diff뿐. 의도나 배경 설명은 일부러 안 넘긴다.

## 직접 실행
```
bash <플러그인 폴더>/skills/outsider/outsider.sh code src/
bash <플러그인 폴더>/skills/outsider/outsider.sh code --diff origin/main
bash <플러그인 폴더>/skills/outsider/outsider.sh plan docs/spec.md
```
`--model <별칭>`을 붙이면 리뷰 모델을 고를 수 있다.
