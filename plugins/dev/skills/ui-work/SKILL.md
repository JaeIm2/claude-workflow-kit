---
name: ui-work
description: Use when implementing or modifying any user-facing UI — new screens, components, dialogs, layout changes, UX flows — invoke it first, before exploring or writing the UI code, and when a task comes with a Figma link or design screenshots ("build this screen", "add a dialog", "change the layout", "화면 만들어줘", "이 컴포넌트 추가해줘", "다이얼로그 추가해줘", "레이아웃 바꿔줘", "UI 수정해줘"). Also use when the user corrects UI output ("this should be a toast, not a modal", "the wording tone is off", "여긴 모달 말고 토스트지", "문구 톤이 아니야"), and for "/dev:ui-work settings" or "/dev:ui-work 설정".
---

# UI work routine

A fixed routine that stops UI and UX work from being finished in a direction the user didn't intend. The core idea: **catch mismatches at the confirmation step, not after implementation.**

**Language:** Always talk to the user in the language they use. Write the conventions file in that language too. The templates below are in English only as examples; translate their headings when you create the file.

## Personal rules (always, before anything else in this skill)

This skill is shared, so each user shapes it with their own rules. Read `~/.claude/workflow/rules/ui-work.md` if it exists and follow it on top of this file. Where the two conflict, the personal rule wins, with one exception: anything that leaves the machine (sending, posting, creating or editing items in a tracker, pushing) still waits for approval. If a rule asks to skip that approval, keep asking and say why.

Add a rule when the user:
- points out a mistake or something missed ("you forgot ...", "that's wrong") → under `## Avoid`
- says they don't want a step ("don't ...", "skip ...", "stop ...") → under `## Skip`
- wants something extra every time ("always ...", "also ...") → under `## Add`

Write one line in general terms, then ` — why: <reason or what happened, a few words> (YYYY-MM-DD)`. UI rules that belong to one repo go in that repo's conventions file instead (see "Learning from corrections" below); this file is for the user's own preferences across repos. Create the file with those three headings if it doesn't exist. If an existing line already covers it, update that line instead of adding another. Don't record one-offs ("just this time"); if unsure whether it should be permanent, ask. Announce each change in one line: `Rule added: ...`.

If a rule looks useful for everyone, not just this user, also append it to `~/.claude/workflow/suggestions.md` (skill name, the rule, why, date) and say so in one line. Don't open an issue on your own; when the user wants to send the collected suggestions, draft one issue for https://github.com/JaeIm2/claude-workflow-kit/issues from that file, and the user posts it.

## 0. Check settings (always first)

Read the shared settings file `~/.claude/workflow/config.md` (`## Common` plus one section per skill, shared by every skill in claude-workflow-kit). Use the `## ui-work` section, which holds one entry per repo.

- **If the file, the `## ui-work` section, or the entry for the current repo is missing** → run first-run setup for just the missing items, then continue with the original request. Don't ask again for anything another skill already filled in.
- **If the user says "/dev:ui-work settings" (or "설정")** → show the current values and ask again only about the items they want to change.

### First-run setup (per repo)

Find each answer in the repo first and ask only to confirm or fill gaps. One question at a time.

1. **Dev server** — look at `package.json` scripts, `README`, `Makefile`, `docker-compose`, and similar for the command that starts the app locally and the URL it serves. Ask "Is `<command>` at `<URL>` right?" If nothing is found, ask "How do you run this app locally, and at what URL?"
2. **Conventions file** — default `<repo>/.claude/ui-conventions.md`. If the team keeps UI rules somewhere else (a design system doc, `CONTRIBUTING.md`), record that path instead. If none exists, it is drafted in step 1 of the workflow.
3. **UI text and translations** — if the repo has i18n (locale files, a `t()` style helper), ask "Do you edit translation files directly, or are they managed in an external translation service?" Record which, plus any check command (e.g. `<your i18n check command>`). If there's no i18n, record "none".
4. **Signing in for checks** — if screens need a login, ask how to sign in for verification (a test account the user enters, a seeded local user, a dev bypass). **Never write passwords into the config file.** Record only the method, e.g. "ask the user each time".
5. **Browser tool** — look for a browser automation tool in this session (e.g. Playwright MCP, a browser extension, a built-in browser). Record its name. If none is available, tell the user they can add one (for example `claude mcp add playwright -- npx @playwright/mcp@latest`) and record "none"; until then, verification falls back to what can be checked without a browser, and you say so in the report.

Never remove or rewrite another skill's section. Keep headings and labels in English exactly as written; values may be in any language.

```
## ui-work
- Browser tool: Playwright MCP
- Repos:
  - ~/code/web-app
    - Dev server: `npm run dev` at http://localhost:3000
    - Conventions: .claude/ui-conventions.md
    - UI text: translation files edited directly, check with `<your i18n check command>`
    - Sign-in for checks: ask the user each time
  - ~/code/admin
    - Dev server: `<your dev command>` at http://localhost:5173
    - Conventions: docs/ui-guidelines.md
    - UI text: managed in an external translation service, do not edit files
    - Sign-in for checks: none needed
```

## Workflow

### 1. Load the conventions

Read the repo's conventions file. New UI must follow its patterns (shared components, when to use a modal vs. a toast vs. inline messages, how loading and empty states are shown). If a judgment isn't covered by the file, find 2-3 similar existing screens and follow their pattern.

**If there is no conventions file, draft one before any UI work.** Investigate the codebase, don't guess:

- **Component library** — dependencies in `package.json` (or the platform's equivalent), plus any in-house shared component folder. Note which components are actually used for buttons, inputs, dialogs, toasts, tables, and empty states.
- **Styling approach** — CSS modules, utility classes, CSS-in-JS, plain CSS or SCSS, a theme object. Note anything clearly avoided.
- **Tokens** — spacing, typography, color, radius, breakpoints: where they are defined (theme file, CSS variables, config) and the commonly used values. Note hard-coded values that appear often.
- **Existing patterns** — open 3-5 representative screens and note how they handle loading, empty, error, confirmation of destructive actions, success feedback, long text, forms and validation, and mobile or narrow widths.
- **UI text** — wording tone, sentence vs. title case, how translation keys are named (if i18n exists).

Write only what you saw, and cite a file path for each rule so the user can check it. Where screens disagree, list both and ask which is the rule. Show the draft to the user and save it only after they confirm it.

```
# UI conventions

## Components
- Buttons, inputs, dialogs: <library or in-house folder> (e.g. src/components/ui/Button.tsx)
- Toasts: <component> for success and recoverable errors
- Never: <components or patterns to avoid>

## Styling
- Approach: <how styles are written>
- Spacing / typography / color: use tokens from <file>; don't hard-code values

## States
- Loading: <skeleton | spinner | ...> (e.g. src/pages/Orders/List.tsx)
- Empty: <illustration + text + action | text only>
- Error: <inline | toast | full-page>
- Destructive actions: <confirmation dialog pattern>

## Text
- Tone: <e.g. short, polite, no exclamation marks>
- Translations: <edit files directly | external service>

## Learned from corrections
- YYYY-MM-DD: <rule> (why)
```

### 2. Check the design source

- **Figma link** → if a Figma tool is connected, read the spec directly from it (design context, plus a screenshot of the frame). If not, ask for screenshots or exported specs.
- **Screenshots only** → use them as the reference.
- **No design at all, and the screen has to be built from scratch** → propose the structure in enough detail to act as a rough mockup in step 3.

### 3. Confirm before implementing (required)

Before writing code, present a short summary and get the user's OK:

- Which screen and where, and with what structure (which existing components are reused)
- Interactions: what appears on click, and what the user sees on success and on failure (modal? toast? inline?)
- Edge cases: empty, loading, error, long text, mobile (when relevant)
- If a requirement can be read two or more ways, don't pick one; present both

Keep it to 3-5 lines. The point is catching mismatches early, not asking permission. Simple changes (wording, small style tweaks) may skip this step, but if a "simple" change turns out to need structural changes, come back to this step at that point.

### 4. Implement

Follow the conventions. Change only what the request needs; don't "improve" unrelated nearby code, comments, or formatting. For UI text, follow the recorded translation method: if strings are managed in an external service, don't edit translation files; list the new or changed keys and their text for the user to register.

### 5. Self-verify (required)

Check it yourself before reporting:

- Start the dev server (or use the one already running) and, with the browser tool, open the screen, operate it, and take screenshots.
- Check: anything missing against the requirements? Convention violations? Do the empty, loading, and error states behave correctly? Did any existing screen break?
- **Stress the layout with extreme data and measure it (required).** Checking only the scenario you designed misses overflow and overlap. Include the existing layout that wraps your change (grids, cards).
  - Feed extreme data: a wide table (10+ columns with set widths), 40+ character emails and names, a 100-character title, a long URL with no break points, empty values.
  - At 1440, 1280, 390, and 320px wide, measure with the browser tool's script evaluation:
    - No horizontal page overflow: `document.documentElement.scrollWidth <= innerWidth`
    - No text spilling out of its box (any element with `scrollWidth > clientWidth` must be handled with ellipsis or scrolling)
    - No overlapping lines or elements
    - Font size, weight, and color stay within the values the surrounding existing screens use (compare against real screens, not demo values)
  - Unit tests in jsdom don't compute layout, so passing tests say nothing about these.
- Save screenshots to a temporary folder outside the repo, never inside the project.
- When done, **close the browser and delete the screenshots.** Stop the dev server if you started it, unless the user wants it left running.

If something can't be verified (no browser tool, sign-in unavailable, needed data missing), say exactly what wasn't checked. Don't report it as verified.

### 6. Report

Based on what the screenshots showed, report what was built, what was checked, and what you decided on your own. Mark every decision you made without the user's input clearly, so it's easy for them to reverse. Include the layout measurements (page `scrollWidth` vs `innerWidth` at each width, number of overflowing elements), so only the judgment of how it looks is left to the user.

## Learning from corrections (important)

When the user corrects the UI output ("this should be a toast, not a modal", "the wording tone is off"), add it to the repo's conventions file as a rule **right then**, under "Learned from corrections" or in the section it belongs to, with the date and the reason. Tell the user in one line (`Added to UI conventions: ...`). Never needing the same correction twice is the reason this skill exists.

## Cautions

- If the conventions file and the actual code disagree, trust the code (the more recently written side) and suggest updating the file.
- The conventions file lives in the repo. Committing it, like any code change, follows the user's usual workflow; don't push on your own.
- Keep the pre-implementation confirmation short. No long essays.
