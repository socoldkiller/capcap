import AVFoundation
import CoreGraphics

package enum VideoAssetMetadata {
    package static func loadFirstVideoTrack(in asset: AVAsset) async throws -> AVAssetTrack? {
        try await asset.loadTracks(withMediaType: .video).first
    }

    package static func pixelSize(for url: URL) async throws -> CGSize? {
        let asset = AVURLAsset(url: url)
        guard let track = try await loadFirstVideoTrack(in: asset) else { return nil }
        return try await pixelSize(for: track)
    }

    package static func pixelSize(for track: AVAssetTrack) async throws -> CGSize? {
        let (naturalSize, preferredTransform) = try await (
            track.load(.naturalSize),
            track.load(.preferredTransform)
        )
        let transformed = naturalSize.applying(preferredTransform)
        let size = CGSize(width: abs(transformed.width), height: abs(transformed.height))
        guard size.width > 0, size.height > 0 else { return nil }
        return size
    }
}
