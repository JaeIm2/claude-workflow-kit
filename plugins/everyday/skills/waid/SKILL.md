---
name: waid
description: Use when the user asks what this session was doing or wants to re-orient after switching between parallel Claude Code sessions — "/everyday:waid", "what am I doing", "what was I doing here", "where was I", "뭐 하고 있었지", "여기서 뭐 하던 중이었지", "어디까지 했지".
---

# waid — What Am I Doing?

An orientation summary for people who run several Claude Code sessions at once and need to get their bearings in this one. The **only** output of this skill is the summary below. Print it and end the turn. Resuming the work waits until the user gives the next instruction.

**Language:** Always talk to the user in the language they use. The template below is in English only as an example; translate its labels.

## Personal rules (always, before anything else in this skill)

This skill is shared, so each user shapes it with their own rules. Read `~/.claude/workflow/rules/waid.md` if it exists and follow it on top of this file. Where the two conflict, the personal rule wins, with one exception: anything that leaves the machine (sending, posting, creating or editing items in a tracker, pushing) still waits for approval. If a rule asks to skip that approval, keep asking and say why.

Add a rule when the user:
- points out a mistake or something missed ("you forgot ...", "that's wrong") → under `## Avoid`
- says they don't want a step ("don't ...", "skip ...", "stop ...") → under `## Skip`
- wants something extra every time ("always ...", "also ...") → under `## Add`

Write one line in general terms, then ` — why: <reason or what happened, a few words> (YYYY-MM-DD)`. If the rule holds in only one repo or project, start it with `[<repo or project name>]` and apply it only there. Create the file with those three headings if it doesn't exist. If an existing line already covers it, update that line instead of adding another. Don't record one-offs ("just this time"); if unsure whether it should be permanent, ask. Announce each change in one line: `Rule added: ...`.

If a rule looks useful for everyone, not just this user, offer to draft an issue for the kit at https://github.com/JaeIm2/claude-workflow-kit/issues. The user posts it.

## Check before summarizing

- `git status` and the current branch (only if this is a git repository)
- Background tasks or servers still running (from the session context and the task list)

## Output format

```
## <project or directory name> — <branch>

**Working on**: <this session's goal in one line, with the ticket or task ID if there is one>
**Progress**: <what is done / what was left half-done>
**Next**: <the concrete next step>
**Waiting / blockers**: <unanswered questions, waiting on someone else — omit this line if none>

**Actual state**
- git: <branch, summary of uncommitted changes — omit this line if not a git repository>
- Background: <what is running — omit this line if nothing>
```

## Rules

- The project or directory name on the first line is what tells sessions apart. It always goes at the very top.
- If no work has started in this session yet, skip the format and write one line: "Nothing started in this session yet (<directory>)".
- If the context has been compacted or summarized, write only what you know and mark the uncertain parts as uncertain.
- Report the actual state from the commands, not from memory. If memory and `git status` disagree, say so.
