#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

UPSTREAM_URL="https://www.dropbox.com/download?dl=packages/dropbox.py"
TMP_FILE="$TMP_DIR/dropbox.py"
TMP_HEADERS="$TMP_DIR/headers.txt"

cd "$ROOT_DIR"

echo "==> Fetching upstream dropbox.py"

curl -fsSLD "$TMP_HEADERS" \
  "$UPSTREAM_URL" \
  -o "$TMP_FILE"

NEW_VERSION="$($ROOT_DIR/scripts/extract-version.sh "$TMP_FILE")"
NEW_SHA256="$(sha256sum "$TMP_FILE" | awk '{print $1}')"
FETCHED_AT="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

CLOUDFRONT_POP="$((grep -i '^X-Amz-Cf-Pop:' "$TMP_HEADERS" || true) | awk '{print $2}' | tr -d '\r')"
FINAL_URL="$((grep -i '^location:' "$TMP_HEADERS" || true) | tail -1 | awk '{print $2}' | tr -d '\r')"

if [[ -f dropbox.py ]]; then
  CURRENT_SHA256="$(sha256sum dropbox.py | awk '{print $1}')"
else
  CURRENT_SHA256=""
fi

if [[ "$CURRENT_SHA256" == "$NEW_SHA256" ]]; then
  echo "No upstream changes detected"
  exit 0
fi

echo "==> Upstream change detected"
echo "Current SHA256: $CURRENT_SHA256"
echo "New SHA256:     $NEW_SHA256"

echo "==> Diff summary"
if [[ -f dropbox.py ]]; then
  diff -u dropbox.py "$TMP_FILE" || true
fi

echo "==> Updating tracked files"
cp "$TMP_FILE" dropbox.py
cp "$TMP_HEADERS" headers.txt

jq -n \
  --arg upstream_url "$UPSTREAM_URL" \
  --arg upstream_version "$NEW_VERSION" \
  --arg sha256 "$NEW_SHA256" \
  --arg fetched_at_utc "$FETCHED_AT" \
  --arg cloudfront_pop "$CLOUDFRONT_POP" \
  --arg final_url "$FINAL_URL" \
  '{upstream_url: $upstream_url, upstream_version: $upstream_version, sha256: $sha256, fetched_at_utc: $fetched_at_utc, cloudfront_pop: $cloudfront_pop, final_url: $final_url}' \
  > metadata.json

echo "==> Updated metadata.json"
cat metadata.json

echo "==> Suggested git commands"
echo "git add dropbox.py metadata.json headers.txt"
echo "git commit -m 'Update dropbox.py to $NEW_VERSION'"
echo "git tag v$NEW_VERSION"
