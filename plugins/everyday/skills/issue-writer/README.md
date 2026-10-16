# issue-writer — clear issues for any work tracker

English | [한국어](README.ko.md)

A Claude Code skill that turns a request, notes, or a bug description into one well-structured issue: a feature or task with testable acceptance criteria, or a bug report with reproduction steps and expected results.
When the request is vague, it asks one question at a time until the issue is clear enough to work on, instead of guessing.

**When to use:** You need to file a task or bug, or turn a vague request from someone into an issue the team can actually work on.

**Try saying:**
- "Write a ticket for this"
- "File a bug: the save button does nothing on the profile page"
- "Turn this into a task"
- "Just make it draft-ready, don't create it"

**Needs:** nothing to get a draft. A work tracker connection lets it check for duplicates and create the issue after you approve.

## Requirements
- Claude Code
- (Optional) An MCP server or connector for your work tracker (Jira, Linear, GitHub Issues, Notion, Asana, YouTrack, ...). With one, it checks for duplicates and creates the issue after you approve. Without one, it gives you a copy-ready draft

## Install
1. Run these two lines in Claude Code (full instructions in the [root README](../../../../README.md))
   ```
   /plugin marketplace add JaeIm2/claude-workflow-kit
   /plugin install everyday@claude-workflow-kit
   ```
2. Type `/everyday:issue-writer` with your request, or just say "write a ticket for this"
3. On first run it asks a few questions:
   - Where you manage your work (skipped if another skill in this kit already asked)
   - What language issues should be written in (it can differ from the language you chat in)
   - The project issues usually go to
   - Any required fields or team template (you can paste an example issue)

Settings are saved to `~/.claude/workflow/config.md`, shared with the other skills in this kit. To change them, run `/everyday:issue-writer settings`.

## Usage
- "Write a task: users should be able to download invoices as PDF" — clarifies scope and acceptance criteria, then drafts
- "File a bug: the save button does nothing on the profile page" + screenshot — asks for what's missing (steps, expected result), then drafts
- Paste a vague request from a colleague — figures out whether it's a task or a bug, clarifies, then drafts
- "Just make it draft-ready, don't create it" — stops at the draft

What a draft looks like:
- A title with one area prefix, e.g. `[Billing/Invoices] Download invoice as PDF from the invoice list`
- Acceptance criteria or expected results as checkboxes, each one something a tester can see
- If issues are written in a different language from yours, a translation is shown next to it

Drafts are shown as plain code blocks so you can copy them as-is. Nothing is created in your tracker until you approve the draft.
