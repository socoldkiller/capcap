import Foundation
package enum ScreenRecordingFormat: String, CaseIterable {
    case mp4
    case gif

    package var fileExtension: String { rawValue }

    package var displayName: String {
        switch self {
        case .mp4: return L10n.recordingFormatMP4
        case .gif: return L10n.recordingFormatGIF
        }
    }
}

package enum RecordingSavePreference: String, CaseIterable {
    case manual
    case gif
    case mp4

    package var displayName: String {
        switch self {
        case .manual: return L10n.recordingFormatManual
        case .gif: return L10n.recordingFormatGIF
        case .mp4: return L10n.recordingFormatMP4
        }
    }

    package var format: ScreenRecordingFormat? {
        switch self {
        case .manual: return nil
        case .gif: return .gif
        case .mp4: return .mp4
        }
    }
}

