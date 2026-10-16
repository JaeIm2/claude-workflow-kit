---
name: outsider
description: Use when the user wants a second opinion from a reviewer who knows nothing about them, their instructions, or the background — "/dev:outsider", "get an outside review", "outsider review", "review this with fresh eyes", "외부 리뷰", "아웃사이더 리뷰", "제3자 시선으로 봐줘", "모르는 사람이 보면 어때". Reviews code (files, folders, or the current branch's diff) or a planning document (plan, spec, design doc, proposal) through a separate, isolated, read-only Claude run.
---

# outsider — review by someone who doesn't know you

Runs a separate Claude in headless mode with every customization turned off: no CLAUDE.md, no memory, no skills, no hooks, no plugins, no MCP servers, and only the Read, Grep, and Glob tools, confined to the work folder. It gets only the paths (or the diff) to review, never the intent or background. If something only makes sense with context the author has in their head, the outsider calls it out.

**Language:** Always talk to the user in the language they use. The review itself is written in the `Language` from `~/.claude/workflow/config.md` (`## Common`), or English if that file doesn't exist.

## Personal rules (always, before anything else in this skill)

This skill is shared, so each user shapes it with their own rules. Read `~/.claude/workflow/rules/outsider.md` if it exists and follow it on top of this file. Where the two conflict, the personal rule wins, with one exception: anything that leaves the machine (sending, posting, creating or editing items in a tracker, pushing) still waits for approval. If a rule asks to skip that approval, keep asking and say why.

Add a rule when the user:
- points out a mistake or something missed ("you forgot ...", "that's wrong") → under `## Avoid`
- says they don't want a step ("don't ...", "skip ...", "stop ...") → under `## Skip`
- wants something extra every time ("always ...", "also ...") → under `## Add`

Write one line in general terms, then ` — why: <reason or what happened, a few words> (YYYY-MM-DD)`. If the rule holds in only one repo or project, start it with `[<repo or project name>]` and apply it only there. Create the file with those three headings if it doesn't exist. If an existing line already covers it, update that line instead of adding another. Don't record one-offs ("just this time"); if unsure whether it should be permanent, ask. Announce each change in one line: `Rule added: ...`.

If a rule looks useful for everyone, not just this user, offer to draft an issue for the kit at https://github.com/JaeIm2/claude-workflow-kit/issues. The user posts it.

## When to use

- The user asks for an outside, fresh-eyes, or third-party review.
- Before handing a plan or a change to someone else, when the user wants to know whether it stands on its own.

Don't use it as a replacement for a normal review in this session; it's a deliberate second opinion.

## How to run

Code (files or folders):
```
bash "${CLAUDE_PLUGIN_ROOT}/skills/outsider/outsider.sh" code <file|dir>...
```

Code (changes on the current branch, from the repo root or any folder inside it):
```
bash "${CLAUDE_PLUGIN_ROOT}/skills/outsider/outsider.sh" code --diff [base]
```
Without `base`, it diffs against the merge-base with origin's default branch (falls back to `origin/main`, `origin/master`, then `HEAD`).

Planning document:
```
bash "${CLAUDE_PLUGIN_ROOT}/skills/outsider/outsider.sh" plan <doc>...
```

Option: `--model <alias>` picks the reviewer model; default is the CLI's default.

- A review takes a few minutes. Set the Bash timeout to the maximum (600000 ms) or run it in the background.
- Don't add explanations, intent, or background to the call. Passing only paths is the point.
- The review is printed and also saved to `~/.claude/outsider/reviews/<timestamp>-<mode>-<folder>.md`.

## Passing the result back

1. **Show the review verbatim**, as the outsider wrote it. Don't summarize, re-rank, soften, or drop findings, and don't mix your own opinions into it.
2. After the verbatim review, you may add a short, clearly separated note of your own (for example, which findings you think are wrong because of context the outsider didn't have, or which you'd fix first). Label it as your view.
3. Don't start fixing anything until the user decides what to act on.
4. Mention where the review was saved.

## Requirements

- The `claude` CLI on `PATH`, recent enough to support `--safe-mode` and `--restricted` (check with `claude --help`).
- `git` for `--diff`.
