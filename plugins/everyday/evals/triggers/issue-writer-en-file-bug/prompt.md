---
description: should trigger issue-writer
tags: [issue-writer, positive, trigger]
plugins: ["../../..", "../../../../dev"]
runs: 1
max_turns: 3
timeout_seconds: 120
allowed_tools: [Skill]
---

file a bug: export to CSV drops the last row when the table has more than 1000 rows
