import AppKit
import CapcapSupport

@MainActor
public enum CapcapPinnedImages {
    public static func install() {
        CapcapPinIntegration.showImage = { image, point, save in PinLauncher.pin(image: image, at: point, saveToHistory: save) }
    }

    public static func pin(_ image: NSImage, at point: NSPoint? = nil) {
        PinLauncher.pin(image: image, at: point)
    }
}
