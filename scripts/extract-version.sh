#!/usr/bin/env bash
set -euo pipefail

FILE="${1:-dropbox.py}"

VERSION_LINE="$(grep 'part of nautilus-dropbox' "$FILE" || true)"

if [[ -z "$VERSION_LINE" ]]; then
  echo "unknown"
  exit 1
fi

echo "$VERSION_LINE" \
  | sed -E 's/.*nautilus-dropbox ([0-9.]+).*/\1/'
