# outsider — a reviewer who doesn't know you

English | [한국어](README.ko.md)

Your own Claude session knows your instructions, your memory, and everything you've explained. That's useful, but it also means it fills in gaps the way you would. This skill runs a second, isolated Claude that knows none of that and reviews your code or planning document cold. If a choice only makes sense with background that isn't written down, it says so.

**When to use:** Before handing code or a plan to someone else, you want to know whether it makes sense to a reader with no background.

**Try saying:**
- "Get an outside review of this branch"
- "Review this with fresh eyes" + a file or folder
- "Outsider review of docs/spec.md"

**Needs:** the `claude` CLI (recent version) and git for diff reviews. macOS or Linux.

## Requirements
- Claude Code (the `claude` CLI on your `PATH`, recent enough to have `--safe-mode` and `--restricted`; check with `claude --help`)
- `git` (for reviewing a diff)
- macOS or Linux with bash

## Install
1. Run these two lines in Claude Code (full instructions in the [root README](../../../../README.md))
   ```
   /plugin marketplace add JaeIm2/claude-workflow-kit
   /plugin install dev@claude-workflow-kit
   ```
2. That's it. If you've run another skill from this kit, the review is written in the language saved in `~/.claude/workflow/config.md`; otherwise in English.

## Usage
- `/dev:outsider` + "review this branch" — reviews the current branch's changes
- `/dev:outsider` + a file or folder — code review
- `/dev:outsider` + a plan, spec, or design doc — plan review
- Or just say "get an outside review of this"

Claude shows you the review exactly as the outsider wrote it, then (separately) its own take if it has one. It doesn't start fixing anything until you decide.

Reviews are also saved to `~/.claude/outsider/reviews/`.

## How it's isolated
- `--safe-mode`: no CLAUDE.md, memory, skills, hooks, plugins, or custom agents
- `--restricted` and only the Read, Grep, and Glob tools: it can read files in the work folder and nothing else; it can't run commands or edit anything
- `--strict-mcp-config`: no MCP servers
- It receives only the paths or the diff. No intent, no background.

## Running it yourself
```
bash <plugin folder>/skills/outsider/outsider.sh code src/
bash <plugin folder>/skills/outsider/outsider.sh code --diff origin/main
bash <plugin folder>/skills/outsider/outsider.sh plan docs/spec.md
```
Add `--model <alias>` to pick the reviewer model.
