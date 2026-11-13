import CapcapSupport
import Foundation
extension Defaults {
    /// An explicit selection applies to every image-to-text entry point.
    package static var ocrProviderKind: OCRProviderKind {
        get {
            OCRProviderKind(rawValue: CapcapPreferences.defaults.string(forKey: "ocr.provider") ?? "") ?? .apple
        }
        set { CapcapPreferences.defaults.set(newValue.rawValue, forKey: "ocr.provider") }
    }
}

