---
name: task-start
description: Use when the user starts work on a new task or ticket from their work tracker — "start PROJ-123", "I got assigned this ticket", "let's do PROJ-123", a bare item key, or a task with no existing work notes. "PROJ-123 ㄱㄱ", "이 티켓 시작하자", "이 티켓 할당받음", "분석 후 진행해줘". Sets up an isolated branch and worktree, moves the item to in progress (after approval), and opens a work note. Not for QA rejects (use /dev:qa-reject). Also for "/dev:task-start settings" or "/dev:task-start 설정", which edits the settings shared by all dev skills.
---

# Task start

The fixed routine for starting a new task, so the user never has to type "separate worktree, new branch, ..." again. `/dev:task-finish` is the other end.

**Language:** Always talk to the user in the language they use. Write work records in that language too. Tracker comments use the `Tracker comment language` from settings.

## Personal rules (always, before anything else in this skill)

This skill is shared, so each user shapes it with their own rules. Read `~/.claude/workflow/rules/task-start.md` if it exists and follow it on top of this file. Where the two conflict, the personal rule wins, with one exception: anything that leaves the machine (sending, posting, creating or editing items in a tracker, pushing) still waits for approval. If a rule asks to skip that approval, keep asking and say why.

Add a rule when the user:
- points out a mistake or something missed ("you forgot ...", "that's wrong") → under `## Avoid`
- says they don't want a step ("don't ...", "skip ...", "stop ...") → under `## Skip`
- wants something extra every time ("always ...", "also ...") → under `## Add`

Write one line in general terms, then ` — why: <reason or what happened, a few words> (YYYY-MM-DD)`. If the rule holds in only one repo or project, start it with `[<repo or project name>]` and apply it only there. Create the file with those three headings if it doesn't exist. If an existing line already covers it, update that line instead of adding another. Don't record one-offs ("just this time"); if unsure whether it should be permanent, ask. Announce each change in one line: `Rule added: ...`.

If a rule looks useful for everyone, not just this user, offer to draft an issue for the kit at https://github.com/JaeIm2/claude-workflow-kit/issues. The user posts it.

## 0. Check settings (always first)

Read `~/.claude/workflow/config.md`. If any Common item (`Work tracker`, `Repos`, `Work records location`) or any `## dev` item is missing, or the user asked for settings, follow `${CLAUDE_PLUGIN_ROOT}/skills/task-start/setup.md`, then continue. That file also defines the work records format used below.

## Workflow

1. **Check existing notes** — if `<Work records location>/notes/<task>.md` exists, this is a resume, not a new start. Read it, check it against the real git and worktree state, and continue from its next steps. If the note's status is done and the item came back from QA, switch to `/dev:qa-reject`.
2. **Read the item** — with the tracker's tools, read the item's title, description, and comments, plus any sub-items and linked items. (Not connected → ask the user to paste them.) Report what you understood in one line.
3. **Check prerequisites**
   - **Depends on someone else's work** (another team, another repo): check the linked item's status. At or past the `deployed to test` status means it is ready in the test environment. Before that, ask the user: "<item> isn't deployed yet. Go ahead anyway?"
   - **Pick the repo** from each repo's `For` setting. If it's ambiguous, ask.
4. **Set up the workspace** in that repo
   - Run `git worktree list` first. If a worktree for this task already exists, reuse it.
   - `git fetch origin`, then create a new branch named by the repo's `Branch naming` rule, from `origin/<Base branch>`. Always a new branch; never work directly on the base branch or another protected branch.
   - **Worktrees: yes** → use the session's native worktree tool if there is one; otherwise `git worktree add --no-track -b <branch> <worktree path> origin/<Base branch>`. Do the task's work there, not in the main checkout: other sessions share that checkout, and changing its branch or dependencies breaks them.
   - **Worktrees: no** → `git switch --no-track -c <branch> origin/<Base branch>` in the repo, after checking it has no uncommitted changes. If it does, stop and ask.
   - **Right after creating the branch, run `git branch -vv` and check its upstream.** If it tracks the base branch (or any branch other than its own name on origin), run `git branch --unset-upstream` at once. A new branch whose upstream is the base branch pushes straight into it on a plain `git push`. The upstream is set to `origin/<branch>` only at the first push, in `/dev:task-finish`.
5. **Tracker status (draft)** — check the item's assignee is the user. Propose moving it to the `start` status and do it only after the user approves.
6. **Open the work note** — create `notes/<task>.md` (item link, repo, worktree path, branch) and add a line under "In progress" in `todo.md` pointing to it. Announce in one line: `To-do added: ...`.
7. **Implement** — for a sizable change, use a design-then-plan flow (a brainstorming or planning skill, if one is installed) before writing code. For a small fix, go straight in. If unsure, show the analysis and let the user decide.

## Cautions

- If step 3 stops you (dependency not ready, requirements unclear), don't push ahead. Report the state, record it in the note and under "Waiting" in `todo.md`, and wait.
- Commit and push rules live in `/dev:task-finish`: build before every commit, push only with the user's explicit approval.
- Run heavy commands (install, build, test, lint) one at a time, never several in parallel. Follow `/dev:with-lock` for them.
