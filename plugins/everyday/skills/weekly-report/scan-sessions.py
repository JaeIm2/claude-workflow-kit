#!/usr/bin/env python3
"""
Session history scanner for weekly reports.

Reads every Claude Code session log under ~/.claude/projects/*/*.jsonl and prints
one line per session that had activity in the given period:
    last activity | working directory (and git branch) | user turns | title or first prompt

Purpose: surface work that never shows up in a work tracker (log analysis, meeting
notes, deploy checks, writing replies, small jobs in other projects) so the weekly
report draft can offer it as candidates. The output is noisy on purpose (dead ends,
exploration, cancelled sessions are included); the user filters it.

Usage:
  python3 scan-sessions.py                    # last 7 days
  python3 scan-sessions.py --days 5           # last 5 days
  python3 scan-sessions.py --since 2026-01-05 # on or after a date
"""
import datetime
import glob
import json
import os
import sys

HOME = os.path.expanduser("~")


def parse_args(argv):
    days, since = 7, None
    i = 1
    while i < len(argv):
        if argv[i] == "--days" and i + 1 < len(argv):
            days = int(argv[i + 1])
            i += 2
        elif argv[i] == "--since" and i + 1 < len(argv):
            since = argv[i + 1]
            i += 2
        else:
            i += 1
    if since is None:
        since = (datetime.date.today() - datetime.timedelta(days=days)).isoformat()
    return since


def short_path(path):
    if path and path.startswith(HOME):
        return "~" + path[len(HOME):]
    return path or "(unknown)"


def first_text(content):
    """First real user text, skipping wrappers injected by hooks, commands, and skills."""
    if isinstance(content, str):
        s = content.strip()
        if s and not s.startswith("<") and not s.startswith("Base directory"):
            return s
    elif isinstance(content, list):
        for it in content:
            if isinstance(it, dict) and it.get("type") == "text":
                s = (it.get("text") or "").strip()
                if s and not s.startswith("<"):
                    return s
    return None


def scan(since):
    rows = []
    for f in glob.glob(os.path.join(HOME, ".claude", "projects", "*", "*.jsonl")):
        proj_dir = os.path.basename(os.path.dirname(f))
        first_user = None
        last_ts = None
        n_user = 0
        title = None
        cwd = None
        branch = None
        try:
            with open(f, encoding="utf-8", errors="replace") as fp:
                for line in fp:
                    try:
                        d = json.loads(line)
                    except ValueError:
                        continue
                    t = d.get("type")
                    if t == "ai-title" and d.get("aiTitle"):
                        title = d["aiTitle"]
                    elif t == "user" and not d.get("isMeta") and isinstance(d.get("message"), dict):
                        ft = first_text(d["message"].get("content"))
                        if ft:
                            n_user += 1
                            if first_user is None:
                                first_user = ft.replace("\n", " ")[:90]
                    if d.get("cwd"):
                        cwd = d["cwd"]
                    if d.get("gitBranch"):
                        branch = d["gitBranch"]
                    ts = d.get("timestamp")
                    if ts:
                        last_ts = ts
        except OSError:
            continue
        # Sessions with no user turns (empty, heartbeat) carry no work signal
        if last_ts and last_ts[:10] >= since and n_user > 0:
            where = short_path(cwd) if cwd else proj_dir
            if branch and branch != "HEAD":
                where += f" ({branch})"
            rows.append((last_ts[:16], where, n_user, title, first_user))
    rows.sort(reverse=True)
    return rows


def main():
    since = parse_args(sys.argv)
    rows = scan(since)
    print(f"# Session digest (activity on or after {since}, {len(rows)} sessions)")
    print("# Noisy: includes dead ends, exploration, cancelled work. Candidates only, not confirmed results.")
    print("=" * 100)
    for ts, where, n, title, fu in rows:
        label = title or fu or "(no title)"
        print(f"{ts} | {where:35.35} | turns~{n:3} | {label}")
        if title and fu and fu[:40] not in title:
            print(f"{'':19} first prompt: {fu}")


if __name__ == "__main__":
    main()
