---
name: wsid
description: Use when the user pastes something (Slack message, email, meeting note, request, error, screenshot) without a clear instruction and expects the right handling — "/everyday:wsid", "What should I do", "what is this", "이거 뭐임", "이거 어떻게 하지". Also use when called with no input at all to get a briefing of what to work on next, when the user says a task is done or adds a task ("add this to my to-dos", "that's done", "이거 할 일에 넣어줘", "그거 끝났어"), and for "/everyday:wsid settings" or "/everyday:wsid 설정".
---

# WSID — What Should I Do (inbox for anything + to-dos and work notes)

Sort out whatever comes in and handle it, and **keep recording** the to-dos and progress that come out of it in the work folder. When called with nothing, gather the records and linked sources into a "what to do first today" briefing.

**Language:** Always talk to the user in the language they use. Ask the setup questions, write records, and write briefings in that language too. The templates below are in English only as examples; translate their headings and labels when you create the files.

## 0. Check settings (always first)

Read the settings file `~/.claude/wsid/config.md`.

- **If it doesn't exist → run first-run setup**, then continue with the original request.
- **If the user says "/everyday:wsid settings" (or "설정")** → show the current values and ask again only about the items they want to change.

### First-run setup

Ask the following one at a time (as choices if a question UI is available, otherwise in conversation). If the user doesn't know or skips, record "none".

1. **Work tracker** — "Do you track your work in YouTrack?"
   - Yes → the project key to use (e.g. PROJ); empty means all of my tickets. Check that the YouTrack tools are actually connected with `get_current_user`; if not, record "not connected" and move on
   - No → none
2. **Personal notes documents** — "Do you have a document where you usually write down your work? Give me a local file path or a link (Google Docs, etc.). Several are fine."
   - Local path → check that it can actually be read
   - Link → check that a tool that can read it is available (e.g. a Google Drive connection). If not, record "link only, cannot read", and during briefings ask the user to paste its content if needed
3. **Work records location** — "Where should I keep your to-do list and work notes?" Default `~/.claude/wsid/`. If they want somewhere else, such as a Google Drive synced folder, use that path
4. (Developers only) **Repo paths** — if they want branches and worktrees in progress included in the briefing. Otherwise skip

Once answered, create the settings file and the record files, and briefly show what was created.

**`~/.claude/wsid/config.md` format** (the settings file always lives here; only the work records location can change)

```
# wsid settings
- Work tracker: YouTrack / project: PROJ         (or: none)
- Personal notes documents:
  - ~/Documents/work-notes.md                     (local)
  - https://docs.google.com/document/d/...         (Google Doc, readable)
- Work records location: ~/.claude/wsid
- Repos: none
- Set up on: YYYY-MM-DD
```

## 1. Work records (always, after setup)

Keep two things under the work records location.

**`todo.md` — a single to-do file**

```
# To-dos

## In progress
- [ ] Organize vendor quote comparison (due 10/20) → notes/quote-comparison.md

## Waiting (on someone else's reply)
- [ ] Waiting for design team's mockup reply (requested 10/15)

## Upcoming
- [ ] Monthly usage report (first week of every month)

## Done (keep only the last 2 weeks, delete older ones)
- [x] 10/14 Answered 3 customer inquiries
```

**`notes/<task name>.md` — work log for tasks that take more than a day**

```
# <task name>
Status: in progress | waiting | done
Updated: YYYY-MM-DD

## Background
## Progress log
- 10/14: Gathered material, got quotes from 3 vendors
## Next steps
```

Recording rules:

- **When a to-do, deadline, or waiting item comes up in conversation**, add the clear ones to `todo.md` right away and announce it in one line (`To-do added: ...`). If unsure, ask (`Add this to your to-dos?`).
- **"Done", "finished"** → move it to Done with the date.
- **When starting or pausing a task that takes more than a day** → update that notes file's progress log and next steps. When the user says "let's continue", read the notes first and pick up from there.
- Keep records short. Don't write a paragraph where one line will do.

## 2. When something is pasted in — classify and handle

Report the classification in one line and go ahead. Ask only when it is ambiguous between two or more paths.

| Input | Handling |
|---|---|
| Work requests, instructions ("they want ...", "prepare ... by ...") | Summarize → add to `todo.md` (with deadline) → start right away if possible |
| Slack, email, messenger messages | Summarize the point → draft a reply if one is needed → add to-dos if any come up |
| Meeting notes, a long conversation pasted whole | Split by topic into decisions / to-dos / open questions → add to-dos, then ask about priority |
| Documents, materials, links | Summarize → mark the parts relevant to my work and what needs doing |
| Customer inquiries | Organize the symptom and request → what to check → draft a reply |
| Errors, odd behavior, screenshots | Figure out what's going on → likely causes or fixes; draft a report if one should be filed |
| Task name or number ("continue the quote task", ticket number) | If notes exist, read them and continue. If using YouTrack, read the ticket body and comments and summarize |
| "Done", "add this to my to-dos too" | Update `todo.md` per the recording rules |

- If another installed skill fits exactly, hand off to it. After handing off, that skill's rules take precedence.
- If nothing fits, proceed as a normal task. Don't force a fit.

## 3. Called with nothing ("/everyday:wsid" alone, "what should I do") — briefing

Gather only what is configured. Skip steps that aren't.

1. **Work records** — all of `todo.md`, plus next steps and update dates from `notes/*.md` whose status is in progress or waiting
2. **YouTrack** (if used) — `get_current_user`, then `search_issues` with `for: me State: {In Progress}` and `for: me updated: {minus 3d} .. Today`. If a project key is set, restrict with `project: <key>`
3. **Personal notes documents** (if set) — read only the readable ones and check recent content for to-dos and deadlines. For unreadable ones, add one line at the end of the briefing: "Documents not checked: ..."
4. **Repos** (if set) — `git worktree list`, branches in progress

Output format (add nothing else). Use bullets in every section except the recommendation, which is a numbered list (`1.`, `2.`, ...):

```
## YYYY-MM-DD Briefing
**Heads-up** — deadlines close or past, things others are waiting on me for
**In progress** / **Waiting** / **New** / **Stale (N days)**
**Recommended: start with** — one line of reasoning per item
```

- Put things that block others (others waiting on my reply or review) at the very top.
- For items with deadlines, include the days left.
- Mark in-progress items that haven't been updated in a while as stale.
- When writing counts, check they match the number of items listed.
- If the records look out of sync with reality during a briefing (something done but still listed as in progress, etc.), don't fix it; just mark it "needs cleanup".

## Cautions

- Anything that goes outside (sending messages, sending emails, filing tickets, posting comments) stops at a **draft** and runs only after the user approves.
- One line is enough to explain a classification.
- Personal notes documents are read-only. Edit them only when the user asks.
- If only a screenshot is pasted, look at it and judge. If unclear, ask "What are you trying to do with this?"
