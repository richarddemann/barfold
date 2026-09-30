# Hidden Bar Fix

A focused fork of [Hidden Bar](https://github.com/dwarvesf/hidden), the macOS utility that hides menu bar icons.

This fork keeps the existing hiding behavior and replaces the preferences layout with compact native controls. General and About share a window width, the tabs stay centered, and shortcut recording cancels when the window closes or loses focus. The direct build also includes the macOS 27 hiding engine and Accessibility onboarding.

<img src="img/preferences.png" width="500" alt="Hidden Bar preferences with native General and About toolbar tabs">

## Build and run

Requires macOS 13 or later and Xcode with its command-line tools selected.

```sh
git clone https://github.com/richarddemann/hiddenbarfix.git
cd hiddenbarfix
./script/build_and_run.sh --verify
```

The script builds the **Hidden Bar** scheme using **Debug-Direct**, signs it locally with an ad-hoc signature, and launches it. No Apple developer account is required. It stops an existing Hidden Bar process before launching the new build.

For daily use, install the build in Applications:

```sh
./script/build_and_run.sh --install
```

Installation backs up an existing `/Applications/Hidden Bar.app` before replacing it. This fork uses the original bundle identifier so existing settings carry over; run one copy at a time.

## Usage

Hold ⌘ and drag icons to the hidden side, then click the arrow to expand or collapse. On macOS 27, the arrow is the boundary. Earlier versions use the separator. Right-click the arrow for the context menu; Option-click it to hide or reveal the always-hidden section.

On macOS 27, run from `/Applications` and allow Hidden Bar in **System Settings → Privacy & Security → Accessibility**. Preferences explains the permission when it is missing. The direct build uses a private macOS visibility API; the sandboxed App Store build does not support hiding on macOS 27. This repository does not distribute a notarized release, and Homebrew's `hiddenbar` cask installs upstream rather than this fork.

## Verification

```sh
./script/test.sh
```

Tests cover the hiding engines, login-item transitions, menu-bar actions, notch geometry and menus, preference persistence, and shortcut validation. Real menu-bar interaction still needs a manual check on the target Mac; see the [runbook](docs/RUNBOOK.md).

- [User manual](docs/MANUAL.md)
- [Architecture](docs/ARCHITECTURE.md)
- [Build and verification](docs/RUNBOOK.md)
- [Known limitations](docs/BACKLOG.md)

## Credits and license

Hidden Bar was created by Dwarves Foundation and its contributors. This fork retains their source history and the [MIT license](LICENSE).
