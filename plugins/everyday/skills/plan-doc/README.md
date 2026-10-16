# plan-doc — development-ready planning documents

English | [한국어](README.ko.md)

A Claude Code skill that writes a planning document for a new feature, or for adding a feature to a product you already have.
It looks at how your product is organized today, researches how comparable products handle the same feature, compares 2-3 options, picks one, and splits it into phases. The result is meant to be built from and tested from on the same day:

- **Every screen has a state checklist**: normal, empty, loading, error, no permission, mobile, accessibility, multiple languages. No state is left as "handle appropriately".
- **Acceptance and QA test scenarios** are written under each screen, alongside the spec.
- **Nothing undecided is guessed.** Open choices are marked TBD with who needs to decide, and collected in one table at the end.

You don't need to be a developer. A code repo helps, but a product URL, screenshots, or a written description work too.

**When to use:** You need a planning document for a new feature, or for adding one to an existing product, that developers and QA can start from right away.

**Try saying:**
- "Plan this feature: bulk export for the admin console"
- "Write a planning doc for this"
- "Reflect this feedback in the plan"

**Needs:** nothing. Web search, a browser tool, or a docs connector make it better but are optional.

## Requirements
- Claude Code
- (Optional) Web search, for researching comparable products
- (Optional) A browser tool (e.g. Playwright MCP), to look around a running product
- (Optional) A connector for your document tool (Google Docs, Notion, Confluence, ...), if you want the document there instead of as a markdown file

## Install
1. Run these two lines in Claude Code (full instructions in the [root README](../../../../README.md))
   ```
   /plugin marketplace add JaeIm2/claude-workflow-kit
   /plugin install everyday@claude-workflow-kit
   ```
2. Type `/everyday:plan-doc` with what you want planned
3. On first run it asks:
   - Where to save documents (default `~/Documents/plans/`)
   - In what form (markdown file, or a document tool you use)
   - Whether your team has a planning document template
   - What language documents are written in

Settings are saved under `## plan-doc` in `~/.claude/workflow/config.md`, shared with the other skills in this kit. To change them, run `/everyday:plan-doc settings`.

## Usage
- `/everyday:plan-doc add a bulk export feature to our admin console` — it asks for anything missing: where the product is (repo, URL, screenshots), materials, and who makes the final calls
- "Reflect this feedback in the plan" + your comments — rewrites the document with your feedback; your decisions replace the matching TBDs

When it's done you get the file path, a 3-line summary of the recommendation, and the TBD list grouped by who decides.
Creating the document in an online tool, or sending it to anyone, happens only after you OK it.
