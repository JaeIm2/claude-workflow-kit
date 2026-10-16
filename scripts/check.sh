#!/usr/bin/env bash
# Repository checks for claude-workflow-kit. Runs on macOS and Linux.
# Usage: scripts/check.sh    (exits non-zero if any check fails)
#
# Optional: put extra case-insensitive grep -E patterns (one per line) in
# scripts/private-patterns.txt. That file is gitignored and only used locally.

set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT" || exit 2

FAILS=0
fail() {
  printf 'FAIL: %s\n' "$*"
  FAILS=$((FAILS + 1))
}
section() {
  printf '\n== %s\n' "$*"
}

# Files that would be committed (tracked + untracked, minus gitignored).
list_files() {
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git ls-files -co --exclude-standard | while IFS= read -r f; do
      [ -f "$f" ] && printf '%s\n' "$f"
    done
  else
    find . -path ./.git -prune -o -type f -print | sed 's|^\./||'
  fi
}

FILES="$(list_files)"

# ---------------------------------------------------------------------------
section "README pairs (README.md + README.ko.md, linked at the top)"
for dir in plugins/*/skills/*/ plugins/*/hooks/; do
  [ -d "$dir" ] || continue
  dir="${dir%/}"
  en="$dir/README.md"
  ko="$dir/README.ko.md"
  if [ ! -f "$en" ]; then fail "$dir: missing README.md"; fi
  if [ ! -f "$ko" ]; then fail "$dir: missing README.ko.md"; fi
  if [ -f "$en" ] && ! head -n 5 "$en" | grep -q '](README\.ko\.md)'; then
    fail "$en: no link to README.ko.md in the first 5 lines"
  fi
  if [ -f "$ko" ] && ! head -n 5 "$ko" | grep -q '](README\.md)'; then
    fail "$ko: no link to README.md in the first 5 lines"
  fi
done

# ---------------------------------------------------------------------------
section "SKILL.md frontmatter, Personal rules, circled numerals"
CIRCLED_ARGS=""
for c in ① ② ③ ④ ⑤ ⑥ ⑦ ⑧ ⑨ ⑩ ⑪ ⑫ ⑬ ⑭ ⑮ ⑯ ⑰ ⑱ ⑲ ⑳; do
  CIRCLED_ARGS="$CIRCLED_ARGS -e $c"
done
for skill in plugins/*/skills/*/; do
  [ -d "$skill" ] || continue
  skill="${skill%/}"
  folder="$(basename "$skill")"
  f="$skill/SKILL.md"
  if [ ! -f "$f" ]; then fail "$skill: missing SKILL.md"; continue; fi
  if [ "$(head -n 1 "$f")" != "---" ]; then
    fail "$f: does not start with a --- frontmatter block"
  else
    fm="$(awk 'NR==1{next} /^---[[:space:]]*$/{exit} {print}' "$f")"
    name="$(printf '%s\n' "$fm" | sed -n 's/^name:[[:space:]]*//p' | head -n 1 | sed 's/[[:space:]]*$//; s/^["'\'']//; s/["'\'']$//')"
    if [ -z "$name" ]; then fail "$f: frontmatter has no name"; fi
    if [ -n "$name" ] && [ "$name" != "$folder" ]; then
      fail "$f: name '$name' does not match folder '$folder'"
    fi
    if ! printf '%s\n' "$fm" | grep -Eq '^description:[[:space:]]*[^[:space:]]'; then
      fail "$f: frontmatter has no description"
    fi
  fi
  if ! grep -q '^## Personal rules' "$f"; then
    fail "$f: no '## Personal rules' section"
  fi
  # shellcheck disable=SC2086
  hits="$(grep -n -F $CIRCLED_ARGS "$f")"
  if [ -n "$hits" ]; then
    fail "$f: circled numerals found:"
    printf '%s\n' "$hits" | sed 's/^/    /'
  fi
done

# ---------------------------------------------------------------------------
section "Plugins registered in marketplace.json with a semver version"
MARKET=".claude-plugin/marketplace.json"
for p in plugins/*/; do
  [ -d "$p" ] || continue
  p="${p%/}"
  pname="$(basename "$p")"
  out="$(python3 - "$MARKET" "$p/.claude-plugin/plugin.json" "$pname" <<'PY'
import json, re, sys
market_path, plugin_path, name = sys.argv[1:4]
errs = []
try:
    with open(market_path) as fh:
        market = json.load(fh)
    sources = {str(e.get("source", "")).rstrip("/").removeprefix("./") for e in market.get("plugins", [])}
    if "plugins/" + name not in sources:
        errs.append(f"{name}: not registered in {market_path}")
except Exception as e:
    errs.append(f"{market_path}: cannot read ({e})")
try:
    with open(plugin_path) as fh:
        plugin = json.load(fh)
    v = str(plugin.get("version", ""))
    if not re.fullmatch(r"\d+\.\d+\.\d+(-[0-9A-Za-z.-]+)?(\+[0-9A-Za-z.-]+)?", v):
        errs.append(f"{plugin_path}: version '{v}' is not semver")
except FileNotFoundError:
    errs.append(f"{plugin_path}: missing")
except Exception as e:
    errs.append(f"{plugin_path}: cannot read ({e})")
print("\n".join(errs))
PY
)"
  if [ -n "$out" ]; then
    while IFS= read -r line; do fail "$line"; done <<EOF
$out
EOF
  fi
done

# ---------------------------------------------------------------------------
section "Syntax: bash -n on .sh, py_compile on .py"
while IFS= read -r f; do
  case "$f" in
    *.sh)
      if ! err="$(bash -n "$f" 2>&1)"; then fail "$f: bash -n failed"; printf '%s\n' "$err" | sed 's/^/    /'; fi ;;
    *.py)
      # Compile into a temp cache so no __pycache__ lands in the repo.
      pyc="$(mktemp -d)"
      if ! err="$(PYTHONPYCACHEPREFIX="$pyc" python3 -m py_compile "$f" 2>&1)"; then
        fail "$f: py_compile failed"; printf '%s\n' "$err" | sed 's/^/    /'
      fi
      rm -rf "$pyc" ;;
  esac
done <<EOF
$FILES
EOF

# ---------------------------------------------------------------------------
section "Relative links in README*.md"
check_links() {
  while IFS= read -r f; do
    case "$(basename "$f")" in
      README*.md) ;;
      *) continue ;;
    esac
    base="$(dirname "$f")"
    grep -o '\]([^)]*)' "$f" | sed 's/^](//; s/)$//' | while IFS= read -r link; do
      link="${link%% *}"          # drop a "title" after the URL
      case "$link" in
        ''|'#'*|http://*|https://*|mailto:*|*'://'*) continue ;;
      esac
      target="${link%%#*}"
      if [ -n "$target" ] && [ ! -e "$base/$target" ]; then
        printf '%s: broken link -> %s\n' "$f" "$link"
      fi
    done
  done <<EOF
$FILES
EOF
}
LINK_HITS="$(check_links)"
if [ -n "$LINK_HITS" ]; then
  while IFS= read -r line; do fail "$line"; done <<EOF
$LINK_HITS
EOF
fi

# ---------------------------------------------------------------------------
section "Privacy scan (private IPs, emails, home paths, tokens)"
SELF="scripts/check.sh"
SCAN_FILES="$(printf '%s\n' "$FILES" | grep -v -x -e "$SELF" -e 'scripts/private-patterns.txt')"

# $1 = label, $2 = grep -E pattern, $3 = grep -E allow pattern (may be empty),
# $4 = "line" to apply the allow pattern to the whole line (default: only to
#      the matched text, so one allowed value can't hide another on the line)
scan() {
  label="$1"; pat="$2"; allow="$3"; mode="${4:-match}"
  if [ "$mode" = line ]; then o=""; else o="-o"; fi
  hits="$(printf '%s\n' "$SCAN_FILES" | while IFS= read -r f; do
    [ -n "$f" ] && grep -I -n -H $o -E "$pat" "$f" 2>/dev/null
  done)"
  if [ -n "$allow" ] && [ -n "$hits" ]; then
    hits="$(printf '%s\n' "$hits" | grep -v -E "$allow")"
  fi
  if [ -n "$hits" ]; then
    fail "$label:"
    printf '%s\n' "$hits" | sed 's/^/    /'
  fi
}

scan "private IPv4 address" \
  '(^|[^0-9.])(10\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}|172\.(1[6-9]|2[0-9]|3[01])\.[0-9]{1,3}\.[0-9]{1,3}|192\.168\.[0-9]{1,3}\.[0-9]{1,3})([^0-9]|$)' \
  '[Ee]xample|e\.g\.|[Pp]laceholder' line
scan "email address" \
  '[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)*\.[A-Za-z]{2,}' \
  '(noreply|no-reply)[A-Za-z0-9._%+-]*@|@(users\.noreply\.github\.com|example\.(com|org|net))|git@github\.com'
scan "absolute home path" \
  '(/Users|/home)/[A-Za-z0-9._-]+/' \
  '(/Users|/home)/(YOUR_NAME|your_name|yourname|you|username|USER|me)/'
scan "token-like string" \
  '(ghp_|gho_|ghu_|ghs_|github_pat_)[A-Za-z0-9_]{20,}|sk-ant-[A-Za-z0-9_-]{20,}|xox[bp]-[A-Za-z0-9-]{10,}|AKIA[0-9A-Z]{16}' \
  ''

# ---------------------------------------------------------------------------
PRIVATE="scripts/private-patterns.txt"
if [ -f "$PRIVATE" ]; then
  section "Private patterns ($PRIVATE, local only)"
  # Drop blank lines so an empty pattern doesn't match everything.
  PATS="$(mktemp)"
  grep -v -E '^[[:space:]]*(#|$)' "$PRIVATE" > "$PATS"
  if [ -s "$PATS" ]; then
    # Same file list as above: only files that could be committed.
    hits="$(printf '%s\n' "$FILES" \
      | grep -v -x -e 'PLAN.md' -e "$PRIVATE" \
      | while IFS= read -r f; do grep -I -n -H -E -i -f "$PATS" "$f" 2>/dev/null; done)"
    if [ -n "$hits" ]; then
      fail "private patterns matched:"
      printf '%s\n' "$hits" | sed 's/^/    /'
    fi
  fi
  rm -f "$PATS"
fi

# ---------------------------------------------------------------------------
printf '\n'
if [ "$FAILS" -gt 0 ]; then
  printf '%s check(s) failed.\n' "$FAILS"
  exit 1
fi
printf 'All checks passed.\n'
