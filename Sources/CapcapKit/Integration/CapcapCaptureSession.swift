import CapcapSupport
import AppKit
import ScreenCaptureKit

public enum CapcapCaptureOutcome {
    case image(NSImage), cancelled, textPanel
}

/// Preserves capcap's window snapping, crosshair and resize/move cursor behavior.
/// The toolbar's drawing is adapted to Zima's compact screenshot design.
@MainActor
public final class CapcapCaptureSession {
    private static weak var active: CapcapCaptureSession?
    private static var pinnedEditor: CapcapCaptureSession?
    private var overlay: OverlayWindowController?
    private weak var hostWindow: NSWindow?
    private var completion: (

    @MainActor (CapcapCaptureOutcome) -> Void)?
    private var preparing = false
    private var opensTextPanel = false
    private var generation = UUID()

    public init() {
        CapcapPreferences.defaults.set(false, forKey: "historyCacheEnabled")
        CapcapPreferences.defaults.set(false, forKey: "clipboardTextCacheEnabled")
        let primary: [ToolbarItemID] = [.rectangle, .line, .pen, .text, .mosaic, .close, .confirm]
        Defaults.toolbarLayout = ToolbarLayout(primary: primary, side: [], hidden: ToolbarLayout.canonicalOrder.filter { !primary.contains($0) })
        CapcapCallbacks.editPinnedImage = { image, dismiss in
            MainActor.assumeIsolated {
                let editor = CapcapCaptureSession()
                Self.pinnedEditor = editor
                editor.edit(image) { output in
                    if case .image(let image) = output { ClipboardManager.copyToClipboard(image: image) }
                    Self.pinnedEditor = nil
                }
                dismiss()
            }
        }
    }

    public func start(completion: @escaping @MainActor (CapcapCaptureOutcome) -> Void) async throws {
        guard !preparing, overlay == nil else { return }
        Self.active?.cancel()
        Self.active = self
        opensTextPanel = false
        CapcapCallbacks.willOpenTextPanel = { [weak self] in self?.opensTextPanel = true }
        preparing = true
        let generation = UUID()
        self.generation = generation
        do {
            _ = try await SCShareableContent.excludingDesktopWindows(false, onScreenWindowsOnly: true)
            try Task.checkCancellation()
            guard self.generation == generation else { return }
        } catch {
            if self.generation == generation {
                preparing = false
                if Self.active === self { Self.active = nil }
            }
            throw error
        }
        preparing = false
        self.completion = completion
        hostWindow = NSApp.keyWindow
        hostWindow?.orderOut(nil)
        let controller = OverlayWindowController(onComplete: { [weak self] image in
            MainActor.assumeIsolated { self?.finish(image) }
        })
        overlay = controller
        controller.activate()
    }

    public func edit(_ image: NSImage, completion: @escaping @MainActor (CapcapCaptureOutcome) -> Void) {
        cancel()
        Self.active?.cancel()
        Self.active = self
        opensTextPanel = false
        CapcapCallbacks.willOpenTextPanel = { [weak self] in self?.opensTextPanel = true }
        self.completion = completion
        hostWindow = NSApp.keyWindow
        hostWindow?.orderOut(nil)
        let controller = OverlayWindowController(presetImage: image, presetSource: .clipboard, onComplete: { [weak self] image in
            MainActor.assumeIsolated { self?.finish(image) }
        })
        overlay = controller
        controller.activate()
    }

    public func cancel() {
        generation = UUID()
        preparing = false
        let controller = overlay
        overlay = nil
        controller?.cancel()
        restoreHost()
        completion = nil
        if Self.active === self { Self.active = nil }
    }

    private func finish(_ image: NSImage?) {
        overlay = nil
        restoreHost()
        let callback = completion
        completion = nil
        if Self.active === self { Self.active = nil }
        if let image { callback?(.image(image)) }
        else { callback?(opensTextPanel ? .textPanel : .cancelled) }
    }

    private func restoreHost() {
        hostWindow?.makeKeyAndOrderFront(nil)
        hostWindow = nil
    }
}
