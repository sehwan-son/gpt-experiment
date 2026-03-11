#!/usr/bin/env bash

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: $0 \"task title\" [paper|gpu|general] [slug]" >&2
  exit 1
fi

title="$1"
task_type="${2:-general}"
manual_slug="${3:-}"
task_ts="$(date +%Y%m%d-%H%M%S)"

slug_source="$manual_slug"
if [[ -z "$slug_source" ]]; then
  slug_source="$title"
fi

slug="$(
  printf '%s' "$slug_source" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//; s/-+/-/g'
)"

if [[ -z "$slug" ]]; then
  slug="task-$(printf '%s' "$title" | shasum -a 1 | cut -c1-8)"
fi

task_id="${task_ts}-$slug"
task_dir="tasks/active/$task_id"
timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
safe_title="$(printf '%s' "$title" | tr '|' '/')"

case "$task_type" in
  paper)
    experiment_path="experiments/papers/$slug"
    ;;
  gpu)
    experiment_path="experiments/gpu/$slug"
    ;;
  general)
    experiment_path="(decide during execution)"
    ;;
  *)
    echo "invalid task type: $task_type" >&2
    exit 1
    ;;
esac

mkdir -p "$task_dir"

sed \
  -e "s/{{TASK_ID}}/$task_id/g" \
  -e "s/{{TITLE}}/$safe_title/g" \
  -e "s/{{TYPE}}/$task_type/g" \
  -e "s|{{EXPERIMENT_PATH}}|$experiment_path|g" \
  templates/task-plan.md > "$task_dir/plan.md"

sed \
  -e "s/{{TASK_ID}}/$task_id/g" \
  -e "s/{{TITLE}}/$safe_title/g" \
  -e "s/{{DATE}}/$timestamp/g" \
  templates/task-notes.md > "$task_dir/notes.md"

sed \
  -e "s/{{TASK_ID}}/$task_id/g" \
  -e "s/{{TITLE}}/$safe_title/g" \
  templates/task-result.md > "$task_dir/result.md"

printf '| %s | %s | %s | %s | %s | %s |\n' \
  "$task_id" "$task_type" "$safe_title" "active" "$experiment_path" "$timestamp" >> tasks/index.md

printf '| %s | %s | %s | %s |\n' \
  "$timestamp" "$task_id" "opened" "$safe_title" >> logs/activity.md

echo "$task_dir"
