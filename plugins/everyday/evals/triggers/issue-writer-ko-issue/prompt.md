---
description: should trigger issue-writer
tags: [issue-writer, positive, trigger]
plugins: ["../../..", "../../../../dev"]
runs: 1
max_turns: 3
timeout_seconds: 120
allowed_tools: [Skill]
---

이슈 써줘. 검색창에 공백만 넣고 엔터 치면 500 에러 남
