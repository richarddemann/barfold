import AppKit

// Deterministic exports of icon.svg; keep SVG geometry and this renderer in sync.
let output = URL(fileURLWithPath: CommandLine.arguments[1], isDirectory: true)
let images = try JSONSerialization.jsonObject(with: Data(contentsOf: output.appendingPathComponent("Contents.json"))) as! [String: Any]
for entry in images["images"] as! [[String: String]] {
    let size = Int(entry["size"]!.components(separatedBy: "x")[0])! * (entry["scale"] == "2x" ? 2 : 1)
    let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: size, pixelsHigh: size, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmap)
    let context = NSGraphicsContext.current!.cgContext
    context.scaleBy(x: CGFloat(size) / 1024, y: CGFloat(size) / 1024)
    NSColor(srgbRed: 247/255, green: 247/255, blue: 245/255, alpha: 1).setFill()
    NSBezierPath(roundedRect: NSRect(x: 64, y: 64, width: 896, height: 896), xRadius: 200, yRadius: 200).fill()
    NSColor(srgbRed: 41/255, green: 43/255, blue: 46/255, alpha: 1).setStroke()
    let glyph = NSBezierPath()
    glyph.lineWidth = 56
    glyph.lineCapStyle = .round
    glyph.lineJoinStyle = .round
    for (y, end) in [(348.0, 516.0), (512.0, 468.0), (676.0, 516.0)] {
        glyph.move(to: NSPoint(x: 264, y: y))
        glyph.line(to: NSPoint(x: end, y: y))
    }
    glyph.move(to: NSPoint(x: 616, y: 348))
    glyph.line(to: NSPoint(x: 760, y: 512))
    glyph.line(to: NSPoint(x: 616, y: 676))
    glyph.stroke()
    NSGraphicsContext.restoreGraphicsState()
    try bitmap.representation(using: .png, properties: [:])!.write(to: output.appendingPathComponent(entry["filename"]!))
}
