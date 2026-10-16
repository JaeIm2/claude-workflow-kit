---
name: plan-doc
description: Use when the user wants a development-ready planning document for a new feature or for adding a feature to an existing product — "write a planning doc", "plan this feature", "write a spec/PRD", "how should we fit X into our product", "/everyday:plan-doc", "기획해줘", "기획서 써줘", "이 기능 어떻게 넣을지 기획해줘". Also for revising a planning document after feedback ("reflect this feedback in the plan", "기획서 피드백 반영해줘"), and for "/everyday:plan-doc settings" or "/everyday:plan-doc 설정".
---

# Plan doc — development-ready planning documents

Gather the context, then produce a planning document that a developer can start building from and a QA tester can start testing from on the same day. The planning method lives in the bundled guide `${CLAUDE_PLUGIN_ROOT}/skills/plan-doc/planner.md`. Your job here is to feed it well and relay the result.

Three things set these documents apart:

1. Every screen has a **state checklist**: normal, empty, loading, error, no permission, mobile, accessibility, multiple languages.
2. **Acceptance and QA test scenarios** are written alongside the spec, not afterwards.
3. Anything not decided is marked **TBD** (in the document's language) with who needs to decide it. Nothing is guessed.

Anyone can use it. Exploring a code repo is optional; a product URL, screenshots, or a written description also work.

**Language:** Always talk to the user in the language they use. Write the document in the `Document language` from settings.

## Personal rules (always, before anything else in this skill)

This skill is shared, so each user shapes it with their own rules. Read `~/.claude/workflow/rules/plan-doc.md` if it exists and follow it on top of this file. Where the two conflict, the personal rule wins, with one exception: anything that leaves the machine (sending, posting, creating or editing items in a tracker, pushing) still waits for approval. If a rule asks to skip that approval, keep asking and say why.

Add a rule when the user:
- points out a mistake or something missed ("you forgot ...", "that's wrong") → under `## Avoid`
- says they don't want a step ("don't ...", "skip ...", "stop ...") → under `## Skip`
- wants something extra every time ("always ...", "also ...") → under `## Add`

Write one line in general terms, then ` — why: <reason or what happened, a few words> (YYYY-MM-DD)`. If the rule holds in only one repo or project, start it with `[<repo or project name>]` and apply it only there. Create the file with those three headings if it doesn't exist. If an existing line already covers it, update that line instead of adding another. Don't record one-offs ("just this time"); if unsure whether it should be permanent, ask. Announce each change in one line: `Rule added: ...`.

If a rule looks useful for everyone, not just this user, also append it to `~/.claude/workflow/suggestions.md` (skill name, the rule, why, date) and say so in one line. Don't open an issue on your own; when the user wants to send the collected suggestions, draft one issue for https://github.com/JaeIm2/claude-workflow-kit/issues from that file, and the user posts it.

## 0. Check settings (always first)

Read the shared settings file `~/.claude/workflow/config.md` (`## Common` plus one section per skill, shared by every skill in claude-workflow-kit). Use the `## plan-doc` section.

- **If the file or any item below is missing** → ask for just the missing items, then continue with the original request. Don't ask again for anything another skill already filled in (e.g. `Language`, `Repos` in Common).
- **If the user says "/everyday:plan-doc settings" (or "설정")** → show the current values and ask again only about the items they want to change.

Ask one at a time. If the user skips, use the default.

1. **Output location** — "Where should planning documents be saved?" Default `~/Documents/plans/`.
2. **Output format** — "In what form do you want them? (a markdown file, or a document in a tool you use such as Google Docs, Notion, Confluence)" For an online tool, look for a connected MCP server or connector for it. If connected, record its name; the document is still written as a local markdown file first and created in the tool only after the user OKs it. If not connected, tell the user they can add one and record "markdown file (copy over by hand)".
3. **Template** — "Does your team have a planning document template? Give me a file path or a link, or say no." If yes, check that it can be read and record it. If no, record "default" (the structure in `planner.md`).
4. **Document language** — record `Language` from Common (or the language the user writes in) unless they say the team writes documents in another language.

Never remove or rewrite another skill's section. Keep headings and labels in English exactly as written; values may be in any language.

```
## plan-doc
- Output location: ~/Documents/plans
- Output format: markdown file          (or: Notion via connected tool, created after the user OKs)
- Template: default                     (or: ~/Documents/templates/feature-spec.md)
- Document language: Korean
```

## 1. Collect the inputs

From the conversation first; ask only for what is genuinely missing, one question at a time.

- **Feature** — what is being planned, in one line (e.g. "add team calendars to the project app", "a bulk export feature for the admin console").
- **Target product** — where it will live. Any of these, as many as are available:
  - a code repo path (check `Repos` in Common first)
  - a URL of the running product (explored with a browser tool, if one is available)
  - screenshots, a screen recording, or a written description of the current screens
  - nothing yet (a brand-new product)
- **Materials** — specs, prototypes, meeting notes, customer requests, earlier versions of the plan. Paths or links; check that each can actually be read.
- **Decision owners** — "Who makes the final call on this? (e.g. product owner, design lead, engineering lead, a client)" Names or roles. These become the "who decides" of every TBD. If unknown, roles will be used.
- **Known decisions and constraints** — anything already decided, deadlines, things that must not change, budget or team size.

Don't pre-digest repo or product contents here; the planning step explores them itself.

The output file name is `YYYY-MM-DD-<feature-slug>-plan.md` in the output location (translate "plan" into the document language if the user prefers). Create the folder if needed.

## 2. Write the document

If you can launch a subagent (the Agent tool), dispatch a general-purpose agent so the research runs in its own context. Use this prompt, filling every bracket and adding no process instructions of your own (the guide owns the process):

```
Read ${CLAUDE_PLUGIN_ROOT}/skills/plan-doc/planner.md and follow it exactly.

Feature: [one line]
Target product: [repo paths / product URL / screenshot paths / "new product"]
Materials: [absolute paths or links]
Template: [path or link, or "default"]
Document language: [language]
Output path: [absolute path to the markdown file]
Decision owners: [names or roles and what each decides]
Known decisions and constraints:
- [...]
Feedback to reflect (re-runs only): [the user's feedback, verbatim]
```

If you can't launch a subagent, read `planner.md` yourself and follow it.

**Re-runs after feedback:** dispatch a fresh run, put the user's feedback verbatim in "Feedback to reflect", and add the previous document as a material. Decisions the user made in their feedback replace the matching TBDs.

## 3. Relay the result

Check that the output file exists and is complete (no section left as a placeholder). Then give the user:

- the file path
- the recommendation in 3 lines (what, where it lives in the product, what Phase 1 includes)
- the TBD list, grouped by who decides. This is what needs input next.

Don't paste the whole document into chat.

If the output format is an online tool, offer to create the document there. Create it only after the user OKs it, and give them the link.

## Cautions

- Anything that leaves the machine (creating or editing a document in an online tool, sending the plan to someone, filing tickets from it) stops at a draft and runs only after the user OKs it.
- Never fill a TBD with your own guess, even when asked to "just finish it". You may add a recommended option to a TBD, labeled as a recommendation.
- The user's template wins over the default structure, but the state checklist, the QA scenarios, and the TBD list must still appear somewhere in it.
