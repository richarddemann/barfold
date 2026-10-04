import Foundation

// Barfold used Hidden Bar's identity before becoming a separate app. Copy only
// user choices, once, before defaults and any status items are initialized.
enum PreferenceMigration {
    static let domain = "com.richarddemann.barfold"
    static let legacyDomain = "com.dwarvesv.minimalbar"
    static let marker = "barfoldPreferencesMigrated"
    static let keys = [
        "globalKey", "numberOfSecondForAutoHide", "isAutoStart", "isAutoHide",
        "isShowPreferences", "areSeparatorsHidden", "alwaysHiddenSectionEnabled",
        "useFullStatusBarOnExpandEnabled", "hoverToExpand", "notchOverflowEnabled",
        "AppleLanguages"
    ]

    static func migrate(defaults: UserDefaults = .standard,
                        targetDomain: String = domain,
                        sourceDomain: String = legacyDomain) {
        let current = defaults.persistentDomain(forName: targetDomain) ?? [:]
        guard current[marker] as? Bool != true else { return }
        let legacy = defaults.persistentDomain(forName: sourceDomain) ?? [:]
        var migrated = current
        for key in keys where current[key] == nil {
            if let value = legacy[key] { migrated[key] = value }
        }
        // Status-item placement is a user choice, rather than privacy or login
        // authorization. Keep the existing autosave names for this migration.
        for item in ["hiddenbar_expandcollapse", "hiddenbar_separate", "hiddenbar_terminate"] {
            let key = "NSStatusItem Preferred Position " + item
            if current[key] == nil, let value = legacy[key] { migrated[key] = value }
        }
        migrated[marker] = true
        defaults.setPersistentDomain(migrated, forName: targetDomain)
    }
}
