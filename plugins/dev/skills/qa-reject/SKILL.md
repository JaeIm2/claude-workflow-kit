---
name: qa-reject
description: Use when a task or ticket was rejected by QA and the user wants it handled — "QA rejected it", "it got bounced back", "check the reject reason and fix it", or an item moved back from the QA status. "reject 먹었다", "QA에서 까임", "반려됐어", "reject 사유 확인하고 수정". Covers reading the reject comments, reproducing, fixing, and returning it to QA.
---

# QA reject

The fixed routine for a rejected task: find the reason, reproduce, fix, hand back.

**Language:** Always talk to the user in the language they use. Write work records in that language too. Tracker comments and questions to QA use the `Tracker comment language` from settings.

## 0. Check settings (always first)

Read `~/.claude/workflow/config.md`. If any Common item (`Work tracker`, `Repos`, `Work records location`) or any `## dev` item is missing, follow `${CLAUDE_PLUGIN_ROOT}/skills/task-start/setup.md` for just those, then continue. To change settings: `/dev:task-start settings`.

## Workflow

1. **Find the reason** — read the item and its comments with the tracker's tools (not connected → ask the user to paste them). Pick out the latest reject reason and report it in one line ("QA says: ..."). If the comments mention screenshots or videos you can't see, ask the user to share them.
   - **Your change may not be the cause.** Someone else's commit may have overwritten it (another person merged changes to the same area), or it may be the environment. Before deciding, check the recent history of the affected files (`git log -p -- <file>` on the base branch).
2. **Read the work note** — `notes/<task>.md` tells you which repo, worktree, and branch the work was done in. If the branch was already merged, a new fix branch is needed: create it from the base branch following `/dev:task-start` step 4 (new branch, worktree if used, check the upstream with `git branch -vv`).
3. **Reproduce** — reproduce locally if you can, using the repo's `Run locally` setting. Ask the user for the test account; never save credentials. If it won't reproduce, suspect environment differences (test server state, deployment variant or configuration, browser) and discuss with the user.
4. **Fix** — fix it once the cause is clear. If the cause is someone else's commit, report that to the user before changing anything; undoing another person's work needs a conversation first.
5. **Verify and build** — confirm the fix with the reproduction steps, and run `Build` before committing.
6. **Prepare the hand-back** — commit, then stop: push waits for the user's explicit approval. Then follow `/dev:task-finish` from step 4: push, pull request, and **confirm the fix is deployed to the test environment before handing it back.** Draft a tracker comment describing the fix, and propose moving the item back to the `hand off` status; post and move only after the user approves.
7. **Update the work note** — record the reject reason and what was fixed in the progress log, set the status back to in progress (then waiting once handed back), and move the line in `todo.md` to match. If it gets rejected again for the same reason, this history is your evidence.

## Cautions

- If there are several QA comments, use only the latest reject reason. Don't get pulled in by earlier points that were already resolved.
- If the reason is unclear, don't guess at a fix. Draft the questions to ask QA and show them to the user.
- If it's urgent (marked top priority by leadership or blocking a release), keep the step 1 report short and move straight to the fix.
