#!/usr/bin/env bash
set -euo pipefail

echo "==> Version changes"

git diff HEAD -- dropbox.py \
  | grep -E '^[+-].*(nautilus-dropbox|VERSION|download|python|daemon|arch)' \
  || true

echo

echo "==> High-level statistics"

git diff --stat HEAD -- dropbox.py

echo

echo "==> Unified diff"

git diff HEAD -- dropbox.py
