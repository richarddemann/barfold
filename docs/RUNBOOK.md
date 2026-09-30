# Build and verification

## Local build

```sh
./script/build_and_run.sh --verify
```

The script builds Debug-Direct with an ad-hoc signature and launches the app from `build/Build/Products/Debug-Direct`. It needs Xcode, not a developer signing identity. `--debug` launches under LLDB; `--logs` and `--telemetry` stream the app's unified logs.

```sh
./script/build_and_run.sh --install
```

This backs up any installed app under `~/Library/Application Support/Hidden Bar Fix/Backups`, copies the build to `/Applications/Hidden Bar.app`, and launches it. Use that location for macOS 27 menu-bar verification: native visibility resolves apps by bundle identifier, and running multiple copies can hide Hidden Bar's own arrow.

Ad-hoc signatures identify a specific build. Rebuilding can invalidate its existing Accessibility approval. Finish and install the build before authorizing it; if macOS keeps an old entry enabled but the app still reports missing access, remove that entry and add the exact installed app again. A stable Developer ID signature is needed for a smoother update experience.

## Automated checks

```sh
./script/test.sh
```

Runs both Xcode test targets with Debug-Direct and validates localization tables. Hosted settings tests save and restore the preferences they modify. Test logs and build products stay local.

## Manual checks

Before testing with everyday menu-bar icons, export preferences:

```sh
defaults export com.dwarvesv.minimalbar backup.plist
```

- General and About keep the same width, with centered tabs and no clipped content.
- Auto-hide enables/disables its delay control; the delay and ordinary preferences persist after relaunch.
- Shortcut recording accepts a modified key or standalone function key. Escape, closing the window, or switching tabs cancels it. Bare typing preserves an existing shortcut; Clear removes it. Cmd+W closes the window outside recording.
- The always-hidden help names the appropriate boundary and Option-click behavior.
- On macOS 27, the missing-Accessibility explanation appears until permission is granted; the Settings button opens the appropriate System Settings pane.
- Expand/collapse works with the actual menu-bar arrow and the global shortcut.
- With auto-hide on, the bar remains expanded while the pointer is in the menu bar, then collapses after the selected delay once it leaves.
- Right-click opens the context menu and, on a notched display with Accessibility access, exposes notch-overflow items.
- Verify an external display on real hardware; unit tests cannot establish its live menu-bar behavior.

Restore preferences after testing:

```sh
defaults import com.dwarvesv.minimalbar backup.plist
```

## Distribution

The source is MIT licensed. A local ad-hoc build is not a notarized distribution. A public app release needs a Developer ID archive, notarization and stapling. Use Release-Direct for a direct download; the sandboxed App Store scheme cannot hide icons on macOS 27. Keep signing identities and credentials outside the repository.
