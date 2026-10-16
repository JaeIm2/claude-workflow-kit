# wsid — inbox for anything + to-dos and work notes + morning briefing

English | [한국어](README.ko.md)

A Claude Code skill: paste in a message, email, meeting note, or request, and it figures out how to handle it, while automatically recording the to-dos and progress that come out of it.
Call it with nothing and it pulls together your notes and linked sources into a "what to do first today" briefing. Schedule it in the morning and the briefing is ready before you start work.

## Requirements
- Claude Code
- (Optional) An MCP server or connector for the service you track work in (Jira, Linear, Notion, Asana, GitHub Issues, YouTrack, ...). Without one, wsid works from its own to-do list and notes
- (Optional) A connector for wherever your personal notes live (Google Drive, Notion, ...), if they're online

## Install
1. Run these two lines in Claude Code (full instructions in the [root README](../../../../README.md))
   ```
   /plugin marketplace add JaeIm2/claude-workflow-kit
   /plugin install everyday@claude-workflow-kit
   ```
2. Type `/everyday:wsid`
3. On first run it asks a few questions. Answer them and you're set.
   - Where you manage your work (it checks whether that service is connected)
   - Whether you keep a document of your regular work (local path or link)
   - Where to keep your to-do list and work notes (default `~/.claude/wsid/`)

Settings are saved to `~/.claude/wsid/config.md`. To change them, run `/everyday:wsid settings`.

## Usage
- `/everyday:wsid` — briefing on what to do first today
- `/everyday:wsid` + paste a Slack message, email, or meeting note — summary, reply draft, and to-dos added automatically
- "Add this to my to-dos", "That's done" — updates the to-do list
- "Let's continue the quote task" — reads the work notes and picks up where you left off

To-dos live in a single `todo.md`. Work that takes more than a day gets its own file under `notes/`.
External actions like sending messages, emails, or creating items in your work tracker stop at a draft and run only after you approve.

## Morning briefing (optional, macOS)
Finish the install and first-run setup above before this.

1. Download the script and schedule file in your terminal
   ```
   mkdir -p ~/.claude/scripts
   curl -fsSL https://raw.githubusercontent.com/JaeIm2/claude-workflow-kit/main/plugins/everyday/skills/wsid/morning-briefing.sh -o ~/.claude/scripts/morning-briefing.sh
   curl -fsSL https://raw.githubusercontent.com/JaeIm2/claude-workflow-kit/main/plugins/everyday/skills/wsid/morning-briefing.plist -o ~/Library/LaunchAgents/morning-briefing.plist
   ```
2. In `~/Library/LaunchAgents/morning-briefing.plist`, replace `YOUR_NAME` with your account name (run `whoami` in the terminal)
3. `launchctl load ~/Library/LaunchAgents/morning-briefing.plist`
4. Test it now: `bash ~/.claude/scripts/morning-briefing.sh` — if a file appears in `~/.claude/briefings/`, it works

It runs on weekdays at 08:45, saves the result to `~/.claude/briefings/briefing-YYYY-MM-DD.md`, and shows a notification. Files older than 14 days are deleted automatically.
The scheduled run is read-only (it never changes your to-dos, notes, or work tracker). It may only use the read-only tools that setup recorded.
