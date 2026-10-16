# waid — 이 세션에서 뭐 하고 있었지?

[English](README.md) | 한국어

Claude Code 세션을 여러 개 동시에 돌리다 헷갈릴 때 쓰는 스킬. 아무 세션에서 `/everyday:waid`를 입력하면 그 세션이 뭘 하던 중이었는지, 어디까지 했는지, 다음에 뭘 할지, 실제 git·백그라운드 작업 상태를 짧게 요약해준다. 요약만 하고 끝난다. 다음에 뭘 할지는 직접 정한다.

## 필요한 것
- Claude Code

설정 없음. `~/.claude/workflow/config.md`를 쓰지 않는다.

## 설치
Claude Code에서 아래 두 줄 실행 (자세한 설치 방법은 [루트 README](../../../../README.ko.md))
```
/plugin marketplace add JaeIm2/claude-workflow-kit
/plugin install everyday@claude-workflow-kit
```

## 쓰는 법
- `/everyday:waid`, 또는 "여기서 뭐 하던 중이었지?", "어디까지 했지?"

출력 예시:
```
## my-app — feature/login-form

**하던 일**: 로그인 폼 유효성 검사 (PROJ-123)
**진행 상황**: 이메일 검사 완료, 비밀번호 규칙은 하다 만 상태
**다음 할 일**: 비밀번호 강도 안내 문구 추가 후 테스트 실행
**대기/블로커**: 디자이너에게 에러 색상 문의, 아직 답 없음

**실제 상태**
- git: feature/login-form, 파일 2개 수정, 커밋 안 함
- 백그라운드: 3000번 포트 개발 서버
```

세션을 한눈에 구분할 수 있게 프로젝트 이름이 항상 맨 위에 온다. 컨텍스트가 압축된 세션이면 불확실한 부분은 불확실하다고 표시한다.
