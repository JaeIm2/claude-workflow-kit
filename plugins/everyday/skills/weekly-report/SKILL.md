---
name: weekly-report
description: Use when the user wants to prepare their weekly report or status update — "/everyday:weekly-report", "weekly report", "weekly status", "what did I do this week", "write up this week", "주간보고", "주간 현황", "이번주 보고 정리", "금주 작업 정리". Gathers the week's work from the configured sources, groups it into trackable work items, asks about work the sources missed, and outputs a copy-paste-ready draft in the user's own report format. The user always submits it themselves. Also for "/everyday:weekly-report settings" or "/everyday:weekly-report 설정".
---

# weekly-report — weekly report draft

Turn the week's work into a **copy-paste-ready draft** in the user's own report format.
Gather from the configured sources, group into work items, ask about anything the sources missed, have the user confirm, then print the final draft.
**This skill only produces the draft. Submission is always done by the user.**

**Language:** Always talk to the user in the language they use. Ask the setup questions and write the draft in that language too, unless the report format itself is in another language. The examples below are in English only for illustration.

## 0. Check settings (always first)

Read the shared settings file `~/.claude/workflow/config.md` (`## Common` plus one section per skill, shared by every skill in claude-workflow-kit).

- **If the file, the Common items this skill uses (`Work tracker`, `Work records location`, `Repos`), or the `## weekly-report` section is missing → run first-run setup** for just the missing items, then continue. Another skill may already have filled in Common; don't ask those again. If `Work records location` is missing, default to `~/.claude/workflow` and say so.
- **"/everyday:weekly-report settings" (or "설정")** → show the current values and ask again only about what they want to change.
- Never remove or rewrite another skill's section.

### First-run setup

Ask one at a time (as choices if a question UI is available, otherwise in conversation). Skipped or unknown → record "none".

1. **Report format** — "What does your weekly report look like? Paste last week's report or a blank template, or list the fields."
   - From the example, work out: the fields and their order, fixed values (name, team, default role), fields with a fixed set of choices (status, project/category, role) and their exact spelling, numeric constraints (e.g. percentages in steps of 10, a share-of-time field that must total 100, only certain values allowed), and whether one submission covers the whole week or one work item.
   - Save the template, with those constraints written under it, to `<Work records location>/weekly-reports/format.md`. Confirm what you understood in a short list.
2. **House rules** — "Anything your reader dislikes or always wants? (e.g. no ticket IDs in the text, blockers only when really blocked, meetings folded into the related item)"
3. **Sources** — "Where should I gather the week's work from?" Offer every option that applies, multi-select:
   - **Work records**: `<Work records location>/todo.md` (Done section and anything that moved) and `notes/*.md` progress logs (the files `/everyday:wsid` keeps)
   - **Git history** in the `Repos` from Common (ask for repo paths if Repos is none and they want this). Commits by the user's git identity (`git config user.email` in each repo)
   - **Work tracker** from Common, through its connected tool. Work out, in that service's own query terms, how to find "items assigned to me updated in the period" and record it. If it's not connected, say how to add its MCP server or connector and carry on without it
   - **Session history**: Claude Code session logs on this machine, via the bundled scanner
4. **Period** — "What period does one report cover, and when is it due?" (e.g. Monday to Friday, due Friday 14:00; or previous Monday to Sunday, due Monday morning). Record which date names the report (e.g. the Friday of the week).
5. **Submission** — "How do you submit it?" (web form, email, chat message, shared doc or sheet, ...). Record it only to shape the output: one block per form submission, one message, a table to paste into a sheet. **This skill never submits.**

Confirmed reports are kept in `Report archive`, by default `<Work records location>/weekly-reports` (don't ask; change it only if the user wants). Briefly show what was saved.

**`## weekly-report` section format** (labels in English exactly as written; values in any language):

```
## weekly-report
- Report format: ~/.claude/workflow/weekly-reports/format.md
- Unit: one submission per work item        (or: one report for the whole week)
- House rules: no ticket IDs in text; blockers only when really blocked
- Sources: work records, git history, work tracker, session history
- Work tracker query: assignee = currentUser() AND updated >= -10d
- Period: Monday-Friday, due Friday 14:00, named by Friday's date
- Submission: web form (copy-paste per field)
- Report archive: ~/.claude/workflow/weekly-reports
```

The example values are for illustration; record whatever fits the user.

## 1. Workflow

1. **Work out the period** from `Period` — the report date and the start and end dates covered.
2. **Read the last report (never skip).** Open the most recent file in `Report archive`. It is the source of truth for last week's work item names, status, and progress, **in the form the user last left it** (they often edit the draft before submitting). If the user tells you they changed it after saving, ask them to paste the final version and update the archive file only with their permission.
   - **Reuse work item names verbatim** for work that continues. "Upload flow" and "Upload-flow" read as two different items and break the week-to-week trail. Copy the name; don't re-word it.
   - Progress for the same item must not go down. If it did, ask why.
   - An item that was in progress or waiting last week but has no activity this week may have been missed → ask "Did you not touch this one this week?" (Items that were done last week normally don't come back.)
   - No archive yet (first week) → this week's names become the baseline, so choose them carefully: short, stable noun phrases.
3. **Gather from each configured source** for the period. Skip sources that aren't configured.
   - **Work tracker** — run the recorded query with read-only tools. Count an item as this week's work when *the user* moved it: started it, finished their part, handed it to review or testing. A later step done by someone else on work finished earlier (e.g. QA closing it) is not this week's work. Many items updated at the exact same timestamp are usually a board cleanup, not work.
   - **Git history** — `git log --all --no-merges --author=<email> --since=<start> --until=<end + 1 day> --format='%ad %s' --date=short` in each repo. Commit messages are evidence, not report lines.
   - **Work records** — Done items in `todo.md` dated inside the period, and progress log entries in `notes/*.md` inside the period.
   - **Session history** — `python3 ${CLAUDE_PLUGIN_ROOT}/skills/weekly-report/scan-sessions.py --since <start>`. Drop sessions already covered by a tracker item or commit, keep the rest (log analysis, meeting notes, deploy checks, replies, small jobs) as **candidates**. The directory is only a hint; check the content to decide what it belongs to. Dead ends and cancelled sessions are mixed in, so never count a session as done work without the user confirming it.
4. **Group into work items.** Don't list tickets or commits one by one, and don't lump a whole project into one line either. One item = something whose progress can be tracked as one thing.
   - Test: "Could this name carry on next week? Can one progress value describe it?" Yes → one item.
   - Several tickets for the same screen or feature = one item. Different features = separate items.
   - Usually 3 to 7 items a week. Don't split finer just because the format allows it.
   - Item names are short, stable noun phrases; the week's details go in the "done this week" field, not in the name.
   - **Make each item identifiable in plain words.** If ticket IDs are left out (house rule), the description has to do the ID's job: say which screen or feature, what was done, and why. "Swap style library" → "Rewrite the scheduling screen in the new style library". "Check backend readiness" → "Social login integration".
5. **Fill the fields** from the format: status, role or category, progress, share of time, target date, next week's plan.
   - Progress is for the user's own part, not the whole project. Ongoing work with no end (support duty, operations) uses the format's "ongoing" value if it has one, and no target date.
   - Share-of-time fields: make them add up exactly to the required total using only the allowed values. If you had to round, say which ones you adjusted.
   - Fixed-choice fields: use the exact spelling from `format.md`, even if it differs from how people usually write it. If a category is ambiguous (e.g. which of two product lines), ask instead of guessing.
6. **Ask about missed work (never skip).** First show the session-history candidates: "Should any of these go in this week's report?" Then ask only about off-screen work that no source can see: "Anything else that didn't happen at the computer? (meetings, customer visits, mentoring, testing on someone's device, ...)"
7. **Show the draft as a table** with every field, for the user to confirm or change. If there is a total constraint, write the total under the table and check it.
8. **Print the final copy-paste output** (section 2).
9. **Archive it.** Once the user confirms, save the final draft to `<Report archive>/<report date>.md`. Next week's step 2 reads it.
   - **Never silently regenerate a file that already exists.** The user may have edited it since (this has wiped out a user's edits before). If it exists, stop and ask. For "just fix this part" requests, assume they have edited the file in the meantime: either tell them what to change, or write a separate file with a suffix (`<date>-v2.md`) for them to compare.
   - Don't delete or move past reports; they are next week's reference.
   - If the user also wants a spreadsheet (CSV or xlsx) for pasting field by field, write one at the path they choose, with columns in the format's field order and multi-line values as line breaks inside the cell. The same no-overwrite rule applies.

## 2. Output format

Follow `format.md`. General rules:

- One block per submission. If the unit is "one submission per work item", one block per item.
- Wrap each value in backticks so it can be copied cleanly into a form field. No blockquotes.
- Several entries in one field → one line each (a sub-list), never joined with `+`.
- Put the values that are the same for every block (name, report date, totals) in one line at the top.

Example for a per-item form:

```
**Report date** `2026-01-09` · Name `<your name>` · **Share of time total 100** OK

**1. Mobile app / Upload flow**
- Status: `In progress` · Progress: `60` · Share of time: `30` · Target date: `2026-01-23`
- Done this week:
  - `Connected the upload API`
  - `Added retry on failure`
- Next week: `Scheduled upload screen`
- Blockers: (none)
```

**Blockers field:** only things that are actually blocked or a risk the reader must know about (another team hasn't delivered an API so work stopped, an external reply is late and the schedule slips, a decision is pending and work can't continue). Normal follow-ups and normal waiting (pending push, translation to be applied, handing over to QA) are not blockers. Leave it empty. Most weeks it is empty, and that is fine.

## Cautions

- **Don't automate submission**, even if a browser tool could fill the form. Field-by-field automation is slow and error-prone, and the report is the user's to send. A clean copy-paste draft is the deliverable.
- **Don't let item names drift.** Same work as last week → the exact same string. Never skip step 2.
- Fixed-choice values only from the format's list, spelled exactly as listed.
- Check totals and allowed values before showing the draft.
- Follow the house rules (e.g. no ticket IDs) in the final output, but keep the item identifiable in words.
- Don't fill the blockers field just to fill it.
- Session history is a source of candidates, not of confirmed work. The work tracker and commits are stronger evidence.
- Ambiguous category or project → ask, don't guess.
