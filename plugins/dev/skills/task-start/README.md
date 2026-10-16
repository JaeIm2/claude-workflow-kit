# task-start — start a task on a clean, isolated branch

English | [한국어](README.ko.md)

A Claude Code skill for the moment you pick up a new task. It reads the item from your work tracker, checks whatever it depends on, creates a new branch (in its own git worktree if you use them), makes sure that branch can't push into your base branch by accident, and opens a work note so the next session knows where you left off.
It is the first of three dev skills: `/dev:task-start` → `/dev:task-finish`, and `/dev:qa-reject` when QA sends it back.

**When to use:** You just picked up a new task or ticket and want to start on a clean branch without setting it up by hand.

**Try saying:**
- "Start PROJ-123"
- "I got assigned this ticket"
- `/dev:task-start PROJ-123`

**Needs:** git. A work tracker connection is optional (otherwise paste the task in).

## Requirements
- Claude Code and git
- (Optional) An MCP server or connector for your work tracker (Jira, Linear, GitHub Issues, GitLab Issues, YouTrack, ...). Without one, paste the task description in
- (Optional) Your git host's CLI (`gh`, `glab`) or MCP server, used later by task-finish

## Install
1. Run these two lines in Claude Code (full instructions in the [root README](../../../../README.md))
   ```
   /plugin marketplace add JaeIm2/claude-workflow-kit
   /plugin install dev@claude-workflow-kit
   ```
2. Type `/dev:task-start PROJ-123` (your own item key)
3. On first run it asks a few questions, proposing answers from your repos where it can:
   - Where you manage your work and which repos you work in (skipped if another kit skill already asked)
   - Your git host, whether you use worktrees, and your tracker's status names
   - Per repo: base branch, branch naming, commit message rule, check and build commands, how to run it locally, how pull requests are opened and merged, and how to confirm a change is deployed to the test environment

Settings are saved to the `## dev` section of `~/.claude/workflow/config.md`, shared by all three dev skills and the rest of this kit. To change them, run `/dev:task-start settings`.

## Usage
- `/dev:task-start PROJ-123`, "start PROJ-123", "I got assigned this ticket"
- If a work note for the task already exists, it picks up from the note's next steps instead of starting over

Rules it keeps:
- Always a new branch from the latest base branch, never work directly on the base branch
- Right after creating the branch, checks `git branch -vv` and removes an upstream that points at the base branch (otherwise a plain `git push` goes straight into it)
- With worktrees, the work happens in the worktree, not in the main checkout other sessions are using
- Changing the item's status in your tracker is proposed first and done only after you approve

Work notes go in `notes/<task>.md` and a one-line entry in `todo.md`, the same records `/everyday:wsid` uses.
