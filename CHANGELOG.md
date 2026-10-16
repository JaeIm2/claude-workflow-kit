# Changelog

English | [한국어](CHANGELOG.ko.md)

## 0.2.0 — 2026-10-16

### Added
- `/everyday:doctor` — checks your settings, connected tools, work records, personal rules, morning briefing, and (if installed) the dev plugin, and tells you how to fix what's wrong. If nothing is set up yet, it offers to set everything up in one go. It can also write a privacy-stripped summary to share when asking for help.
- Personal rules that are useful to everyone are collected in `~/.claude/workflow/suggestions.md`, so you can send them to the kit as one issue whenever you like.
- Trigger tests for every skill (Korean and English phrases), run with `claude plugin eval`.
- Automatic checks on every push (plugin format, README pairs, links, script syntax, privacy).

### Changed
- READMEs rewritten for non-developers: pick by situation, phrases to try, what each skill needs, and example conversations.
- `wsid` and `ui-work` now trigger more reliably from natural speech (for example a pasted email with "what should I do with this?", "오늘 뭐하지", "다이얼로그 추가해줘").
- Update instructions corrected: refreshing the marketplace alone doesn't update installed plugins.

## 0.1.0 — 2026-10-16

First release: 11 skills in two plugins (`everyday`, `dev`) and the push-guard hook.
