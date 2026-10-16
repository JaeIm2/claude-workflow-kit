# dev settings (shared by /dev:task-start, /dev:task-finish, /dev:qa-reject)

All three dev skills read and fill in the same settings. This file describes them once.

**Language:** Ask these questions in the language the user is using.

## When to run

Read `~/.claude/workflow/config.md` first. Every skill in claude-workflow-kit shares this file: a `## Common` section any skill may reuse, plus one section per skill. The three dev skills share one section, `## dev`.

- **A Common item below or any `## dev` item is missing** → ask for just the missing items, then continue with the original request. Another skill may already have filled some in; don't ask those again.
- **The user says "/dev:task-start settings" (or "설정")** → show the current Common items used here and the whole `## dev` section, and ask again only about the items they want to change.
- Never remove or rewrite another skill's section. Keep every heading and label in English exactly as written; values may be in any language.

Ask one question at a time (as choices if a question UI is available, otherwise in conversation). If the user doesn't know or skips, record "none", except where noted below.

## Common items (ask only if missing)

These follow the same format as `/everyday:wsid`, so both kits can reuse them.

1. **Work tracker** — "Where do you manage your work? (e.g. Jira, Linear, GitHub Issues, GitLab Issues, YouTrack, Asana, or nothing in particular)"
   - Look through the tools available in this session for an MCP server or connector for that service.
   - **Connected** → ask which part to look at (project, board, team); empty means everything assigned to me. Make one small read call to confirm it works. Record, in that service's own query terms, how to find (a) my items in progress and (b) my items updated in the last 3 days, and record the read-only tool names (search, list, get) under `Briefing read-only tools`. Never list tools that create, edit, or delete there.
   - **Not connected** → tell the user they can add that service's MCP server or connector and then run `/dev:task-start settings` again. Record "<service> — not connected". The dev skills then ask the user to paste the item's description and comments.
   - Nothing in particular → none. Tasks are then named by a short slug the user gives.
2. **Repos** — "Which local repos do you work in? Give me their paths." Check each path is a git repo.
3. **Work records location** — "Where should I keep your to-do list and work notes?" Default `~/.claude/workflow/`.

Record `Language` from the language the user is writing in (don't ask).

## `## dev` items

Propose values from the repo itself before asking, and let the user confirm or correct them. If a repo has its own instructions for agents or contributors (`CLAUDE.md`, `AGENTS.md`, `CONTRIBUTING.md`), read them first; they take precedence over this config wherever they disagree.

1. **Git hosting** — "Where is your code hosted? (GitHub, GitLab, Bitbucket, other)" Check whether a CLI (`gh auth status`, `glab auth status`) or an MCP server for it is available. If neither, record that and open pull requests by giving the user the link and the drafted title and body.
2. **Worktrees** — "Do you use git worktrees for each task?" Recommend yes: other sessions and tools often share the main checkout, and switching branches there breaks their work (dependencies, dev servers, uncommitted state). Default location `<repo>/.worktrees/<task>`.
3. **Tracker statuses** — the status names for (a) starting work, (b) handing off to QA or review, (c) rejected by QA. If the tracker is connected, read its status list and propose. Also ask which status means a task is deployed to the test environment (used to judge whether a task you depend on is ready); usually the same as (b).
4. **Tracker comment language** — the language for comments posted on tracker items (often English in mixed teams).
5. **Per repo** (each repo in Common `Repos`):
   - **For** — which tracker items or kinds of work go to this repo (project key, component, team). Used to pick the repo for a task.
   - **Base branch** — propose from `git symbolic-ref refs/remotes/origin/HEAD`.
   - **Branch naming** — propose from repo docs or recent remote branches (`git branch -r --sort=-committerdate | head -20`).
   - **Commit message** — propose from repo docs or `git log --oneline -20`.
   - **Checks before push** — lint, test, type check, etc. Propose from `package.json` scripts, `Makefile`, or similar.
   - **Build** — the build command run before every commit. If there is none, the checks are used instead.
   - **Run locally** — how to start the app and the local URL, for reproducing bugs. Never store passwords or test account credentials here; ask the user when needed.
   - **Pull request** — target branch, merge options (squash, delete source branch, auto-merge), required attachments (screenshots for UI changes), whether a pipeline runs on it, and who merges.
   - **Deploy check** — how to confirm a merged change is actually live in the test environment (a pipeline job, a version endpoint, a deploy channel message, a status page). **Never record "none"**: if the user doesn't know, record "ask me each time". The dev skills never ask for QA or review before this check passes.

## Format

```
# claude-workflow-kit settings

## Common
- Language: English
- Work tracker: Jira / scope: project PROJ
  - In progress: assignee = currentUser() AND statusCategory = "In Progress"
  - Recently updated: assignee = currentUser() AND updated >= -3d
- Work records location: ~/.claude/workflow
- Repos: ~/code/web-app, ~/code/api
- Briefing read-only tools: mcp__jira__search_issues, mcp__jira__get_issue
- Set up on: YYYY-MM-DD

## dev
Shared by /dev:task-start, /dev:task-finish, /dev:qa-reject.
- Git hosting: GitLab (glab CLI)              (or: GitHub (gh CLI), Bitbucket — no CLI, other: <how>)
- Worktrees: yes, at <repo>/.worktrees/<task>  (or: no)
- Tracker statuses: start = In Progress / hand off = In Testing / rejected = Reopened / deployed to test = In Testing
- Tracker comment language: English
- Repo: ~/code/web-app
  - For: PROJ items (web front end)
  - Base branch: develop
  - Branch naming: feat/<task>_<short-desc> for features, fix/<task>_<short-desc> for bugs
  - Commit message: type(<task>): summary, in English
  - Checks before push: <your lint command>, <your test command>, <your type check command>
  - Build: <your build command>
  - Run locally: <your dev server command> → http://localhost:3000
  - Pull request: target develop, squash, delete source branch, screenshots for UI changes; no pipeline on PRs; I merge it myself
  - Deploy check: after merge, CI deploys develop to the test server; confirm the deploy job for the merge commit succeeded
- Repo: ~/code/api
  - (same fields)
```

The example values are for illustration; record whatever fits the user's own setup. Once answered, show briefly what was saved.

## Work records (shared with /everyday:wsid)

The dev skills don't keep a separate store. They use the same files as `/everyday:wsid`, under the Common `Work records location`. If the files don't exist yet, create them in this format, with headings and labels translated into the user's language.

**`todo.md`** — one line per task, pointing to its notes file. Don't copy progress details into it.

```
# To-dos

## In progress
- [ ] PROJ-123 Add export button → notes/PROJ-123.md

## Waiting (on someone else's reply)
- [ ] PROJ-120 Waiting on QA (handed off 10/15) → notes/PROJ-120.md

## Upcoming

## Done (keep only the last 2 weeks, delete older ones)
- [x] 10/14 PROJ-118 Fix date filter
```

**`notes/<task>.md`** — one file per task, named by its tracker key (or the slug if there is no tracker).

```
# PROJ-123 — <item title in one line>
Status: in progress | waiting | done
Updated: YYYY-MM-DD

## Background
- Item: <link to the tracker item>
- Repo: ~/code/web-app / Worktree: ~/code/web-app/.worktrees/PROJ-123 / Branch: feat/PROJ-123_export-button
- (what the task is, what it depends on)
## Progress log
- 10/14: Implemented export, commit abc1234. Decided to reuse the existing CSV helper because ...
## Next steps
- (concrete enough that the next session's first action is obvious: file and function names)
```

Rules:
- Write only what is expensive to rediscover (decisions, pitfalls, review findings, what you're waiting on). Don't copy what the commit log already says.
- Always record the repo, worktree path, and branch. They're the first thing needed to resume.
- Update the notes when starting, pausing ("that's it for today", "let's stop here"), committing, and handing off.
- If the notes and the real git state disagree, trust git and fix the notes.
- When a task is done, set `Status: done` but never delete the file. Rejects come back.
