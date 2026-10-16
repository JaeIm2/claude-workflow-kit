---
description: should not trigger ui-work
tags: [negative, trigger, ui-work]
plugins: ["../../..", "../../../../everyday"]
runs: 1
max_turns: 3
timeout_seconds: 120
allowed_tools: [Skill]
---

API 응답 타입 정의만 수정해줘. UserDto에 createdAt: string 필드 추가
