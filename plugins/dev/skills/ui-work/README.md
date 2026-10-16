# ui-work — confirm before building UI, verify in a browser, remember corrections

English | [한국어](README.ko.md)

A Claude Code skill for building or changing screens, components, dialogs, and UX flows.
It follows your repo's UI conventions, confirms the structure with you before writing code, checks the result in a real browser before calling it done, and writes every correction you make into the conventions file so you never have to give the same correction twice.

## Requirements
- Claude Code
- A browser automation tool for self-verification (e.g. Playwright MCP: `claude mcp add playwright -- npx @playwright/mcp@latest`). Without one, the skill still works but tells you what it couldn't check
- (Optional) A Figma MCP server, if your designs live in Figma

## Install
1. Run these two lines in Claude Code (full instructions in the [root README](../../../../README.md))
   ```
   /plugin marketplace add JaeIm2/claude-workflow-kit
   /plugin install dev@claude-workflow-kit
   ```
2. Ask for UI work in a repo, or type `/dev:ui-work`
3. The first time in each repo it looks around and asks you to confirm a few things:
   - How to start the app locally and at what URL
   - Where the UI conventions file is (default `.claude/ui-conventions.md` in the repo)
   - Whether translation files are edited directly or managed in an external service
   - How to sign in when checking screens (passwords are never saved)

Settings are saved under `## ui-work` in `~/.claude/workflow/config.md`, shared with the other skills in this kit. To change them, run `/dev:ui-work settings`.

## What it does
1. **Loads your conventions.** If the repo has none, it studies the code (component library, styling approach, spacing and typography tokens, how existing screens handle loading, empty, and error states) and drafts a conventions file for you to confirm, citing a file for each rule.
2. **Reads the design** from a Figma link or screenshots, if there is one.
3. **Confirms the structure** in 3-5 lines before coding: where it goes, what's reused, what happens on success and failure, edge cases. Ambiguous requirements get both readings, not a guess.
4. **Implements** following the conventions, changing only what the request needs.
5. **Verifies in a browser**: opens the screen, operates it, checks the states, then closes the browser and deletes the screenshots.
6. **Reports** what it built and checked, and marks the decisions it made on its own so you can reverse them easily.

When you correct the result ("this should be a toast, not a modal"), the rule goes into the conventions file right away.

## Usage
- "Add a delete confirmation dialog to the settings page"
- `/dev:ui-work` + a Figma link or screenshot
- "That should be inline, not a toast" — fixes it and records the rule
