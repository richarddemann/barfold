//
//  Assets.swift
//  Hidden Bar
//
//  Created by Peter Luo on 2021/5/28.
//  Copyright © 2021 Dwarves Foundation. All rights reserved.
//

import AppKit

struct Assets {
    static var expandImage: NSImage {
        menuBarImage(pointsRight: !Constant.isUsingLTRLanguage)
    }

    static var collapseImage: NSImage {
        menuBarImage(pointsRight: Constant.isUsingLTRLanguage)
    }

    // A small native chevron gives state feedback without adding visual weight
    // to the menu bar. Template rendering follows its light/dark appearance.
    private static func menuBarImage(pointsRight: Bool) -> NSImage {
        let name = pointsRight ? "chevron.right" : "chevron.left"
        let configuration = NSImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        return NSImage(systemSymbolName: name, accessibilityDescription: nil)!
            .withSymbolConfiguration(configuration)!
    }
}
