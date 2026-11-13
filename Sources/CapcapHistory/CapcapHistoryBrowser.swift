import AppKit
import CapcapKit
import CapcapSupport

@MainActor
public final class CapcapHistoryBrowser {
    private let panel: HistoryPanelController

    public init(editImage: @escaping (NSImage) -> Void) {
        panel = HistoryPanelController { entry in
            if let image = HistoryManager.shared.image(for: entry) { editImage(image) }
        }
    }

    public func setCachingEnabled(_ enabled: Bool) { Defaults.historyCacheEnabled = enabled }
    public func toggle() { panel.toggleFromUserRequest() }
}
