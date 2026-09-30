# Known limitations

- The macOS 27 direct build uses a private visibility API, which can change with OS updates. The App Store sandbox prevents reading menu-bar sections there.
- Native hiding is per app. An app with several icons hides or shows them together; system items remain visible.
- Native visibility needs Accessibility access and an app installed in Applications.
- This fork retains upstream's bundle identifier and preferences. It cannot be used as a separate daily instance alongside upstream.
- Always-hidden behavior remains coupled to separator visibility; Option-click controls that state. The layout refresh does not redesign the hiding engine.
- External-display behavior and upgrade-path login-item cleanup need hardware verification before a signed release.
- Local builds are ad-hoc signed. There is no notarized binary release for this fork.
