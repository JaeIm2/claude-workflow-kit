# task-finish — ship a finished task, and hand it to QA only once it's deployed

English | [한국어](README.ko.md)

A Claude Code skill for when the code is done. It rebases onto the latest base branch, runs your checks, commits, pushes (only after you approve), drafts and opens the pull request (merge request), triages automated review comments, confirms the change is actually deployed to the test environment, and only then proposes handing it to QA. Afterwards it cleans up the worktree and branch.
It is the other end of `/dev:task-start`.

**When to use:** The code is done and you want it pushed, reviewed, deployed to the test environment, and handed to QA.

**Try saying:**
- "Ready to push"
- "Let's open the PR"
- "Let's wrap this up"

**Needs:** git. Your git host's CLI or MCP and a work tracker connection are optional.

## Requirements
- Claude Code and git
- (Optional) Your git host's CLI (`gh`, `glab`) or MCP server. Without one, it gives you the link and the drafted pull request text
- (Optional) An MCP server or connector for your work tracker, for the status change at hand-off

## Install
1. Run these two lines in Claude Code (full instructions in the [root README](../../../../README.md))
   ```
   /plugin marketplace add JaeIm2/claude-workflow-kit
   /plugin install dev@claude-workflow-kit
   ```
2. When a task is done, type `/dev:task-finish` or just say "ready to push"
3. If settings are missing, it asks the same questions as `/dev:task-start` (only the missing ones). To change them, run `/dev:task-start settings`.

## Usage
- `/dev:task-finish`, "ready to push", "let's open the PR", "let's wrap this up"

Rules it keeps:
- All checks must pass before pushing. A check that also fails on the base branch is reported, never skipped on its own
- Build before every commit
- Push only with your explicit approval, one task at a time. "Handle it" doesn't count
- Checks the branch's upstream again before pushing, and never pushes to the base branch
- Doesn't manually start optional pipeline jobs (like AI review), and triages bot review comments instead of applying them all
- **Never asks for QA or review before confirming the change is merged and deployed to the test environment**, using the deploy check you set up
- Pull request creation, the tracker status change, and any tracker comment are drafted first and done only after you approve

Progress, the pull request link, and follow-ups go into the task's work note (`notes/<task>.md`) and `todo.md`, shared with `/everyday:wsid`.
