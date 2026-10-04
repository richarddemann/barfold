# Architecture

Barfold is a macOS menu-bar utility forked from [Hidden Bar](https://github.com/dwarvesf/hidden). AppKit owns its status items and settings window; SwiftUI draws the settings contents. [HotKey](https://github.com/soffes/HotKey) handles the global shortcut.

## Hiding icons

`StatusBarController` handles clicks, shortcuts, auto-hide timing and screen changes. `MenuBarEngineFactory` chooses the mechanism:

- **macOS 13–26:** `LegacyLengthEngine` widens a separator to move icons off-screen. Its length follows the widest attached display.
- **macOS 27, direct build:** `NativeVisibilityEngine` uses the private MenuBarClientCore framework through an Objective-C shim. Accessibility reads locate the menu-bar sections. Hiding applies per app; system items stay visible. The arrow is the section boundary.

The direct build is not sandboxed. The sandboxed configuration cannot use the macOS 27 mechanism. A future macOS update may change the private API.

## Settings and identity

The app’s bundle ID is `com.richarddemann.barfold`. Preferences use its own `UserDefaults` domain. `PreferenceMigration` copies an allowlist from the first preview’s shared Hidden Bar domain once, before registering defaults or creating status items. Existing Barfold choices win; the source domain stays unchanged. Privacy approvals and login registrations are not copied.

`SMAppService.mainApp` manages Barfold’s login item. Hidden Bar’s login registration stays separate. Original Xcode target/module names and localization lookup keys remain internal compatibility details.

## Interaction

A one-shot timer handles auto-hide and defers while the pointer is in the menu bar or settings are visible. Optional hover-to-expand observes mouse movement. Status items restore their visibility after being dragged off the menu bar. A permission transition tracker retries hiding only when Barfold’s own Accessibility access changes from missing to granted.

## Limits

Native hiding uses a private API and groups icons by owning app. External-display behavior needs hardware checks. Pointer-based deferral cannot detect every open menu. The notch-overflow menu depends on Accessibility access and which actions other apps expose.
