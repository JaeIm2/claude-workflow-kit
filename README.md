# claude-workflow-kit

English | [한국어](README.ko.md)

Claude Code skills for everyday work: sorting out messages, keeping a to-do list, writing tickets, weekly reports and planning docs, and (for developers) starting and shipping tasks safely. Nothing about any company or person is built in. The first time you use a skill, it asks a few questions and adapts to how you work. Anything that would leave your machine waits for your OK.

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

To update, run this in your terminal and then restart Claude Code (see [CHANGELOG](CHANGELOG.md) for what changed):

```
claude plugin marketplace update claude-workflow-kit
claude plugin update everyday@claude-workflow-kit
claude plugin update dev@claude-workflow-kit   # only if you installed dev
```

New here? Run `/everyday:doctor` once. It checks your setup and, if nothing is set up yet, offers to set everything up in one go.

## Pick by situation

You don't have to remember skill names. Saying it in your own words works too.

| Situation | Skill | Try saying |
|---|---|---|
| It's morning and you don't know where to start | wsid | just `/everyday:wsid`, or "what should I do today?" |
| A message or email came in and you're not sure what to do with it | wsid | paste it, then "what is this?" |
| A task came up, or you finished one | wsid | "add this to my to-dos", "that's done" |
| You switched between sessions and lost track | waid | "where was I?" |
| You need a ticket or bug report written | issue-writer | "write a ticket for this", "file a bug: ..." |
| The weekly report is due | weekly-report | "write up my weekly report" |
| You need a planning document for a feature | plan-doc | "plan this feature: ..." |
| Something isn't working, or it's your first time | doctor | "check my setup", or `/everyday:doctor` |
| (dev) You just got a new task | task-start | "start PROJ-123" |
| (dev) The code is done and you want to ship it | task-finish | "ready to push" |
| (dev) QA sent it back | qa-reject | "QA rejected PROJ-123" |
| (dev) You're building or changing a screen | ui-work | "add a delete confirmation dialog to the settings page" |
| (dev) You want a second opinion from fresh eyes | outsider | "get an outside review of this branch" |

## What's inside

### everyday — for everyone

| Skill | What it does | Docs |
|---|---|---|
| `/everyday:wsid` | Sorts out whatever you paste in (messages, emails, requests), keeps your to-do list and work notes up to date, and briefs you on what to do today when called with nothing | [README](plugins/everyday/skills/wsid/README.md) |
| `/everyday:waid` | When you run several sessions at once, shows in one summary what this session was doing | [README](plugins/everyday/skills/waid/README.md) |
| `/everyday:issue-writer` | Turns a request, bug, or vague idea into a well-structured issue for your work tracker, created only after you approve the draft | [README](plugins/everyday/skills/issue-writer/README.md) |
| `/everyday:weekly-report` | Gathers the week's work from your records, repos, and tracker, and drafts the report in your team's format | [README](plugins/everyday/skills/weekly-report/README.md) |
| `/everyday:plan-doc` | Writes a development-ready planning document, with a state checklist per screen, QA scenarios, and open decisions marked TBD | [README](plugins/everyday/skills/plan-doc/README.md) |
| `/everyday:doctor` | Checks your setup and connections and tells you how to fix what's wrong; also sets everything up in one go the first time | [README](plugins/everyday/skills/doctor/README.md) |

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

## What each skill needs

Everything except git is optional. Without a connection, the skill still works and tells you what it skipped.

| What | Used by | Without it |
|---|---|---|
| Nothing extra | waid, doctor, with-lock, push-guard | — |
| Work tracker connection (any connected MCP server or connector: Jira, Linear, Notion, GitHub Issues, ...) | wsid, issue-writer, weekly-report, task-start, task-finish, qa-reject | Paste the item in, or get a copy-ready draft |
| Docs connector (Google Docs, Notion, Confluence, ...) | wsid (notes kept online), plan-doc (create the doc there) | Uses local files |
| git | task-start, task-finish, qa-reject, outsider (diff review), weekly-report (commit history) | Required for the dev task skills |
| Browser tool (e.g. Playwright MCP) | ui-work (checks the screen), plan-doc (looks around a running product) | ui-work tells you what it couldn't check |
| macOS | wsid's scheduled morning briefing only | wsid itself works anywhere |

## What it looks like

Sorting out a message:

```
You:    (pastes) "Could you send me the updated vendor quote comparison by Thursday?"
Claude: Work request: updated quote comparison, due Thursday.
        To-do added: Send updated vendor quote comparison (due Thu)
        Want me to draft a short reply confirming?
```

A developer task, start to finish:

```
You:    start PROJ-123
Claude: PROJ-123: add CSV export to the orders list.
        Created branch feature/PROJ-123-csv-export in its own worktree (upstream checked).
        Opened a work note. Move PROJ-123 to In Progress?
You:    yes
        ... (later) ...
You:    ready to push
Claude: Rebased, all checks passed, committed.
        Ready to push feature/PROJ-123-csv-export. Push it?
```

## Principles

- Anything that leaves your machine (sending messages, emails, filing tickets, pushing code) stops at a draft and waits for your approval.
- Values that differ between workplaces (work tools, where notes are kept, etc.) are asked on first run and saved to a config file.
- Skills reply in whatever language you use.

## Make it yours

These skills are shared, so they won't fit everyone exactly. When a skill does something you don't want, misses something, or makes a mistake, just say so ("don't post a summary comment", "always run the type check too", "you forgot to check the deploy"). The skill turns it into a rule in `~/.claude/workflow/rules/<skill>.md` and follows it from then on, on top of its own instructions. Updating the kit never touches these files. Rules that would help everyone are also collected in `~/.claude/workflow/suggestions.md`, so you can send them to the kit as one issue whenever you like. The one thing a rule can't turn off is asking before anything leaves your machine.

## What's new

See [CHANGELOG.md](CHANGELOG.md).

## License

[MIT](LICENSE). Free to use and modify. Just keep the copyright notice.
