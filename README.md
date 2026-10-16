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

Pick an install scope (just you, or this project) when prompted. If a session was already open, run `/reload-plugins`.

Or install from your terminal:

```
claude plugin marketplace add JaeIm2/claude-workflow-kit
claude plugin install everyday@claude-workflow-kit
```

To update: `/plugin marketplace update claude-workflow-kit`

## What's inside

### everyday — for everyone

| Skill | What it does | Docs |
|---|---|---|
| `/everyday:wsid` | Sorts out whatever you paste in (messages, emails, requests), keeps your to-do list and work notes up to date, and briefs you on what to do today when called with nothing | [README](plugins/everyday/skills/wsid/README.md) |

### Coming soon

- everyday: issue writing, weekly reports, planning documents
- dev (for developers): starting and wrapping up tasks, handling QA rejections, UI work, outside review, push confirmation, queuing heavy commands

## Principles

- Anything that leaves your machine (sending messages, emails, filing tickets, pushing code) stops at a draft and waits for your approval.
- Values that differ between workplaces (work tools, where notes are kept, etc.) are asked on first run and saved to a config file.

## License

[MIT](LICENSE). Free to use and modify. Just keep the copyright notice.
