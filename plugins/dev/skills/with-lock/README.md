# with-lock — one heavy task at a time across Claude Code sessions

English | [한국어](README.ko.md)

When you run several Claude Code sessions on one machine, two of them starting a full build or test suite at the same moment can run the machine out of memory. This skill makes Claude wrap heavy commands (build, test, typecheck, full lint) in a small lock script, so they wait in line instead of running together.

## Requirements
- Claude Code
- macOS or Linux (plain bash, no extra tools)

## Install
1. Run these two lines in Claude Code (full instructions in the [root README](../../../../README.md))
   ```
   /plugin marketplace add JaeIm2/claude-workflow-kit
   /plugin install dev@claude-workflow-kit
   ```
2. That's it. No setup questions.

## Usage
- Just ask as usual: "build it", "run the tests". Claude wraps the command with the lock.
- Or call it directly: `/dev:with-lock yarn build`

What you'll see:
- If no other session is busy, the command runs right away.
- If another session holds the lock, you'll see `[with-lock] another session is running a heavy task, waiting...` and it starts when the other one is done.

Claude also runs these commands with a long timeout (or in the background) and limits test runners to 2 workers.

## Details
- Lock location: `~/.claude/locks/heavy-task.lock` (a directory with the owner's process ID). It is under your home folder rather than the temp folder, because the temp folder can differ between sandboxed sessions.
- A lock left behind by a session that crashed is cleared automatically.
- Dev servers and other long-running commands are not wrapped; they would hold the lock forever.
