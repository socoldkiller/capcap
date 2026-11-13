import CapcapSupport
import AppKit

/// Reuses capcap's OCR and translation behind the host's existing screenshot UI.
@MainActor
public final class CapcapTextService {
    public init() {
        CapcapTextIntegration.actions = CapcapTextActions(
            recognize: { image in try await OCRService.recognizeResult(image: image).text },
            showRecognition: { image, rect, screen in OCRTranslatePanel.presentTextRecognition(image: image, anchorRect: rect, screen: screen) },
            showTranslation: { image, rect, screen in OCRTranslatePanel.presentScreenshotTranslation(image: image, anchorRect: rect, screen: screen) },
            showSettings: { SettingsWindowController.shared.showAsSettings() })
        if CapcapPreferences.defaults.object(forKey: "translation.apple.enabled") == nil {
            TranslationConfigStore.setEnabled(true, for: .apple)
        }
    }

    public func recognizeText(in image: NSImage) async throws -> String {
        try await OCRService.recognizeResult(image: image).text
    }

    public func showTextRecognition(for image: NSImage) {
        guard let screen = NSScreen.main else { return }
        OCRTranslatePanel.presentTextRecognition(image: image, anchorRect: screen.visibleFrame, screen: screen)
    }

    public func showTranslation(for image: NSImage) {
        guard let screen = NSScreen.main else { return }
        OCRTranslatePanel.presentScreenshotTranslation(image: image, anchorRect: screen.visibleFrame, screen: screen)
    }

    public func showSettings() { SettingsWindowController.shared.showAsSettings() }

    public func dismiss() { OCRTranslatePanel.dismissCurrent() }
}
