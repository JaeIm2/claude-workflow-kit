# push-guard — ask before every git push

English | [한국어](README.ko.md)

A hook that ships with the `dev` plugin. Whenever Claude is about to run a Bash command containing `git push`, Claude Code stops and shows you a permission prompt. Nothing gets pushed until you say yes, including in auto mode. Other commands are not affected.

It is a hook, not a skill: there is nothing to call. It turns on when the `dev` plugin is enabled.

## Why
Pushing is the one step that can't be quietly undone. The case this guard was written after: a feature branch had been created from `origin/develop` with that as its upstream, so a plain `git push` went straight onto `develop`. A prompt that says "this goes to the upstream, check `git branch -vv`" catches that before it happens.

## What the prompt tells you
The prompt's reason names the riskiest thing it found, in this order:

1. **Force push** — `--force`, `-f`, or a `+branch` refspec. (`--force-with-lease`, the normal way to update a rebased feature branch, isn't flagged as force, but still asks.)
2. **Protected branch** — the push names `main`, `master`, `develop`, or a `release` branch.
3. **No target** — plain `git push` or `git push origin`. It goes to the current branch's upstream; if that upstream is `main` or `develop`, that's where it lands. Check with `git branch -vv`.
4. Anything else — shows the target and asks you to confirm.

## Requirements
- Claude Code with the `dev` plugin installed (`/plugin install dev@claude-workflow-kit`)
- `sh`. `jq` is used if present; without it the guard still fires, just with coarser parsing.

## Notes
- It only sees commands Claude runs through the Bash tool. Pushes you type in your own terminal aren't affected.
- It matches the text `git push`. Forms like `git -C <dir> push` are not caught.
- To turn it off, disable the plugin (`/plugin`) or run `claude plugin disable dev@claude-workflow-kit`.
