import XCTest
@testable import Hidden_Bar

final class PreferenceMigrationTests: XCTestCase {
    private var source: String!
    private var target: String!
    private var defaults: UserDefaults!

    override func setUp() {
        source = "barfold-tests-source-" + UUID().uuidString
        target = "barfold-tests-target-" + UUID().uuidString
        defaults = UserDefaults(suiteName: target)!
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: source)
        defaults.removePersistentDomain(forName: target)
    }

    private func migrate() {
        PreferenceMigration.migrate(defaults: defaults, targetDomain: target, sourceDomain: source)
    }

    func testCopiesUserChoicesAndPlacementWithoutChangingSource() {
        let legacy: [String: Any] = ["isAutoHide": false, "numberOfSecondForAutoHide": 30.0,
                                   "globalKey": Data([1, 2]), "AppleLanguages": ["en"],
                                   "NSStatusItem Preferred Position hiddenbar_expandcollapse": 120]
        defaults.setPersistentDomain(legacy, forName: source)
        migrate()
        let result = defaults.persistentDomain(forName: target)!
        XCTAssertEqual(result["isAutoHide"] as? Bool, false)
        XCTAssertEqual(result["numberOfSecondForAutoHide"] as? Double, 30)
        XCTAssertEqual(result["globalKey"] as? Data, Data([1, 2]))
        XCTAssertEqual(result["AppleLanguages"] as? [String], ["en"])
        XCTAssertEqual(result["NSStatusItem Preferred Position hiddenbar_expandcollapse"] as? Int, 120)
        XCTAssertEqual(defaults.persistentDomain(forName: source)! as NSDictionary, legacy as NSDictionary)
    }

    func testPreservesExistingBarfoldValuesAndOnlyMigratesOnce() {
        defaults.setPersistentDomain(["isAutoHide": true], forName: target)
        defaults.setPersistentDomain(["isAutoHide": false, "hoverToExpand": true], forName: source)
        migrate()
        XCTAssertEqual(defaults.persistentDomain(forName: target)?["isAutoHide"] as? Bool, true)
        defaults.setPersistentDomain(["notchOverflowEnabled": false], forName: source)
        migrate()
        XCTAssertNil(defaults.persistentDomain(forName: target)?["notchOverflowEnabled"])
    }

    func testDoesNotCopyLegacyAuthorizationsOrUnrelatedData() {
        defaults.setPersistentDomain(["smAppServiceMigrated": true, "AccessibilityTrusted": true,
                                      "unrelated": "private"], forName: source)
        migrate()
        let result = defaults.persistentDomain(forName: target)!
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[PreferenceMigration.marker] as? Bool, true)
    }

    func testFreshInstallDoesNotImportRegisteredDefaults() {
        defaults.register(defaults: ["isAutoHide": false])
        migrate()
        XCTAssertNil(defaults.persistentDomain(forName: target)?["isAutoHide"])
        XCTAssertEqual(defaults.persistentDomain(forName: target)?[PreferenceMigration.marker] as? Bool, true)
    }
}
