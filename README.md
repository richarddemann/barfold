<p align="center">
  <img src="hidden/Assets.xcassets/AppIcon.appiconset/icon_128@2x.png" width="96" alt="Barfold icon">
</p>
<h1 align="center">Barfold</h1>
<p align="center">A cleaner menu bar for macOS 27.</p>

Barfold is a fork of **[Hidden Bar](https://github.com/dwarvesf/hidden)** by Dwarves Foundation and its contributors.

<p align="center">
  <img src="img/preferences.png" width="460" alt="Barfold settings">
</p>

### Download

[Download Barfold for Mac](https://github.com/richarddemann/barfold/releases/tag/v1.0.1-preview.1) — macOS 13 or later, Apple silicon and Intel. No Xcode needed.

Open the DMG and drag Barfold into Applications. Quit Hidden Bar before opening it.

This preview is **not notarized by Apple**, so macOS may block its first launch. See [Apple’s instructions](https://support.apple.com/102445). A notarized release is still to come.

### Build from source

Requires macOS 13 or later and Xcode. Use Xcode 27 for the latest native controls.

```sh
git clone https://github.com/richarddemann/barfold.git
cd barfold
./script/build_and_run.sh --install
```

This builds and installs `/Applications/Barfold.app`.

Barfold copies your previous Hidden Bar settings once, then keeps its own preferences. Run one menu-bar manager at a time.

### Set it up

On macOS 27, allow Barfold in **System Settings → Privacy & Security → Accessibility**. Hold **⌘** and drag menu-bar icons to the left of the arrow, then click the arrow to hide or show them.

Barfold now has its own app identity, so upgrading from the first preview requires approving **Barfold** again. Hidden Bar’s approval is separate. If access stops working after a rebuild, remove only the stale Barfold entry and add `/Applications/Barfold.app` again; local builds use ad-hoc signing.

### Development

```sh
./script/test.sh
```

The macOS 27 engine hides icons per app and leaves system items visible. It uses a private macOS API, so the direct build is required. External-display behavior still needs a visual hardware check. See the [build guide](docs/RUNBOOK.md) for details.

### Credit

Hidden Bar’s source history and [MIT license](LICENSE) are preserved. The macOS 27 engine comes from upstream [#403](https://github.com/dwarvesf/hidden/pull/403); the settings and permission fixes are proposed in [#433](https://github.com/dwarvesf/hidden/pull/433). Barfold is independently maintained.

[Report an issue](https://github.com/richarddemann/barfold/issues) · [Original Hidden Bar](https://github.com/dwarvesf/hidden)
