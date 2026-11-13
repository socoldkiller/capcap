import CapcapSupport
import Foundation

package enum ScreenshotImageQuality: String, CaseIterable {
    case original
    case compressed

    package static let defaultValue: ScreenshotImageQuality = .original

    package var localizedTitle: String {
        switch self {
        case .original: return L10n.screenshotQualityOriginal
        case .compressed: return L10n.screenshotQualityCompressed
        }
    }

    package var localizedHint: String {
        switch self {
        case .original: return L10n.screenshotQualityOriginalHint
        case .compressed: return L10n.screenshotQualityCompressedHint
        }
    }

    package var fileExtension: String {
        switch self {
        case .original: return "png"
        case .compressed: return "compressed.png"
        }
    }

    package var contentType: String {
        "image/png"
    }

    package var usesLossyCompression: Bool {
        self == .compressed
    }
}
