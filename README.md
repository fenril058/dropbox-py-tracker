# dropbox-py-history

Unofficial history tracker for Dropbox's GPL-licensed `dropbox.py`
script.

Canonical upstream endpoint:

https://www.dropbox.com/download?dl=packages/dropbox.py

This repository exists because the upstream endpoint is mutable and
does not provide immutable historical releases.

Goals:

- reproducible builds
- auditable diffs
- historical tracking
- Nix/Guix packaging support

## Update policy

- `dropbox.py` always tracks the latest reviewed upstream version.
- Historical versions are preserved through Git tags.
- Updates are reviewed manually before merge.

## Tags

Tags correspond to upstream-reported versions:

- v2026.03.20
