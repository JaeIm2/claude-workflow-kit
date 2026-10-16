---
name: doctor
description: Use when the user wants to check that claude-workflow-kit is set up and working, or something in it isn't behaving — "/everyday:doctor", "doctor", "check my setup", "is everything set up right", "why isn't this working", "why didn't the skill trigger", "the briefing didn't run", "왜 안 되지", "설정 점검", "설정 확인해줘", "스킬이 안 떠", "브리핑이 안 왔어". Runs a read-only health check of the shared settings, connected tools, work records, personal rules, morning briefing, dev plugin, and plugin version, and reports OK / problem / how to fix for each. Also for "why didn't skill X trigger?" and for a diagnostic summary to share with someone else.
---

# doctor — setup health check

Check the kit's setup item by item and report what is fine, what is broken, and how to fix it. **Read-only**: the only writes allowed are (a) settings or rules files when the user agrees to set up or fix something, and (b) appending to `~/.claude/workflow/suggestions.md`.

**Language:** Always talk to the user in the language they use. Write the report in that language too.

## Personal rules (always, before anything else in this skill)

This skill is shared, so each user shapes it with their own rules. Read `~/.claude/workflow/rules/doctor.md` if it exists and follow it on top of this file. Where the two conflict, the personal rule wins, with one exception: anything that leaves the machine (sending, posting, creating or editing items in a tracker, pushing) still waits for approval. If a rule asks to skip that approval, keep asking and say why.

Add a rule when the user:
- points out a mistake or something missed ("you forgot ...", "that's wrong") → under `## Avoid`
- says they don't want a step ("don't ...", "skip ...", "stop ...") → under `## Skip`
- wants something extra every time ("always ...", "also ...") → under `## Add`

Write one line in general terms, then ` — why: <reason or what happened, a few words> (YYYY-MM-DD)`. If the rule holds in only one repo or project, start it with `[<repo or project name>]` and apply it only there. Create the file with those three headings if it doesn't exist. If an existing line already covers it, update that line instead of adding another. Don't record one-offs ("just this time"); if unsure whether it should be permanent, ask. Announce each change in one line: `Rule added: ...`.

If a rule looks useful for everyone, not just this user, also append it to `~/.claude/workflow/suggestions.md` (skill name, the rule, why, date) and say so in one line. Don't open an issue on your own; when the user wants to send the collected suggestions, draft one issue for https://github.com/JaeIm2/claude-workflow-kit/issues from that file, and the user posts it.

## 0. Pick the mode

- **"Why didn't skill X trigger?"** → section 3.
- **"Make a report I can send to someone"** → run the checks, then section 4.
- **Anything else** → run all checks in section 1 and report in the section 2 format.

Run `claude plugin list` once first: it shows which kit plugins are installed (`everyday@claude-workflow-kit`, `dev@claude-workflow-kit`), their `Version`, and `Status`. Installed plugin folders are listed in `~/.claude/plugins/installed_plugins.json`; read other skills' SKILL.md from there when you need them.

## 1. Checks

Skip a check whose prerequisite isn't there and mark it "skipped" with the reason. Never fix anything during the checks; collect fixes and offer them at the end.

1. **Shared settings** — `~/.claude/workflow/config.md` exists and has `## Common` with `Language`, `Work tracker` (plus its `In progress` and `Recently updated` searches when a tracker is connected), `Personal notes documents`, `Work records location`, `Repos`, `Briefing read-only tools`. Headings and labels must be in English exactly as written; a translated or misspelled label counts as missing, because other skills and the briefing script look them up by name. For each installed skill that keeps its own section (`## dev`, `## ui-work`, `## weekly-report`, `## issue-writer`, `## plan-doc`), compare its labels with the format block in that skill's SKILL.md (for `## dev`, the dev plugin's `skills/task-start/setup.md`). A missing section is not a problem, just "asked on first use".
   - **File missing or Common empty** → offer: "Set up everything now in one go?" If yes, read `${CLAUDE_PLUGIN_ROOT}/skills/wsid/SKILL.md` and ask the Common items exactly as /everyday:wsid's first-run setup does, then, if dev is installed, the `## dev` items as the dev plugin's `skills/task-start/setup.md` does. Other skills' sections are asked on their first use. Then continue with the remaining checks.
2. **Connected tools** — the work tracker in Common, and any tool recorded for a readable notes document, is actually available in this session (including tools listed only by name as deferred). If it is, make one small read call (current user, or one search) to confirm it responds. Every name in `Briefing read-only tools` must exist in this session under that exact full name, and must only read (search, list, get, read). Flag any that create, edit, delete, send, or post: the morning briefing runs with those tools allowed. Fix for a missing tool: connect that service's MCP server or connector, or correct the name; then `/everyday:wsid settings`.
3. **Work records** — the `Work records location` folder exists; `todo.md` and `notes/` are there and readable. Absent `todo.md` or `notes/` is "not created yet", not a problem.
4. **Personal rules** — list `~/.claude/workflow/rules/*.md` with the number of lines under `## Skip`, `## Add`, `## Avoid` in each. Flag rules that contradict each other (same skill or across skills, e.g. one says always do X, another says skip X) and rules that try to skip approval for anything leaving the machine: those are never applied, and say so. If `~/.claude/workflow/suggestions.md` exists, give its entry count and offer to draft the issue as the Personal rules section describes.
5. **Morning briefing** (macOS, only if `~/Library/LaunchAgents/morning-briefing.plist` or `~/.claude/scripts/morning-briefing.sh` exists) — the script exists at `~/.claude/scripts/morning-briefing.sh`; the plist no longer contains `YOUR_NAME` and its script path matches this home folder; `launchctl list | grep morning-briefing` shows the job loaded; the last lines of `~/.claude/briefings/run.log` end in `ok` (report the date of the last `ok` and any `FAIL` after it; for a failure, show the error lines just above it). Fixes are the steps in the wsid README's morning briefing section.
6. **dev plugin** (only if installed)
   - **push-guard** — dev shows `Status: enabled`; `disableAllHooks` is not `true` in `~/.claude/settings.json` or this project's `.claude/settings.json` / `.claude/settings.local.json`. Test the hook script without pushing, by feeding it a fake event (the command text is split so this check itself doesn't trip the hook): `printf '{"tool_input":{"command":"git pu%s"}}' sh | sh <dev plugin folder>/hooks/push-guard.sh` must print `"permissionDecision":"ask"`. Note whether `jq` is installed (optional; without it the guard is coarser). Tell the user they can also type `/hooks` and see it listed under PreToolUse as coming from the dev plugin.
   - **Git host login** — per `## dev` `Git hosting`: GitHub → `gh auth status`, GitLab → `glab auth status`, otherwise the recorded MCP tool is in this session. The logged-in host must match the host in each repo's `git -C <repo> remote get-url origin`.
   - **Repos** — every path in Common `Repos` and every `- Repo:` in `## dev` exists and is a git repo (`git -C <path> rev-parse --git-dir`). Flag repos in one list but not the other.
   - **Worktrees** — if `Worktrees: yes`, the worktree folder is git-ignored in each repo (`git -C <repo> check-ignore -q .worktrees` for the default location), and no branch in `git -C <repo> branch -vv` tracks the repo's `Base branch` or main/develop unless it is that branch (that's how a push lands on the base branch).
7. **Plugin version** — installed `Version` from `claude plugin list` vs the latest: read `plugins/<plugin>/.claude-plugin/plugin.json` in the marketplace copy under `~/.claude/plugins/marketplaces/` (as of the last refresh), or fetch `https://raw.githubusercontent.com/JaeIm2/claude-workflow-kit/main/plugins/<plugin>/.claude-plugin/plugin.json` read-only if web fetch is available. If neither works, say "latest version unknown". Don't run the update yourself; show, to run in a terminal: `claude plugin marketplace update claude-workflow-kit`, then `claude plugin update <plugin>@claude-workflow-kit` for each installed plugin, then restart Claude Code.

## 2. Report format

One line per check; add a `Fix:` line under each problem. Nothing else.

```
## Setup check YYYY-MM-DD
- OK — Shared settings: Common complete; dev, weekly-report sections present
- Problem — Connected tools: `mcp__tracker__search` not available in this session
  Fix: connect the tracker's MCP server, then `/everyday:wsid settings`
- Skipped — Morning briefing: not set up
Result: 4 OK, 1 problem, 2 skipped
```

Check the counts match the lines. After the report, offer the fixes that touch settings or rules ("Fix these now?") and apply only what the user agrees to. Fixes outside those files (installing, logging in, `launchctl load`) are commands for the user to run.

## 3. "Why didn't skill X trigger?"

1. Ask what the user typed, word for word, if they haven't said.
2. Check the skill's plugin is installed and enabled (`claude plugin list`). If not, that's the cause.
3. Read the skill's `description` in its installed SKILL.md and compare it with what they typed. Say why it didn't match in one line, give a phrase from the description that works, and remind them `/<plugin>:<skill>` always works.
4. If what they typed is a natural way to ask that the description doesn't cover, it's a real gap: append it to `~/.claude/workflow/suggestions.md` (skill name, the missing trigger phrase, why, date) and say so in one line.

## 4. Report for someone else

Produce the section 2 report as one copy-ready plain-text block, plus OS, `claude --version`, and kit plugin versions. Strip everything personal or company-specific:
- Paths: only `~`-relative, and replace folder names below `~` that could identify someone (repos, work folders) with placeholders like `~/<repo 1>`.
- No names, emails, account or login names, tokens, project keys, item numbers, or internal hostnames and URLs. Name the service type only ("Jira, connected"), and replace MCP server names that aren't a public service's name with `<tracker server>`.
- No rule text or suggestion text, only counts.

Read the block once more for anything identifying before showing it. Never send, post, or upload it; the user copies it.

## Cautions

- Don't change, reformat, or "tidy" any file during the checks. Problems found in todo.md or notes are reported, not fixed.
- Never run `git push`, `launchctl load`, install, update, or login commands; give them to the user.
