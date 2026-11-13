import AppKit

/// Optional implementations install these callbacks; capture never imports their targets.
package struct CapcapTextActions {
    package let recognize: @MainActor (NSImage) async throws -> String
    package let showRecognition: @MainActor (NSImage, NSRect, NSScreen) -> Void
    package let showTranslation: @MainActor (NSImage, NSRect, NSScreen) -> Void
    package let showSettings: @MainActor () -> Void

    package init(recognize: @escaping @MainActor (NSImage) async throws -> String,
                 showRecognition: @escaping @MainActor (NSImage, NSRect, NSScreen) -> Void,
                 showTranslation: @escaping @MainActor (NSImage, NSRect, NSScreen) -> Void,
                 showSettings: @escaping @MainActor () -> Void) {
        self.recognize = recognize; self.showRecognition = showRecognition
        self.showTranslation = showTranslation; self.showSettings = showSettings
    }
}

package enum CapcapTextIntegration {
    @MainActor package static var actions: CapcapTextActions?
    package static var isAvailable: Bool { MainActor.assumeIsolated { actions != nil } }
    @MainActor package static func recognizeText(image: NSImage) async throws -> String {
        guard let actions else { throw CocoaError(.featureUnsupported) }
        return try await actions.recognize(image)
    }
    package static func presentTextRecognition(image: NSImage, anchorRect: NSRect, screen: NSScreen) {
        MainActor.assumeIsolated { actions?.showRecognition(image, anchorRect, screen) }
    }
    package static func presentScreenshotTranslation(image: NSImage, anchorRect: NSRect, screen: NSScreen) {
        MainActor.assumeIsolated { actions?.showTranslation(image, anchorRect, screen) }
    }
    package static func showSettings() { MainActor.assumeIsolated { actions?.showSettings() } }
}

package enum CapcapUploadIntegration {
    @MainActor package static var available: (@MainActor () -> Bool)?
    @MainActor package static var uploadImage: (@MainActor (NSImage, NSScreen?) -> Void)?
    package static var isAvailable: Bool { MainActor.assumeIsolated { available?() == true } }
    package static func upload(image: NSImage, on screen: NSScreen?) { MainActor.assumeIsolated { uploadImage?(image, screen) } }
}

package enum CapcapPinIntegration {
    @MainActor package static var showImage: (@MainActor (NSImage, NSPoint?, Bool) -> Void)?
    package static var isAvailable: Bool { MainActor.assumeIsolated { showImage != nil } }
    package static func pin(image: NSImage, at point: NSPoint? = nil, saveToHistory: Bool = true) {
        MainActor.assumeIsolated { showImage?(image, point, saveToHistory) }
    }
}
