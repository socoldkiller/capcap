import CapcapSupport
import AppKit

/// Host-owned integration exposes only the OCR/translation settings needed here.
package final class SettingsWindowController: NSWindowController {
    package static let shared = SettingsWindowController()

    private init() {
        let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 720, height: 640),
            styleMask: [.titled, .closable, .resizable], backing: .buffered, defer: false)
        window.title = "OCR 与翻译设置"
        window.isReleasedWhenClosed = false
        // Upstream provider cards currently use a dark palette.
        window.appearance = NSAppearance(named: .darkAqua)
        super.init(window: window)
        let tabs = NSTabViewController()
        tabs.tabStyle = .toolbar
        for (title, pane) in [("OCR", OCRSettingsPane() as NSView), ("翻译", TranslationSettingsPane() as NSView)] {
            let controller = NSViewController()
            let scroll = NSScrollView()
            scroll.hasVerticalScroller = true
            scroll.drawsBackground = false
            scroll.documentView = pane
            controller.view = scroll
            pane.widthAnchor.constraint(equalTo: scroll.contentView.widthAnchor).isActive = true
            let item = NSTabViewItem(viewController: controller)
            item.label = title
            tabs.addTabViewItem(item)
        }
        window.contentViewController = tabs
        window.center()
    }

    package required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    package func showAsSettings(focusingPermissions: Bool? = nil) {
        showWindow(nil)
        window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}
