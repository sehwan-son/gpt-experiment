#!/usr/bin/env bash

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: $0 <output.md>" >&2
  exit 1
fi

output="$1"
mkdir -p "$(dirname "$output")"

run_if_exists() {
  local cmd="$1"
  shift || true
  if command -v "$cmd" >/dev/null 2>&1; then
    "$cmd" "$@"
  else
    echo "$cmd not found"
  fi
}

{
  echo "# Environment Snapshot"
  echo
  echo "- Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
  echo "- Working directory: $(pwd)"
  echo
  echo "## System"
  echo
  echo '```text'
  uname -a || true
  echo '```'
  echo
  echo "## Git"
  echo
  echo '```text'
  git symbolic-ref --short HEAD 2>/dev/null || echo "branch unavailable"
  if git rev-parse --verify HEAD >/dev/null 2>&1; then
    git rev-parse HEAD
  else
    echo "commit unavailable"
  fi
  git status --short 2>/dev/null || true
  echo '```'
  echo
  echo "## Python"
  echo
  echo '```text'
  run_if_exists python3 --version
  echo '```'
  echo
  echo "## NVIDIA SMI"
  echo
  echo '```text'
  if command -v nvidia-smi >/dev/null 2>&1; then
    nvidia-smi
  else
    echo "nvidia-smi not found"
  fi
  echo '```'
  echo
  echo "## NVCC"
  echo
  echo '```text'
  if command -v nvcc >/dev/null 2>&1; then
    nvcc --version
  else
    echo "nvcc not found"
  fi
  echo '```'
} > "$output"

echo "$output"
