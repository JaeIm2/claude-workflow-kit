---
name: task-finish
description: Use when a task's implementation is done and the user wants it shipped — "ready to push", "let's open the PR", "let's wrap this up", right after the user approves a push, or when a work note's next steps say push, PR, or confirm merge. "push 준비됐어", "MR 만들자", "PR 올리자", "이거 마무리하자", "털어버리자". Covers rebase, checks, commit, push, pull/merge request, automated review triage, deploy check, hand-off to QA, and cleanup.
---

# Task finish

The fixed routine that takes a finished task through push, pull request (merge request), hand-off to QA, and cleanup. The other end of `/dev:task-start`.

**Language:** Always talk to the user in the language they use. Write work records in that language too. Tracker comments use the `Tracker comment language` from settings. Call it "pull request" or "merge request" the way the user's git host does.

## 0. Check settings (always first)

Read `~/.claude/workflow/config.md`. If any Common item (`Work tracker`, `Repos`, `Work records location`) or any `## dev` item is missing, follow `${CLAUDE_PLUGIN_ROOT}/skills/task-start/setup.md` for just those, then continue. To change settings: `/dev:task-start settings`. Read the task's `notes/<task>.md` to find its repo, worktree, and branch.

## Workflow

1. **Bring the branch up to date** — `git fetch origin`, then rebase onto `origin/<Base branch>`. Resolve conflicts, then check for regressions. If tests break after the rebase, the cause may be the interaction with new changes on the base branch, not your branch; check whether the failure also happens on the base branch.
2. **Checks (all must pass)** — run the repo's `Checks before push`, one at a time, following `/dev:with-lock`. Also follow any extra checks the repo's own instructions require for the parts you touched (generated code, translation checks, other packages in a monorepo).
   - If a check also fails on the base branch, it's pre-existing, not yours. Record it and report it. Never skip hooks (`--no-verify`) on your own; ask the user.
3. **Commit** — run `Build` before every commit (or the checks, if there is no build command). Follow the repo's `Commit message` rule.
4. **Push (explicit approval required)** — push only when the user clearly approves pushing this task. A broad "handle it" or "do whatever" is not approval. Until then, report "Ready to push" and wait.
   - Before pushing, run `git branch -vv` again. If the upstream is the base branch, `git branch --unset-upstream` first.
   - `git push -u origin <branch>`, with the remote branch under the same name. Never push to the base branch.
   - Approval is per task. Don't slip in "shall I push this one too?" to bundle other tasks; ask for each.
5. **Pull request (draft, then create after approval)** — draft the title and body following the repo's `Pull request` setting: summary of changes, link to the tracker item, and screenshots or a video for UI changes if the repo asks for them. Target branch and merge options (squash, delete source branch, auto-merge) as configured. Create it with the git host's CLI or MCP after the user approves. If neither is available, give the user the link and the drafted text.
   - If the repo has no pipeline on pull requests, don't start monitoring one. If the user merges themselves, just check the merge status.
6. **Automated review comments** — never manually trigger optional or manual pipeline jobs (AI review and similar) unless the user asks; they can hold up the merge until they finish. If a reviewer bot did leave comments, triage them instead of applying them all; much of it is usually noise.
   - **Adopt:** real bugs (races, missing filters or checks), copy and translation mistakes, type correctness, obvious locale or key errors.
   - **Reject:** factually wrong claims, error handling for code already inside a handler, suggestions that break the repo's lint rules (casting to an any-type, etc.), pure style preference.
   - Summarize the triage for the user, then apply the adopted ones after approval.
7. **Confirm the deploy, then hand off to QA** — **never ask for QA or review before confirming the change is deployed to the test environment.**
   - First confirm the pipeline passed and the pull request is merged. If the pipeline fails, check whether it also fails on the base branch before blaming the branch.
   - Then run the repo's `Deploy check`. If it says "ask me each time", ask the user how to confirm this one.
   - Only after both, propose moving the item to the `hand off` status, and do it after the user approves. Moving it earlier sends QA a false signal: nothing is deployed yet, and a failed pipeline means more fixes.
   - By default, don't post a comment with the pull request link or a change summary. Draft one only when the user asks or to answer an ongoing discussion with QA, in the `Tracker comment language`, posted after approval.
8. **Update the records** — in `notes/<task>.md`, add the pull request link, pipeline state, and any follow-ups (merge check, config or environment changes, translation keys or other post-merge work) to the progress log. In `todo.md`, move the task to "Waiting" (on QA) once handed off. When it's merged and handed off with nothing left, set `Status: done` and move it to Done.
9. **Clean up after merge** — remove the worktree (`git worktree remove <path>`), delete the local branch, and give the user the list of follow-ups that still need them.

## Cautions

- If the pull request blocks someone else (a teammate waiting to build on it), stay on it until the merge is confirmed.
- If a pipeline fails after the pull request is opened, first check whether the failure reproduces on the base branch.
- Hotfix or release-branch deploys (cherry-picks onto a separate release branch, ordering constraints between repos) are outside this routine. Agree the order with the user first.
