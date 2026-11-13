import AppKit

/// Separate preferences and resources from both Zima and standalone capcap.
package enum CapcapPreferences {
    package static let defaults = UserDefaults(suiteName: "\(Bundle.main.bundleIdentifier ?? "capcap.host").capcap")!
}

package enum CapcapResources {
    package static let bundle: Bundle = {
        let name = "CapcapKit_CapcapSupport.bundle"
        for directory in [Bundle.main.resourceURL, Bundle.main.executableURL?.deletingLastPathComponent()] {
            if let directory, let bundle = Bundle(url: directory.appendingPathComponent(name)) { return bundle }
        }
        if ["app", "appex"].contains(Bundle.main.bundleURL.pathExtension) {
            preconditionFailure("Missing CapcapKit_CapcapSupport.bundle in host resources")
        }
        return .module
    }()
}

/// Cloud credentials are intentionally session-only in this preview integration.
/// The host can later inject its credential vault without storing keys in preferences.
package enum CapcapSessionSecrets {
    private static let lock = NSLock()
    private static var values: [String: String] = [:]

    package static func value(for key: String) -> String {
        lock.lock(); defer { lock.unlock() }
        return values[key] ?? ""
    }

    package static func set(_ value: String, for key: String) {
        lock.lock(); defer { lock.unlock() }
        if value.isEmpty { values.removeValue(forKey: key) }
        else { values[key] = value }
    }
}


package enum CapcapCallbacks {
    package static var willOpenTextPanel: (() -> Void)?
    package static var editPinnedImage: ((NSImage, @escaping () -> Void) -> Void)?
}
