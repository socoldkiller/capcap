import AppKit

/// Shared semantic colors for capcap's floating dialogs and editor chrome
///
/// AppKit semantic colors already follow the effective appearance when they
/// are used for text or drawing. Layer colors are different: assigning a
/// `CGColor` resolves the color once, so layer-backed views must resolve again
/// from `viewDidChangeEffectiveAppearance`
package enum AdaptiveChrome {
    package static let floatingBackground = NSColor(
        name: NSColor.Name("capcap.floatingBackground")
    ) { appearance in
        isDark(appearance)
            ? NSColor(white: 0.15, alpha: 0.94)
            : NSColor(white: 0.98, alpha: 0.96)
    }

    package static let toolbarBackground = NSColor(
        name: NSColor.Name("capcap.toolbarBackground")
    ) { appearance in
        isDark(appearance)
            ? NSColor(white: 0.12, alpha: 0.90)
            : NSColor(white: 0.97, alpha: 0.94)
    }

    package static let panelBackground = NSColor(
        name: NSColor.Name("capcap.panelBackground")
    ) { appearance in
        isDark(appearance)
            ? NSColor(calibratedRed: 0.13, green: 0.14, blue: 0.16, alpha: 0.98)
            : NSColor(calibratedRed: 0.97, green: 0.975, blue: 0.985, alpha: 0.98)
    }

    package static let popoverBackground = NSColor(
        name: NSColor.Name("capcap.popoverBackground")
    ) { appearance in
        isDark(appearance)
            ? NSColor(calibratedRed: 0.12, green: 0.13, blue: 0.15, alpha: 1)
            : NSColor(calibratedWhite: 0.99, alpha: 1)
    }

    package static let cardBackground = NSColor(
        name: NSColor.Name("capcap.cardBackground")
    ) { appearance in
        isDark(appearance)
            ? NSColor.white.withAlphaComponent(0.06)
            : NSColor.black.withAlphaComponent(0.055)
    }

    package static let border = NSColor(
        name: NSColor.Name("capcap.border")
    ) { appearance in
        isDark(appearance)
            ? NSColor.white.withAlphaComponent(0.16)
            : NSColor.black.withAlphaComponent(0.16)
    }

    package static let subtleFill = NSColor(
        name: NSColor.Name("capcap.subtleFill")
    ) { appearance in
        isDark(appearance)
            ? NSColor.white.withAlphaComponent(0.10)
            : NSColor.black.withAlphaComponent(0.08)
    }

    package static let selectedFill = NSColor(
        name: NSColor.Name("capcap.selectedFill")
    ) { appearance in
        isDark(appearance)
            ? NSColor.white.withAlphaComponent(0.15)
            : NSColor.black.withAlphaComponent(0.10)
    }

    package static let separator = NSColor(
        name: NSColor.Name("capcap.separator")
    ) { appearance in
        isDark(appearance)
            ? NSColor.white.withAlphaComponent(0.20)
            : NSColor.black.withAlphaComponent(0.16)
    }

    package static func isDark(_ appearance: NSAppearance) -> Bool {
        appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
    }

    package static func resolvedColor(_ color: NSColor, for appearance: NSAppearance) -> NSColor {
        var resolved = color
        appearance.performAsCurrentDrawingAppearance {
            resolved = color.usingColorSpace(.deviceRGB) ?? color
        }
        return resolved
    }

    package static func resolvedCGColor(_ color: NSColor, for appearance: NSAppearance) -> CGColor {
        resolvedColor(color, for: appearance).cgColor
    }
}

/// Shared geometry and surface metrics for compact floating operation bars
/// such as the recording HUD and the PIN image toolbar
package enum FloatingControlChrome {
    package static let height: CGFloat = 32
    package static let buttonSide: CGFloat = 24
    package static let cornerRadius: CGFloat = 10
    package static let borderWidth: CGFloat = 0.5
    package static let gap: CGFloat = 8
    package static let screenEdgeInset: CGFloat = 4

    package static func origin(
        for size: NSSize,
        relativeTo anchorRect: NSRect,
        visibleFrame: NSRect?
    ) -> NSPoint {
        var origin = NSPoint(
            x: anchorRect.maxX - size.width - gap,
            y: anchorRect.maxY + gap
        )

        guard let visibleFrame else { return origin }
        if origin.y + size.height > visibleFrame.maxY {
            origin.y = anchorRect.minY - size.height - gap
        }
        origin.x = max(
            visibleFrame.minX + screenEdgeInset,
            min(origin.x, visibleFrame.maxX - size.width - screenEdgeInset)
        )
        origin.y = max(
            visibleFrame.minY + screenEdgeInset,
            min(origin.y, visibleFrame.maxY - size.height - screenEdgeInset)
        )
        return origin
    }
}

/// Layer-backed rounded surface whose colors continue to follow live system
/// appearance changes
package final class AdaptiveChromeSurfaceView: NSView {
    package enum Style {
        case floating
        case toolbar
        case panel
        case popover
        case card

        package var backgroundColor: NSColor {
            switch self {
            case .floating: return AdaptiveChrome.floatingBackground
            case .toolbar: return AdaptiveChrome.toolbarBackground
            case .panel: return AdaptiveChrome.panelBackground
            case .popover: return AdaptiveChrome.popoverBackground
            case .card: return AdaptiveChrome.cardBackground
            }
        }
    }

    package var style: Style {
        didSet { applyAppearance() }
    }
    package var cornerRadius: CGFloat {
        didSet { layer?.cornerRadius = cornerRadius }
    }
    package var borderWidth: CGFloat {
        didSet { layer?.borderWidth = borderWidth }
    }

    package init(style: Style, cornerRadius: CGFloat = 0, borderWidth: CGFloat = 0) {
        self.style = style
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        super.init(frame: .zero)
        wantsLayer = true
        layer?.cornerCurve = .continuous
        layer?.masksToBounds = cornerRadius > 0
        applyAppearance()
    }

    package required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    package override func viewDidChangeEffectiveAppearance() {
        super.viewDidChangeEffectiveAppearance()
        applyAppearance()
    }

    private func applyAppearance() {
        guard let layer else { return }
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.backgroundColor = AdaptiveChrome.resolvedCGColor(style.backgroundColor, for: effectiveAppearance)
        layer.borderColor = AdaptiveChrome.resolvedCGColor(AdaptiveChrome.border, for: effectiveAppearance)
    }
}

/// A one-pixel semantic separator for layer-composited HUD layouts
package final class AdaptiveSeparatorView: NSView {
    package override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        applyAppearance()
    }

    package required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    package override func viewDidChangeEffectiveAppearance() {
        super.viewDidChangeEffectiveAppearance()
        applyAppearance()
    }

    private func applyAppearance() {
        layer?.backgroundColor = AdaptiveChrome.resolvedCGColor(
            AdaptiveChrome.separator,
            for: effectiveAppearance
        )
    }
}
