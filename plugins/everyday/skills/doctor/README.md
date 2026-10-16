# doctor — setup health check

English | [한국어](README.ko.md)

A Claude Code skill that checks whether claude-workflow-kit is set up and working, and tells you for each item: OK, the problem, and how to fix it. It only reads. It changes your settings or rules only when you say yes to a fix.

## Requirements
- Claude Code with the `everyday` plugin installed (see the [root README](../../../../README.md))

## Usage
- `/everyday:doctor`, "check my setup", "why isn't this working" — full check
- "Why didn't the weekly-report skill trigger?" — compares what you typed with that skill's trigger phrases and tells you what works
- "Make a report I can send to someone" — the same check as a copy-ready summary with names, paths, internal addresses, and tokens removed. It is never sent anywhere; you copy it yourself

## What it checks
1. **Shared settings** (`~/.claude/workflow/config.md`) — the Common items are there with their English labels, and the sections of the skills you've installed look complete. If nothing is set up yet, it offers to set everything up in one go
2. **Connected tools** — your work tracker and notes tools are available in this session, and every tool the morning briefing may use only reads
3. **Work records** — the to-do list and notes folder exist and are readable
4. **Personal rules** — how many rules each skill has, rules that contradict each other or try to skip approval, and how many suggestions are waiting to be sent
5. **Morning briefing** (macOS, if set up) — script in place, scheduled job loaded, `YOUR_NAME` replaced, result of the last run
6. **dev plugin** (if installed) — the push confirmation hook is active, you're logged in to your git host's CLI, repo paths exist, worktree setup is safe
7. **Plugin version** — installed vs latest, and the commands to update

## Notes
- It never installs, updates, logs in, or loads anything for you. It gives you the command to run.
- When a phrase you used should have triggered a skill but didn't, it adds that phrase to `~/.claude/workflow/suggestions.md`, so you can send it in with your other suggestions.
