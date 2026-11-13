import AppKit
import Testing
import CapcapSupport
@testable import CapcapText
import CapcapUpload
import CapcapPinning

@Suite(.serialized)
@MainActor
struct OptionalCapabilityTests {
    @Test func absentTextCapabilityFailsWithoutStartingWork() async {
        let previous = CapcapTextIntegration.actions
        defer { CapcapTextIntegration.actions = previous }
        CapcapTextIntegration.actions = nil
        #expect(!CapcapTextIntegration.isAvailable)
        await #expect(throws: CocoaError.self) {
            _ = try await CapcapTextIntegration.recognizeText(image: NSImage())
        }
    }

    @Test func textActionsPreserveImageAndSettingsRouting() async throws {
        let previous = CapcapTextIntegration.actions
        defer { CapcapTextIntegration.actions = previous }
        let image = NSImage(size: NSSize(width: 20, height: 10))
        var recognizedImage: NSImage?
        var settingsOpened = false
        CapcapTextIntegration.actions = .init(
            recognize: { recognizedImage = $0; return "recognized" },
            showRecognition: { _, _, _ in }, showTranslation: { _, _, _ in },
            showSettings: { settingsOpened = true })
        #expect(try await CapcapTextIntegration.recognizeText(image: image) == "recognized")
        #expect(recognizedImage === image)
        CapcapTextIntegration.showSettings()
        #expect(settingsOpened)
    }

    @Test func optionalPinAndUploadInstallWithoutOpeningWindows() {
        let previousPin = CapcapPinIntegration.showImage
        let previousUpload = CapcapUploadIntegration.uploadImage
        let previousAvailability = CapcapUploadIntegration.available
        defer {
            CapcapPinIntegration.showImage = previousPin
            CapcapUploadIntegration.uploadImage = previousUpload
            CapcapUploadIntegration.available = previousAvailability
        }
        CapcapPinIntegration.showImage = nil
        CapcapUploadIntegration.uploadImage = nil
        #expect(!CapcapPinIntegration.isAvailable)
        CapcapPinnedImages.install()
        CapcapCloudUpload.install()
        #expect(CapcapPinIntegration.isAvailable)
        #expect(CapcapUploadIntegration.uploadImage != nil)
        #expect(CapcapUploadIntegration.available != nil)
    }

    @Test func freshOCRUsesAppleAndRequiresExplicitGLMEndpoint() throws {
        let preferences = try #require(UserDefaults(suiteName: "\(Bundle.main.bundleIdentifier ?? "capcap.host").capcap"))
        let previous = preferences.object(forKey: "ocr.provider")
        defer { preferences.set(previous, forKey: "ocr.provider") }
        preferences.removeObject(forKey: "ocr.provider")
        #expect(Defaults.ocrProviderKind == .apple)
        #expect(OCRProviderKind.glmOCR.defaultEndpoint.isEmpty)
        #expect(throws: (any Error).self) { try OCRProviderConfig().validate(for: .glmOCR) }
        preferences.set("glmOCR", forKey: "ocr.provider")
        #expect(Defaults.ocrProviderKind == .glmOCR)
    }

}
