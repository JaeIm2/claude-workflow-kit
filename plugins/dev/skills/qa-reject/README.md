# qa-reject — handle a task QA sent back

English | [한국어](README.ko.md)

A Claude Code skill for when QA rejects a task. It reads the latest reject reason from your work tracker, checks whether someone else's change is actually the cause, finds the original branch from the work note, reproduces the problem, fixes it, and prepares the hand-back: commit, then push, deploy check, and the tracker comment and status change once you approve.

## Requirements
- Claude Code and git
- (Optional) An MCP server or connector for your work tracker. Without one, paste the QA comments in
- Works best after `/dev:task-start` and `/dev:task-finish`, which leave the work note it reads

## Install
1. Run these two lines in Claude Code (full instructions in the [root README](../../../../README.md))
   ```
   /plugin marketplace add JaeIm2/claude-workflow-kit
   /plugin install dev@claude-workflow-kit
   ```
2. When a task comes back, type `/dev:qa-reject PROJ-123` or say "QA rejected PROJ-123"
3. If settings are missing, it asks the same questions as `/dev:task-start` (only the missing ones). To change them, run `/dev:task-start settings`.

## Usage
- `/dev:qa-reject PROJ-123`, "QA rejected it", "check the reject reason and fix it"

Rules it keeps:
- Uses only the latest reject reason, not earlier points already resolved
- Checks the recent history of the affected files before assuming your change is the cause, and tells you before touching someone else's work
- If the reason is unclear, drafts questions for QA instead of guessing at a fix
- If the branch was already merged, starts a new fix branch from the base branch with the same safety checks as task-start
- Builds before committing, pushes only with your approval, and hands back to QA only after confirming the fix is deployed to the test environment
- Never saves test account credentials

The reject reason and the fix are added to the task's work note, so a repeat reject has the history ready.
