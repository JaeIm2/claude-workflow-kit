#!/usr/bin/env bash
# outsider: read-only review by an isolated Claude that knows none of your instructions, memory, or skills
#
#   outsider.sh code <file|dir>...      code review
#   outsider.sh code --diff [base]      review changes against base (default: merge-base with origin's default branch)
#   outsider.sh plan <doc>...           review a plan / spec / design doc
#   option: --model <alias>             reviewer model (default: CLI default)
#
# Isolation: --safe-mode (CLAUDE.md, memory, skills, hooks, plugins off) + --restricted (no access outside
#            the work folder) + --strict-mcp-config (MCP off) + only Read/Grep/Glob allowed.
# The reviewer gets only paths or the diff. Intent and background are deliberately not passed on.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REVIEW_DIR="$HOME/.claude/outsider/reviews"
CONFIG="$HOME/.claude/workflow/config.md"

usage() { sed -n '2,7p' "$0" | sed 's/^# \{0,1\}//'; exit 1; }

[[ $# -lt 1 ]] && usage
mode="$1"; shift
[[ "$mode" == "code" || "$mode" == "plan" ]] || usage

model_args=()
diff_base=""
use_diff=0
targets=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --model) model_args=(--model "$2"); shift 2 ;;
    --diff)
      use_diff=1; shift
      if [[ $# -gt 0 && "$1" != --* ]]; then diff_base="$1"; shift; fi ;;
    -h|--help) usage ;;
    *) targets+=("$1"); shift ;;
  esac
done

[[ "$mode" == "plan" && $use_diff -eq 1 ]] && { echo "plan mode does not support --diff" >&2; exit 1; }
[[ $use_diff -eq 0 && ${#targets[@]} -eq 0 ]] && usage

# Work folder: for --diff the current git root, otherwise the git root of the first target (or its folder)
if [[ $use_diff -eq 1 ]]; then
  workdir="$(git rev-parse --show-toplevel)"
else
  first="${targets[0]}"
  [[ -e "$first" ]] || { echo "no such path: $first" >&2; exit 1; }
  first_dir="$(cd "$(dirname "$first")" && pwd)"
  [[ -d "$first" ]] && first_dir="$(cd "$first" && pwd)"
  workdir="$(git -C "$first_dir" rev-parse --show-toplevel 2>/dev/null || echo "$first_dir")"
fi

# Targets as absolute paths; anything outside the work folder gets --add-dir
abs_targets=()
add_dirs=()
for t in ${targets[@]+"${targets[@]}"}; do
  [[ -e "$t" ]] || { echo "no such path: $t" >&2; exit 1; }
  if [[ -d "$t" ]]; then a="$(cd "$t" && pwd)"; d="$a"
  else d="$(cd "$(dirname "$t")" && pwd)"; a="$d/$(basename "$t")"; fi
  abs_targets+=("$a")
  [[ "$d" == "$workdir"* ]] || add_dirs+=(--add-dir "$d")
done

# Reviewer input: the target list, plus the diff body in --diff mode. Nothing else.
input="Review target(s):"
for a in ${abs_targets[@]+"${abs_targets[@]}"}; do input+=$'\n'"- $a"; done
if [[ $use_diff -eq 1 ]]; then
  if [[ -z "$diff_base" ]]; then
    default_ref="$(git -C "$workdir" symbolic-ref -q --short refs/remotes/origin/HEAD 2>/dev/null || true)"
    for ref in "$default_ref" origin/main origin/master; do
      [[ -n "$ref" ]] && diff_base="$(git -C "$workdir" merge-base HEAD "$ref" 2>/dev/null)" && break
    done
    [[ -z "$diff_base" ]] && diff_base=HEAD
  fi
  diff_text="$(git -C "$workdir" diff "$diff_base")"
  [[ -z "$diff_text" ]] && { echo "no diff (base: $diff_base)" >&2; exit 0; }
  input="Review this change (git diff against $diff_base). Repository root: $workdir"$'\n\n```diff\n'"$diff_text"$'\n```'
fi

# Review language: the Language line of the shared kit settings, else English
lang="$(sed -n 's/^- Language:[[:space:]]*//p' "$CONFIG" 2>/dev/null | head -n 1 || true)"
system_prompt="$(cat "$SCRIPT_DIR/$mode-prompt.md")"$'\n\n'"Write the whole review in ${lang:-English}, including the headings and tags."

mkdir -p "$REVIEW_DIR"
out="$REVIEW_DIR/$(date +%Y%m%d-%H%M%S)-$mode-$(basename "$workdir").md"

echo "[outsider] $mode review running... (work folder: $workdir)" >&2

# Cut off the calling session's Claude Code environment, and bypass any shell alias for claude
cd "$workdir"
printf '%s' "$input" | env -u CLAUDECODE -u CLAUDE_CODE_CHILD_SESSION -u CLAUDE_CODE_SESSION_ID \
  -u CLAUDE_CODE_MESSAGING_SOCKET -u CLAUDE_CODE_MESSAGING_TOKEN -u CLAUDE_CODE_SESSION_ATTENDED \
  -u CLAUDE_PID -u CLAUDE_CODE_ENTRYPOINT \
  claude -p \
    --safe-mode --restricted --strict-mcp-config \
    --permission-mode default \
    --append-system-prompt "$system_prompt" \
    ${model_args[@]+"${model_args[@]}"} \
    ${add_dirs[@]+"${add_dirs[@]}"} \
    --tools "Read,Grep,Glob" \
  | tee "$out"

echo >&2
echo "[outsider] saved: $out" >&2
