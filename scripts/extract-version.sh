#!/usr/bin/env bash
set -euo pipefail

FILE="${1:-dropbox.py}"

VERSION_LINE="$(grep -m1 'part of nautilus-dropbox' "$FILE" || true)"

if [[ -z "$VERSION_LINE" ]]; then
  echo "unknown"
  exit 1
fi

VERSION="$(
  printf '%s\n' "$VERSION_LINE" \
    | sed -nE 's/.*nautilus-dropbox ([0-9]+(\.[0-9]+)+).*/\1/p'
)"

if [[ -z "$VERSION" ]]; then
  echo "unknown"
  exit 1
fi

printf '%s\n' "$VERSION"
