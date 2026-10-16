---
description: should trigger qa-reject
tags: [positive, qa-reject, task-start, trigger]
plugins: ["../../..", "../../../../everyday"]
runs: 1
max_turns: 3
timeout_seconds: 120
allowed_tools: [Skill]
---

QA bounced PROJ-55 back: the date picker still shows the wrong timezone. check the reject reason and fix it
