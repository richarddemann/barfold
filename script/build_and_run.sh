#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
MODE="${1:-run}"
case "$MODE" in
  run|--debug|--logs|--telemetry|--verify|--install) ;;
  *) echo "usage: $0 [--debug|--logs|--telemetry|--verify|--install]" >&2; exit 2 ;;
esac
APP_NAME="Hidden Bar"
APP_BUNDLE="$ROOT_DIR/build/Build/Products/Debug-Direct/$APP_NAME.app"
pkill -x "$APP_NAME" >/dev/null 2>&1 || true
xcodebuild -project 'Hidden Bar.xcodeproj' -scheme 'Hidden Bar' \
  -configuration Debug-Direct -derivedDataPath "$ROOT_DIR/build" \
  CODE_SIGN_IDENTITY=- CODE_SIGN_STYLE=Manual DEVELOPMENT_TEAM= build
case "$MODE" in
  --install)
    INSTALLED_APP="/Applications/$APP_NAME.app"
    if [[ -e "$INSTALLED_APP" ]]; then
      BACKUP_DIR="$HOME/Library/Application Support/Hidden Bar Fix/Backups/$(date +%Y%m%d-%H%M%S)"
      mkdir -p "$BACKUP_DIR"
      ditto "$INSTALLED_APP" "$BACKUP_DIR/$APP_NAME.app"
      echo "Previous app backed up to $BACKUP_DIR/$APP_NAME.app"
    fi
    # Copy into a fresh bundle so removed resources never survive an update.
    STAGING_DIR="$(mktemp -d /Applications/.hiddenbarfix-install.XXXXXX)"
    trap 'rm -rf "$STAGING_DIR"' EXIT
    ditto "$APP_BUNDLE" "$STAGING_DIR/$APP_NAME.app"
    codesign --verify --deep --strict "$STAGING_DIR/$APP_NAME.app"
    if [[ -e "$INSTALLED_APP" ]]; then
      mv "$INSTALLED_APP" "$STAGING_DIR/previous.app"
    fi
    if ! mv "$STAGING_DIR/$APP_NAME.app" "$INSTALLED_APP"; then
      if [[ -e "$STAGING_DIR/previous.app" ]]; then
        mv "$STAGING_DIR/previous.app" "$INSTALLED_APP"
      fi
      exit 1
    fi
    /usr/bin/open -n "$INSTALLED_APP"
    ;;
  --debug) lldb -- "$APP_BUNDLE/Contents/MacOS/$APP_NAME" ;;
  --logs|--telemetry)
    /usr/bin/open -n "$APP_BUNDLE"
    /usr/bin/log stream --info --style compact --predicate 'process == "Hidden Bar"'
    ;;
  --verify)
    /usr/bin/open -n "$APP_BUNDLE"
    sleep 2
    pgrep -x "$APP_NAME" >/dev/null
    ;;
  run) /usr/bin/open -n "$APP_BUNDLE" ;;
esac
