# waid — what was I doing in this session?

English | [한국어](README.ko.md)

A Claude Code skill for when you run several sessions side by side and lose track. Type `/everyday:waid` in any session and it prints a short summary of what that session was working on, how far it got, what comes next, and the actual git and background-task state. It does nothing else; you decide what to do next.

## Requirements
- Claude Code

No setup. It does not use `~/.claude/workflow/config.md`.

## Install
Run these two lines in Claude Code (full instructions in the [root README](../../../../README.md))
```
/plugin marketplace add JaeIm2/claude-workflow-kit
/plugin install everyday@claude-workflow-kit
```

## Usage
- `/everyday:waid`, or ask "what was I doing here?" / "where was I?"

Example output:
```
## my-app — feature/login-form

**Working on**: Login form validation (PROJ-123)
**Progress**: Email check done, password rules half-done
**Next**: Add the password-strength message and run the tests
**Waiting / blockers**: Asked the designer about the error color, no reply yet

**Actual state**
- git: feature/login-form, 2 files modified, nothing committed
- Background: dev server on port 3000
```

The project name always comes first so you can tell sessions apart at a glance. If the session was compacted, uncertain parts are marked as uncertain.
