#!/usr/bin/env bash
# task-agent pre-commit quality gate (PreToolUse hook on Bash).
# Fires only when: the Bash command is a git commit AND the repo is a
# task-agent project (tasks.md carries the board marker). Exit 2 blocks the
# commit and feeds the reason back to the agent.

set -u

input=$(cat)

case "$input" in
  *"git commit"*) ;;
  *) exit 0 ;;
esac

root=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
grep -qs 'task-agent:board' "$root/tasks.md" || exit 0

fail() {
  printf 'task-agent gate blocked the commit.\n%s\n' "$1" >&2
  exit 2
}

cd "$root" || exit 0

if [ -f vendor/bin/pint ]; then
  out=$(vendor/bin/pint --test 2>&1) \
    || fail "Style gate failed (pint --test). Run vendor/bin/pint, then retry.
$(printf '%s\n' "$out" | tail -n 20)"
fi

if [ -f vendor/bin/phpstan ]; then
  out=$(vendor/bin/phpstan analyse --no-progress 2>&1) \
    || fail "Static analysis gate failed (phpstan).
$(printf '%s\n' "$out" | tail -n 30)"
fi

if [ -f artisan ]; then
  out=$(php artisan test 2>&1) \
    || fail "Test gate failed (php artisan test).
$(printf '%s\n' "$out" | tail -n 40)"
fi

exit 0
