import CapcapSupport
import AppKit

package final class SourceAppFocusRestorer {
    private let processIdentifier: pid_t?
    private var restoreScheduled = false

    private init(processIdentifier: pid_t?) {
        self.processIdentifier = processIdentifier
    }

    package static func captureFrontmostApplication() -> SourceAppFocusRestorer {
        let ownPID = ProcessInfo.processInfo.processIdentifier
        let app = NSWorkspace.shared.frontmostApplication
        let targetPID = app?.processIdentifier == ownPID ? nil : app?.processIdentifier
        return SourceAppFocusRestorer(processIdentifier: targetPID)
    }

    package func restore() {
        guard !restoreScheduled else { return }
        restoreScheduled = true

        DispatchQueue.main.async { [self] in
            guard
                let processIdentifier,
                let app = NSRunningApplication(processIdentifier: processIdentifier),
                !app.isTerminated,
                app.processIdentifier != ProcessInfo.processInfo.processIdentifier
            else {
                return
            }

            app.activate(options: [.activateAllWindows])
        }
    }
}
