#!/bin/sh
# push-guard: PreToolUse hook for the Bash tool.
# Any command containing "git push" gets a permission prompt, so nothing is pushed
# without the user's explicit OK. The prompt's reason names the riskiest thing found:
#   1. force push (--force / -f / +refspec)
#   2. a protected branch named in the push (main, master, develop, release*)
#   3. no target given (goes to the branch's upstream; if the upstream is
#      main/develop, a feature branch lands straight on it - a real accident this
#      guard was written after)
# Every other command passes through untouched (exit 0, no output).

input=$(cat)
if command -v jq >/dev/null 2>&1; then
  cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null)
else
  # No jq: look at the raw JSON. Coarser, but the guard still fires.
  cmd=$input
fi

case "$cmd" in
  *"git push"*) ;;
  *) exit 0 ;;
esac

ask() {
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"%s"}}\n' "$1"
  exit 0
}

# A line can chain several commands; look only at the git push part
push=$(printf '%s' "$cmd" | sed -n 's/.*\(git push[^;&|"]*\).*/\1/p' | head -n 1)
[ -z "$push" ] && ask "git push detected - confirm before pushing."

# 1) Force push. --force-with-lease is the normal way to update a rebased feature branch, so it is not flagged here.
if printf '%s' "$push" | grep -Eq -- '(--force([^-]|$)|[[:space:]]-f([[:space:]]|$)|[[:space:]]\+[A-Za-z0-9_./-]+:?)'; then
  ask "Force push (--force / -f / +refspec) - check the target before going ahead."
fi

# 2) Protected branch named in the push
if printf '%s' "$push" | grep -Eq '(^|[[:space:]:/])(main|master|develop)([[:space:]]|:|$)|release'; then
  ask "Push to a protected branch (main/master/develop/release) - this goes straight onto it."
fi

# 3) No target. It goes to the current branch's upstream; if that is main/develop, it lands there.
stripped=$(printf '%s' "$push" \
  | sed -E 's/^git push//; s/(^|[[:space:]])(--[A-Za-z-]+=[^[:space:]]+|--[A-Za-z-]+|-[A-Za-z]+)//g; s/^[[:space:]]*//; s/[[:space:]]*$//')
case "$stripped" in
  "")      ask "git push with no target - it goes to the current branch's upstream. Run git branch -vv first: if the upstream is main/develop, it lands there." ;;
  origin)  ask "git push origin with no branch - it goes to the current branch's upstream. Run git branch -vv first: if the upstream is main/develop, it lands there." ;;
esac

target=$(printf '%s' "$stripped" | tr -d '"\\' | tr -s '[:space:]' ' ')
ask "git push to: ${target} - confirm before pushing."
