#!/bin/bash
# with-lock: run heavy commands (build, test, typecheck, full lint) one at a time
# across every Claude Code session on this machine.
#
#   bash with-lock.sh <command> [args...]
#   e.g. bash with-lock.sh npm run build
#
# If another session holds the lock, wait until it finishes, then run.
# The lock lives under $HOME (not $TMPDIR), because $TMPDIR can differ between
# sandboxed sessions and then the sessions would not see each other's lock.

[ $# -eq 0 ] && { echo "usage: with-lock.sh <command> [args...]" >&2; exit 2; }

LOCK_PARENT="$HOME/.claude/locks"
LOCKDIR="$LOCK_PARENT/heavy-task.lock"
WAITED=0

if ! mkdir -p "$LOCK_PARENT" 2>/dev/null; then
  # Cannot create the lock folder at all (e.g. read-only sandbox): don't wait forever
  echo "[with-lock] cannot create $LOCK_PARENT, running without a lock" >&2
  exec "$@"
fi

while ! mkdir "$LOCKDIR" 2>/dev/null; do
  if [ ! -d "$LOCKDIR" ]; then
    # mkdir failed for a reason other than "already held"
    echo "[with-lock] cannot create $LOCKDIR, running without a lock" >&2
    exec "$@"
  fi
  # Lock owner died (crash, killed session): remove the stale lock
  if [ -f "$LOCKDIR/pid" ] && ! kill -0 "$(cat "$LOCKDIR/pid" 2>/dev/null)" 2>/dev/null; then
    rm -rf "$LOCKDIR"
    continue
  fi
  if [ "$WAITED" -eq 0 ]; then
    echo "[with-lock] another session is running a heavy task, waiting..." >&2
  fi
  WAITED=$((WAITED + 5))
  sleep 5
done

echo $$ > "$LOCKDIR/pid"
trap 'rm -rf "$LOCKDIR"' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

[ "$WAITED" -gt 0 ] && echo "[with-lock] started after waiting ${WAITED}s" >&2
exec_status=0
"$@" || exec_status=$?
exit $exec_status
