---
name: with-lock
description: Use before running any heavy command (full build, test suite, typecheck, full lint, bundle analysis) so that concurrent Claude Code sessions on the same machine run them one at a time instead of together — "build it", "run the tests", "typecheck", "/dev:with-lock", "빌드 돌려", "테스트 돌려", "타입체크", "린트 전체". Also use when a build or test run was killed for running out of memory or the machine is slowing down from parallel sessions.
---

# with-lock — one heavy task at a time across sessions

Several Claude Code sessions on one machine each running a build or test suite at the same moment can run the machine out of memory and make everything crawl or crash. Wrap heavy commands with the bundled lock script so they queue up instead.

**Language:** Always talk to the user in the language they use.

## What counts as heavy

Wrap these:
- Full builds (`npm run build`, `yarn build`, `vite build`, `next build`, `cargo build`, `gradle build`, ...)
- Test suites (`jest`, `vitest`, `pytest`, `go test ./...`, ...)
- Typechecks over the whole project (`tsc --noEmit`, `mypy .`, ...)
- Lint over the whole project (`eslint .`, `yarn lint`, ...)

Don't wrap quick commands: `git`, `ls`, a lint or test on one or two files, starting a dev server (long-running; it would hold the lock forever).

## How to run

```
bash "${CLAUDE_PLUGIN_ROOT}/skills/with-lock/with-lock.sh" <command> [args...]
```

Examples:

```
bash "${CLAUDE_PLUGIN_ROOT}/skills/with-lock/with-lock.sh" yarn build
bash "${CLAUDE_PLUGIN_ROOT}/skills/with-lock/with-lock.sh" npx vitest run --maxWorkers=2
```

- If the user called `/dev:with-lock <command>`, run that command this way.
- The command runs as-is; its exit code is passed through.
- If another session holds the lock, the script prints `[with-lock] another session is running a heavy task, waiting...` to stderr and waits. This is expected, not a failure. Don't kill it and don't retry without the lock.
- For shell syntax (pipes, `&&`, `cd`), wrap the whole thing: `bash ".../with-lock.sh" sh -c 'cd app && yarn build'`.

## Rules

1. **Long timeout or background.** Waiting for the lock plus the task itself can take many minutes. Set the Bash timeout to the maximum (600000 ms), or run it in the background and check back.
2. **Limit test workers.** Even under the lock, a test runner that spawns one worker per CPU can eat all memory. Pass a worker limit: `--maxWorkers=2` (jest, vitest), `-n 2` (pytest-xdist), `-p 2` (go test).
3. **If it runs out of memory** (Node "JavaScript heap out of memory"), retry once with `NODE_OPTIONS=--max-old-space-size=4096` in front of the command inside the lock.
4. Never delete the lock by hand while another session may be using it. The script clears a lock left behind by a session that died.

## How it works

The lock is a directory at `~/.claude/locks/heavy-task.lock` holding the owner's process ID. Creating a directory is atomic, so only one session gets it. The lock is released when the command ends, including on Ctrl+C. Works on macOS and Linux with plain bash.
