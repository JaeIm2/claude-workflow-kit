# weekly-report — weekly report draft in your own format

English | [한국어](README.ko.md)

A Claude Code skill that writes your weekly report draft. It gathers the week's work from the places you choose, groups it into work items you can track week to week, asks about anything those places missed, and prints a copy-paste-ready draft in your team's format. You submit it yourself; the skill never sends anything.

## Requirements
- Claude Code
- (Optional) An MCP server or connector for your work tracker (Jira, Linear, Notion, Asana, GitHub Issues, YouTrack, ...)
- (Optional) Python 3, for scanning your Claude Code session history

## Install
1. Run these two lines in Claude Code (full instructions in the [root README](../../../../README.md))
   ```
   /plugin marketplace add JaeIm2/claude-workflow-kit
   /plugin install everyday@claude-workflow-kit
   ```
2. Type `/everyday:weekly-report`
3. On first run it asks:
   - What your report looks like (paste last week's report or a blank template)
   - Anything your reader dislikes or always wants (e.g. no ticket IDs)
   - Where to gather from: your to-dos and work notes (from `/everyday:wsid`), git history in your repos, your work tracker, Claude Code session history
   - What period a report covers and when it's due
   - How you submit it (form, email, chat, sheet)

Settings are saved to `~/.claude/workflow/config.md`, shared with the other skills in this kit. To change them, run `/everyday:weekly-report settings`.

## Usage
- `/everyday:weekly-report`, or "write up my weekly report"

What happens:
1. It reads last week's report so continuing work keeps exactly the same name
2. It gathers the week's work and groups it into a handful of items
3. It shows sessions and work that no tracker recorded and asks which to include, then asks about offline work (meetings, visits)
4. You review a draft table and fix anything
5. It prints the final draft, one copy-paste block per submission, and saves it under `~/.claude/workflow/weekly-reports/`

It checks your format's rules for you: allowed values, totals that must add up to 100, progress that shouldn't go down from last week.
It never overwrites a saved report without asking, since you may have edited it.
