#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
pkill -x "Hidden Bar" >/dev/null 2>&1 || true
pkill -x "Barfold" >/dev/null 2>&1 || true
plutil -lint hidden/*.lproj/*.strings
xcodebuild -project 'Hidden Bar.xcodeproj' -scheme 'Hidden Bar' \
  -configuration Debug-Direct -derivedDataPath "$ROOT_DIR/build" \
  CODE_SIGN_IDENTITY=- CODE_SIGN_STYLE=Manual DEVELOPMENT_TEAM= test
