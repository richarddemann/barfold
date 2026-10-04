#!/usr/bin/env bash
# Build a universal, ad-hoc signed preview. This does not notarize the app.
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
VERSION="${1:-1.0.1}"
BUILD_NUMBER="${2:-18}"
if [[ ! "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ || ! "$BUILD_NUMBER" =~ ^[0-9]+$ ]]; then
  echo "usage: $0 [version, e.g. 1.0.1] [build number]" >&2
  exit 2
fi
DERIVED_DATA="$ROOT_DIR/build/release-preview"
OUTPUT_DIR="$ROOT_DIR/dist"
mkdir -p "$OUTPUT_DIR"
STAGING_DIR="$(mktemp -d "$OUTPUT_DIR/.preview.XXXXXX")"
trap 'rm -rf "$STAGING_DIR"' EXIT
xcodebuild -project 'Hidden Bar.xcodeproj' -scheme 'Hidden Bar' \
  -configuration Release-Direct -derivedDataPath "$DERIVED_DATA" \
  CODE_SIGN_IDENTITY=- CODE_SIGN_STYLE=Manual DEVELOPMENT_TEAM= \
  ARCHS='arm64 x86_64' ONLY_ACTIVE_ARCH=NO \
  MARKETING_VERSION="$VERSION" CURRENT_PROJECT_VERSION="$BUILD_NUMBER" clean build
APP_BUNDLE="$DERIVED_DATA/Build/Products/Release-Direct/Barfold.app"
codesign --verify --deep --strict "$APP_BUNDLE"
APP_ARCHITECTURES="$(lipo -archs "$APP_BUNDLE/Contents/MacOS/Barfold")"
for required_arch in arm64 x86_64; do
  if [[ " $APP_ARCHITECTURES " != *" $required_arch "* ]]; then
    echo "Missing architecture: $required_arch" >&2
    exit 1
  fi
done
ditto "$APP_BUNDLE" "$STAGING_DIR/Barfold.app"
ln -s /Applications "$STAGING_DIR/Applications"
cp LICENSE "$STAGING_DIR/LICENSE.txt"
cat > "$STAGING_DIR/Read Me.txt" <<'NOTE'
Barfold preview — a fork of Hidden Bar
https://github.com/richarddemann/barfold

Drag Barfold into Applications. Quit Hidden Bar before opening Barfold.
Barfold copies supported preferences once and now has its own app identity.
Its Accessibility approval must be granted separately from Hidden Bar.

On macOS 27, allow Barfold in Privacy & Security → Accessibility
(called Device Control and Data Access on some macOS builds).

This preview is ad-hoc signed and is not notarized by Apple. macOS may
block it on first launch. Review the source before deciding to allow it.
https://support.apple.com/102445
NOTE
DMG="$OUTPUT_DIR/Barfold-$VERSION-preview.dmg"
hdiutil create -volname 'Barfold Preview' -srcfolder "$STAGING_DIR" \
  -format UDZO -ov "$DMG"
hdiutil verify "$DMG"
(cd "$OUTPUT_DIR" && shasum -a 256 "$(basename "$DMG")" > SHA256SUMS.txt)
echo "Unnotarized preview: $DMG"
