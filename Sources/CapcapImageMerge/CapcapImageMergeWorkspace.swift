import AppKit

@MainActor
public final class CapcapImageMergeWorkspace {
    public init() {}
    public var onContinueEditing: ((NSImage) -> Void)? {
        get { ImageMergeLauncher.shared.onContinueEditing }
        set { ImageMergeLauncher.shared.onContinueEditing = newValue }
    }
    public func open(images: [URL] = []) {
        if images.isEmpty { ImageMergeLauncher.shared.openEmpty() }
        else { ImageMergeLauncher.shared.open(urls: images) }
    }
}
