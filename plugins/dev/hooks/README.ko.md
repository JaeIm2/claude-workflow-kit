# push-guard — git push 전에 매번 확인

[English](README.md) | 한국어

`dev` 플러그인에 들어 있는 훅. Claude가 `git push`가 들어간 Bash 명령을 실행하려고 하면, Claude Code가 멈추고 권한 확인 창을 띄운다. auto 모드에서도 승인하기 전에는 push되지 않는다. 다른 명령에는 영향 없음.

스킬이 아니라 훅이라 따로 부를 것이 없다. `dev` 플러그인을 켜면 바로 동작한다.

## 왜 필요한가
push는 조용히 되돌릴 수 없는 단계다. 이 가드가 생긴 계기: feature 브랜치를 `origin/develop`에서 만들면서 upstream이 그대로 `origin/develop`로 잡혀 있었고, 인자 없는 `git push` 한 번에 `develop`에 직접 들어갔다. "upstream으로 간다, `git branch -vv` 확인해라"라는 확인 창이 있으면 그 전에 잡힌다.

## 확인 창에 뜨는 내용
가장 위험한 것 하나를 골라 이유로 보여준다. 순서는 이렇다.

1. **강제 푸시** — `--force`, `-f`, `+브랜치` refspec. (리베이스한 feature 브랜치를 올릴 때 쓰는 `--force-with-lease`는 강제 푸시로 분류하지 않지만, 확인은 똑같이 묻는다.)
2. **보호 브랜치** — `main`, `master`, `develop`, `release` 브랜치를 대상으로 지정한 경우.
3. **대상 없음** — 그냥 `git push`나 `git push origin`. 현재 브랜치의 upstream으로 가는데, upstream이 `main`이나 `develop`이면 거기로 들어간다. `git branch -vv`로 확인할 것.
4. 그 외 — 대상을 보여주고 확인을 묻는다.

## 필요한 것
- `dev` 플러그인이 설치된 Claude Code (`/plugin install dev@claude-workflow-kit`)
- `sh`. `jq`가 있으면 쓰고, 없어도 가드는 동작한다 (판별만 조금 거칠어짐).

## 참고
- Claude가 Bash 도구로 실행하는 명령만 본다. 직접 터미널에서 친 push는 해당 없음.
- `git push`라는 글자로 판별한다. `git -C <폴더> push` 같은 형태는 잡지 못한다.
- 끄려면 `/plugin`에서 플러그인을 끄거나 `claude plugin disable dev@claude-workflow-kit` 실행.
