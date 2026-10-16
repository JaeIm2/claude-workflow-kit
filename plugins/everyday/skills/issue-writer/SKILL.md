---
name: issue-writer
description: Use when the user wants an issue, ticket, or card written for their work tracker — a feature or task, a bug report, or a vague request turned into a clear issue — "/everyday:issue-writer", "write a ticket for this", "file a bug", "make this into an issue", "turn this into a task", "티켓 만들어줘", "이슈 써줘", "버그 리포트 써줘", "버그 등록해줘", "이거 태스크로 정리해줘". Also for "/everyday:issue-writer settings" or "/everyday:issue-writer 설정".
---

# Issue Writer — feature/task issues, bug reports, and vague requests made filing-ready

Turn a request, notes, or a bug description into one well-structured issue for whatever tracker the user uses. Clarify first, draft second, and create the issue only after the user approves the draft.

**Language:** Always talk to the user in the language they use. The issue itself is written in the **Issue language** from settings, which may differ (e.g. English issues for a team that talks in Korean).

## Personal rules (always, before anything else in this skill)

This skill is shared, so each user shapes it with their own rules. Read `~/.claude/workflow/rules/issue-writer.md` if it exists and follow it on top of this file. Where the two conflict, the personal rule wins, with one exception: anything that leaves the machine (sending, posting, creating or editing items in a tracker, pushing) still waits for approval. If a rule asks to skip that approval, keep asking and say why.

Add a rule when the user:
- points out a mistake or something missed ("you forgot ...", "that's wrong") → under `## Avoid`
- says they don't want a step ("don't ...", "skip ...", "stop ...") → under `## Skip`
- wants something extra every time ("always ...", "also ...") → under `## Add`

Write one line in general terms, then ` — why: <reason or what happened, a few words> (YYYY-MM-DD)`. If the rule holds in only one repo or project, start it with `[<repo or project name>]` and apply it only there. Create the file with those three headings if it doesn't exist. If an existing line already covers it, update that line instead of adding another. Don't record one-offs ("just this time"); if unsure whether it should be permanent, ask. Announce each change in one line: `Rule added: ...`.

If a rule looks useful for everyone, not just this user, offer to draft an issue for the kit at https://github.com/JaeIm2/claude-workflow-kit/issues. The user posts it.

## 0. Check settings (always first)

Read the shared settings file `~/.claude/workflow/config.md`. Every skill in claude-workflow-kit shares this file: a `## Common` section that any skill may reuse, plus one section per skill. Ask only for what is missing. Never remove or rewrite another skill's section.

- **Common → Work tracker missing** → ask exactly as `/everyday:wsid` does: "Where do you manage your work? (e.g. Jira, Linear, Notion, Asana, Trello, GitHub Issues, YouTrack, or nothing in particular)". Look for a connected MCP server or connector for that service. If connected, make one small read call to confirm it works. If not, tell the user they can add one and run `/everyday:issue-writer settings` again, and record "<service> — not connected". Record the answer in `## Common` in the same format wsid uses.
- **`## issue-writer` section missing** → ask one at a time:
  1. **Issue language** — "What language should issues be written in?" (the team's language, not necessarily the user's)
  2. **Default project** — the project, board, team, repo, or database new issues usually go to. Reuse the scope recorded in Common if there is one; confirm it
  3. **Required fields and team template** — "Does your team require any fields (priority, component, labels, sprint, ...) or a fixed issue template? You can paste an example issue." If connected, also read the project's field schema to learn which fields are required. Record a one-line summary of the template's section headings, not the whole paste
- **"/everyday:issue-writer settings" (or "설정")** → show current values and ask only about the items the user wants to change.

```
## issue-writer
- Issue language: English
- Default project: PROJ
- Required fields: Priority, Component
- Team template: none   (or: Context / Steps / Expected / Notes)
- Set up on: YYYY-MM-DD
```

Labels stay in English exactly as written. Values may be in any language.

## 1. Decide the kind

| Input | Kind |
|---|---|
| Something should appear, change, or start working | **Task** (feature, change, chore) |
| Something works differently from how it should | **Bug** |
| Vague, mixed, or unclear | Clarify first (step 2), then pick Task or Bug |
| "Just make it draft-ready, don't create it" | Either kind; stop after the draft |

State the kind in one line. **One request = one issue.** If the input holds several independent changes or bugs, say so and propose how to split before going further.

## 2. Clarify before drafting

1. **Read what is already in scope first** — linked issues and comments, specs, designs, files, logs, existing code or behavior when available locally. Don't ask the user for anything you can look up, and never re-ask something already answered.
2. **Check the completeness list** for the kind (below). For each missing item, decide: discoverable (go find it) or a decision only the user can make.
3. **Interview by default.** Ask exactly **one question per turn**, the one that constrains the most later choices first. Give the current context in one sentence, a recommended answer, and its tradeoff. A recommendation is not a decision until the user accepts it.
4. After each answer, recheck the whole list. When everything is covered, ask one last question: "Any other roles, conditions, exceptions, or exclusions to capture?" Their confirmation ends clarification.
5. **Skip the interview only** when the user explicitly says everything is covered and to proceed without questions. "Create a ticket" or "go ahead" alone does not count. When skipping, write every uncovered required item as `Not specified by requester.` — never fill it with a guess.
6. Keep product decisions separate from tracker fields. A missing required field value (priority, component) is a field question, not a product question.

**Task completeness list**
- The current problem or limitation, and who or what is affected
- The observable result after the work is done
- What is in scope and what is explicitly out of scope
- Conditions that change behavior (role, plan, feature flag, integration, special data)
- Acceptance criteria, one observable result each
- **Vertical slice:** the issue delivers one narrow, complete, independently verifiable behavior, not one layer ("UI only", "API only", "tests only") unless that layer is useful on its own. If the request spans independent outcomes, more than two major verification surfaces, or more than 10 acceptance criteria, propose a split by user-visible outcome and wait for the user to confirm the slice.

**Bug completeness list**
- Environment, or a deterministic entry condition
- Shortest reproduction steps that actually reproduce it
- Observable actual result
- Observable expected result (if the correct behavior is a product decision, ask; don't infer the "fix")
- Special conditions (role, plan, flag, account, data) when they matter
- Minimal evidence (screenshot, video, log), or why none is available

Never invent reproduction steps, environment details, browser specificity, expected behavior, or root cause.

## 3. Write the draft

If the user gave a team template, follow it; map the content below onto its sections. Otherwise use these templates and drop empty optional sections.

**Task**

```
Title: [Area/Subarea] <what should appear, change, or start working>

### Context / Problem
### Description
### Acceptance criteria
- [ ] ...
### Example / Scenario      (optional)
### Links                   (optional)
### Entry point / Scope     (optional)
### Applicability / Preconditions   (optional)
```

**Bug**

```
Title: [Area/Subarea] <short visible symptom> (optional: "<exact error text>")

### Environment
### Entry point / Scope
### Applicability / Preconditions   (optional)
### Test account                    (optional)
### Steps to reproduce
1. ...
### Actual result
### Expected result
- [ ] ...
### Links                           (optional)
### Evidence
```

**Title**
- One bracket prefix naming the functional area. Don't repeat what tracker fields already hold (project, component, environment, priority, sprint).
- Task: the result, not the symptom. Avoid empty verbs like "Improve", "Handle", "Refactor".
  - Good: `[Billing/Invoices] Download invoice as PDF from the invoice list`
  - Bad: `[Billing] Improve invoice handling`, `[Billing] Invoices can't be downloaded` (that's a bug title), `[MyApp/Frontend] ...` (repeats fields)
- Bug: the user-visible symptom and exact UI text, not a guessed cause.

**Context / Problem (Task)** — 1-3 sentences on what is wrong now and why it matters to users or the system. "The design splits this into a separate task" is not a problem statement; state the real problem first.

**Description (Task)** — the change at product or system level. Include technical constraints only when they were explicitly given or are required for correctness. No step-by-step implementation unless the user requires that exact approach.

**Acceptance criteria / Expected result** — the most important part.
- Unchecked checkboxes, one observable result per item: `- [ ] [Tag] <context> + <action> -> <observable result>`
- Tags (use when they help): `[UI]`, `[Business logic]`, `[API]`, `[Validation]`, `[Permissions]`, `[Persistence]`, `[Integration]`, `[Background job]`. Tags name behavior areas, not code layers.
- Every item must be checkable by a tester without reading code: visible UI state or copy, enabled/disabled action, HTTP status or response field, saved value after reload, permission outcome, job result.
- No soft wording unless defined in the same item: "properly", "correctly", "works as expected", "clear error", "friendly error", "smoothly", "usable", "handled", "where supported". Replace with what is actually observed.
  - Good: `- [ ] [Validation] User saves with an empty name -> save is blocked and the name field shows a validation message`
  - Bad: `- [ ] [Validation] Invalid input shows a clear error`
- No implementation wording ("implement", "support", "refactor", "fix") and no internal names (classes, methods, mocks, unit tests) unless part of a public API contract.
- For refactors or migrations with no intended behavior change, criteria describe behavior that must stay the same in the affected flows.
- If the observable result isn't known, go back to step 2 instead of writing something vague.

**Where other details go** — no extra "Technical notes", "Verification notes", "QA notes", or "Recheck" sections. Route needed details into existing ones: required constraint -> Description; route, page, endpoint, flow -> Entry point / Scope; role, plan, flag, account, fixture -> Applicability / Preconditions; tricky case or sample data -> Example / Scenario; specs, designs, parent issues -> Links (only useful links, never "see docs somewhere"). An implementation idea that wasn't required is left out.

**Bug specifics**
- Steps are factual, numbered, and minimal.
- `Test account` only when a dedicated test or non-production account is genuinely needed to reproduce. Never put personal, customer, or production credentials, tokens, or one-time codes in an issue, and never invent them.
- Evidence: a minimal representative set (1-3 files unless asked for more). Don't attach every screenshot you can find; ask which files to include if the user didn't say.

**Fields** — set what the project requires (from the schema or settings). If the project has a priority field, propose one: the user's value, else inferred from impact, else the tracker's normal/default level. Propose sprint or iteration only if the team uses it. Ask only about required values you can't determine. Field values never go in the description body.

Assumptions and omissions are listed in the approval message, not inside the issue body.

## 4. Duplicate check (tracker connected)

Before showing the draft for approval, search the target project with 1-3 focused queries built from the strongest signals: title words without the prefix, exact UI or error text, route or feature name, a core business term. Review the top matches, unresolved first.

- Likely duplicate = same requested change or same failure under materially the same conditions, not just the same area.
- If likely duplicates exist, stop, show their links with a one-line reason each, and ask whether to still create a new issue.
- Loosely related results: mention only if useful.

## 5. Approval draft

Show, in this order:
1. Target project, issue kind/type, and proposed field values
2. Duplicates reviewed (if any)
3. The issue in the **Issue language**, as a plain code block so it can be copied as-is
4. If the Issue language differs from the user's language, **a translation in the user's language**, also as a code block. Keep exact UI copy, identifiers, routes, code terms, and product names in their original form when translating them would lose precision
5. Evidence files to attach, assumptions, and notable omissions

Never present drafts as blockquotes. Then wait for explicit approval.

**Approval lock:** after approval, the approved Issue-language text is frozen. Write exactly that text; the translation is for review only and never goes into the tracker. If any wording should change, show the change and get approval again. Only field values already shown in the draft may be applied without re-approval.

## 6. Create (only after approval)

**Tracker connected:**
1. Build the title and body from the approved Issue-language version only. Right before writing, scan it for prose in the user's language that slipped in (allowed: exact UI copy, file names, URLs, identifiers, code, log excerpts, product names). If found, restore the approved text.
2. Create the issue with the connected tool, in that service's own terms (issue, ticket, card, page), with the approved field values.
3. Attachments: if the tool can upload files, upload only the approved ones, then update the Evidence section so each file is linked or embedded by its uploaded name. If upload isn't possible, say so and ask the user to attach them by hand. Never claim evidence is attached when it isn't. If the body can't be updated after upload, add the links in a comment and say so.
4. Fetch the created issue and check: correct language, required sections present, fields applied, checkboxes intact, no attachment left as a bare filename. Repair from the approved text if needed. If repair fails, report exactly what is wrong.
5. Return the issue key or ID and its link.

**No tracker connected:** give the final copy-ready draft (title, body, field values) as code blocks, and list the evidence files to attach by hand.

## Cautions

- Nothing is created, edited, commented on, or attached in a tracker without the user's approval of the draft.
- One issue per run. Split first if needed.
- No invented facts: steps, expected behavior, environment, credentials, field values, or root cause.
- Keep issues short and scannable. Bullets over paragraphs.
