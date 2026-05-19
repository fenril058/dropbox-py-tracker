#!/usr/bin/env bash
set -euo pipefail

BASE_REF="${1:-HEAD~1}"
TARGET_REF="${2:-HEAD}"

echo "==> Version changes"

git diff "$BASE_REF" "$TARGET_REF" -- dropbox.py \
  | grep -E '^[+-].*(nautilus-dropbox|VERSION|download|python|daemon|arch)' \
  || true

echo

echo "==> High-level statistics"

git diff --stat "$BASE_REF" "$TARGET_REF" -- dropbox.py

echo

echo "==> Word diff"

git diff --word-diff=color "$BASE_REF" "$TARGET_REF" -- dropbox.py || true
