# claude-workflow-kit

English | [한국어](README.ko.md)

A collection of Claude Code skills for getting everyday work done.
No company or personal details are baked in. On first run, each skill asks a few questions and adapts to your setup.

## Install

Run these two lines in Claude Code:

```
/plugin marketplace add JaeIm2/claude-workflow-kit
/plugin install everyday@claude-workflow-kit
```

Developers can add the `dev` plugin too:

```
/plugin install dev@claude-workflow-kit
```

Pick an install scope (just you, or this project) when prompted. If a session was already open, run `/reload-plugins`.

Or install from your terminal:

```
claude plugin marketplace add JaeIm2/claude-workflow-kit
claude plugin install everyday@claude-workflow-kit
claude plugin install dev@claude-workflow-kit
```

To update: `/plugin marketplace update claude-workflow-kit`

## What's inside

### everyday — for everyone

| Skill | What it does | Docs |
|---|---|---|
| `/everyday:wsid` | Sorts out whatever you paste in (messages, emails, requests), keeps your to-do list and work notes up to date, and briefs you on what to do today when called with nothing | [README](plugins/everyday/skills/wsid/README.md) |
| `/everyday:waid` | When you run several sessions at once, shows in one summary what this session was doing | [README](plugins/everyday/skills/waid/README.md) |
| `/everyday:issue-writer` | Turns a request, bug, or vague idea into a well-structured issue for your work tracker, created only after you approve the draft | [README](plugins/everyday/skills/issue-writer/README.md) |
| `/everyday:weekly-report` | Gathers the week's work from your records, repos, and tracker, and drafts the report in your team's format | [README](plugins/everyday/skills/weekly-report/README.md) |
| `/everyday:plan-doc` | Writes a development-ready planning document, with a state checklist per screen, QA scenarios, and open decisions marked TBD | [README](plugins/everyday/skills/plan-doc/README.md) |

### dev — for developers

| Skill | What it does | Docs |
|---|---|---|
| `/dev:task-start` | Starts a task: reads the item, sets up a new branch or worktree safely, opens a work note | [README](plugins/dev/skills/task-start/README.md) |
| `/dev:task-finish` | Finishes a task: checks, commit, push and pull request after approval, deploy check before handing off to QA | [README](plugins/dev/skills/task-finish/README.md) |
| `/dev:qa-reject` | Handles a QA reject: finds the latest reason, reproduces, fixes, hands it back | [README](plugins/dev/skills/qa-reject/README.md) |
| `/dev:ui-work` | UI work following your repo's conventions file (drafts one if missing), confirms structure first, checks in a browser before calling it done | [README](plugins/dev/skills/ui-work/README.md) |
| `/dev:outsider` | Gets a review from an isolated, read-only Claude that knows nothing about you or your instructions | [README](plugins/dev/skills/outsider/README.md) |
| `/dev:with-lock` | Runs heavy commands (build, test, lint) one at a time across all sessions on the machine | [README](plugins/dev/skills/with-lock/README.md) |
| push-guard (hook) | Asks you before any `git push` | [README](plugins/dev/hooks/README.md) |

## Principles

- Anything that leaves your machine (sending messages, emails, filing tickets, pushing code) stops at a draft and waits for your approval.
- Values that differ between workplaces (work tools, where notes are kept, etc.) are asked on first run and saved to a config file.
- Skills reply in whatever language you use.

## Make it yours

These skills are shared, so they won't fit everyone exactly. When a skill does something you don't want, misses something, or makes a mistake, just say so ("don't post a summary comment", "always run the type check too", "you forgot to check the deploy"). The skill turns it into a rule in `~/.claude/workflow/rules/<skill>.md` and follows it from then on, on top of its own instructions. Updating the kit never touches these files. Rules that would help everyone are also collected in `~/.claude/workflow/suggestions.md`, so you can send them to the kit as one issue whenever you like. The one thing a rule can't turn off is asking before anything leaves your machine.

## License

[MIT](LICENSE). Free to use and modify. Just keep the copyright notice.
