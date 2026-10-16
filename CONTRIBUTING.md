# Writing a skill for claude-workflow-kit

Every skill in this kit follows the rules below. `plugins/everyday/skills/wsid` is the reference implementation.

## Layout

```
plugins/<plugin>/
├── .claude-plugin/plugin.json
├── skills/<skill>/
│   ├── SKILL.md
│   ├── README.md        (English)
│   ├── README.ko.md     (Korean)
│   └── <bundled files>
└── hooks/hooks.json     (only if the plugin ships hooks)
```

- `everyday` is for everyone. `dev` is for developers.
- Skills are called as `/<plugin>:<skill>` (e.g. `/everyday:wsid`). Use that form whenever one skill mentions another.
- Refer to bundled files from SKILL.md as `${CLAUDE_PLUGIN_ROOT}/skills/<skill>/<file>`. Never write state inside the plugin folder; it is replaced on update.
- Register every new plugin in `.claude-plugin/marketplace.json` and run `claude plugin validate ./` before committing.

## Content rules

1. **No company or personal details.** No names, internal URLs, repo paths, project keys, customer names, server addresses, or accounts. Example values look like `PROJ`, `<your build command>`, `~/Documents/work-notes.md`.
2. **Ask on first run instead of hardcoding.** Anything that differs between workplaces (work tracker, where notes live, repos, branch rules, build and test commands, how to confirm a deploy) is asked once and saved.
3. **One shared settings file:** `~/.claude/workflow/config.md`.
   - `## Common` holds values any skill may reuse: `Language`, `Work tracker` (with its saved searches), `Personal notes documents`, `Work records location`, `Repos`, `Briefing read-only tools`.
   - Each skill keeps its own values under `## <skill>`.
   - A skill reads the file first, asks only for what is missing, and never removes or rewrites another skill's section.
   - Headings and labels stay in English exactly as written so other skills can find them. Values may be in any language.
4. **Not tied to one service.** Ask "Where do you manage your work?" (or the equivalent), then look for a connected MCP server or connector for that service and use it in that service's own terms. If none is connected, explain how to add one and carry on without it.
5. **Anything that leaves the machine stops at a draft.** Sending messages or emails, creating or editing items in a work tracker, posting comments, and pushing code all wait for the user's approval.
6. **Keep the hard-won rules.** Rules that came from real mistakes (confirm the deploy before asking for review, check the branch upstream, review repeatedly before handing off) stay, written in general terms.
7. **Shared work records.** To-dos go in `<Work records location>/todo.md` and multi-day work logs go in `<Work records location>/notes/<task>.md`, in the format wsid defines. Skills that track tasks use these instead of inventing their own.
8. **Personal rules.** Every SKILL.md carries the same "Personal rules" section right after the Language line (copy it from wsid and change only the skill name). Each user's skips, additions, and corrections go to `~/.claude/workflow/rules/<skill>.md` under `## Skip`, `## Add`, `## Avoid`, and override the skill, except the approval rule in point 5. Repo-specific UI rules stay in the repo's conventions file. Never write rules into the plugin folder.

## Language

- Write SKILL.md, scripts, and comments in English.
- Every SKILL.md tells Claude to talk to the user in the language they use.
- Put trigger phrases in both English and Korean in the `description`.
- Write README.md in English and README.ko.md in Korean, each linking to the other at the top.

## Before committing

- Search the repo for names, internal URLs, and customer names. The result must be zero.
- `claude plugin validate ./`
- Add the skill to the tables in the root `README.md` and `README.ko.md`.
