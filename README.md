<p align="center">
  <img src="hidden/Assets.xcassets/AppIcon.appiconset/icon_128@2x.png" width="96" alt="Barfold icon">
</p>
<h1 align="center">Barfold</h1>
<p align="center">Hidden Bar for macOS 27, with cleaner settings.</p>

Barfold is a fork of **[Hidden Bar](https://github.com/dwarvesf/hidden)** by Dwarves Foundation and its contributors.

<p align="center">
  <img src="img/preferences.png" width="460" alt="Barfold settings">
</p>

### Install from source

Requires macOS 13 or later and Xcode. Use Xcode 27 for the latest native controls.

```sh
git clone https://github.com/richarddemann/barfold.git
cd barfold
./script/build_and_run.sh --install
```

This builds and installs `/Applications/Barfold.app`. There isn’t a signed, notarized download yet.

Barfold uses Hidden Bar’s existing settings. Run one at a time; the script stops either app before launching Barfold.

### Set it up

On macOS 27, allow Barfold in **System Settings → Privacy & Security → Accessibility**. Hold **⌘** and drag menu-bar icons to the left of the arrow, then click the arrow to hide or show them.

If access stops working after a rebuild, remove the old Accessibility entry and add `/Applications/Barfold.app` again. Local builds use ad-hoc signing, so approval can change when the binary changes.

### Development

```sh
./script/test.sh
```

The macOS 27 engine hides icons per app and leaves system items visible. It uses a private macOS API, so the direct build is required. External-display behavior still needs a visual hardware check. See the [build guide](docs/RUNBOOK.md) for details.

### Credit

Hidden Bar’s source history and [MIT license](LICENSE) are preserved. The macOS 27 engine comes from upstream [#403](https://github.com/dwarvesf/hidden/pull/403); the settings and permission fixes are proposed in [#433](https://github.com/dwarvesf/hidden/pull/433). Barfold is independently maintained.

[Report an issue](https://github.com/richarddemann/barfold/issues) · [Original Hidden Bar](https://github.com/dwarvesf/hidden)
