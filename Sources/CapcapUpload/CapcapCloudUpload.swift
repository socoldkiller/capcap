import AppKit
import CapcapSupport

/// Cloud upload is installed explicitly, never by importing screenshot capture.
@MainActor
public enum CapcapCloudUpload {
    public static func install() {
        CapcapUploadIntegration.available = { Defaults.hasUsableUploadProvider }
        CapcapUploadIntegration.uploadImage = { image, screen in UploadManager.shared.upload(image: image, on: screen) }
    }

    public static func upload(image: NSImage, on screen: NSScreen? = nil) {
        UploadManager.shared.upload(image: image, on: screen)
    }
}
