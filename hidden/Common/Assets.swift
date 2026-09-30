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

    // Draw at the display's backing scale, with no app-icon tile or raster blur.
    // The chevron preserves the expanded/collapsed cue in either text direction.
    private static func menuBarImage(pointsRight: Bool) -> NSImage {
        let image = NSImage(size: NSSize(width: 18, height: 16), flipped: false) { _ in
            NSColor.black.setStroke()
            let glyph = NSBezierPath()
            glyph.lineWidth = 1.6
            glyph.lineCapStyle = .round
            glyph.lineJoinStyle = .round
            func point(_ x: CGFloat, _ y: CGFloat) -> NSPoint {
                NSPoint(x: pointsRight ? x : 18 - x, y: y)
            }
            for (y, end): (CGFloat, CGFloat) in [(3, 8), (8, 6.5), (13, 8)] {
                glyph.move(to: point(1.5, y))
                glyph.line(to: point(end, y))
            }
            glyph.move(to: point(11.5, 3))
            glyph.line(to: point(16, 8))
            glyph.line(to: point(11.5, 13))
            glyph.stroke()
            return true
        }
        image.isTemplate = true
        return image
    }
}
