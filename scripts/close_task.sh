#!/usr/bin/env bash

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: $0 <task-id>" >&2
  exit 1
fi

task_id="$1"
src="tasks/active/$task_id"
dst="tasks/completed/$task_id"
timestamp="$(date '+%Y-%m-%d %H:%M:%S')"

if [[ ! -d "$src" ]]; then
  echo "task not found: $src" >&2
  exit 1
fi

mv "$src" "$dst"

tmp_file="$(mktemp)"
awk -F'|' -v task_id="$task_id" -v timestamp="$timestamp" '
BEGIN { OFS="|" }
{
  if ($2 ~ " " task_id " ") {
    $5 = " completed "
    $7 = " " timestamp " "
  }
  print
}
' tasks/index.md > "$tmp_file"
mv "$tmp_file" tasks/index.md

printf '| %s | %s | %s | %s |\n' \
  "$timestamp" "$task_id" "closed" "moved to tasks/completed" >> logs/activity.md

echo "$dst"
