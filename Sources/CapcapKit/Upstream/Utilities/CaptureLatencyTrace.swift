import CapcapSupport
import Foundation

/// Preserves the screenshot trigger API used across asynchronous capture paths.
package struct CaptureTriggerContext: @unchecked Sendable {
    package enum Source: String, Sendable {
        case keyboardShortcut = "keyboard-shortcut"
        case doubleCommand = "double-command"
        case menu
        case countdown
        case programmatic
    }

    package let trace: CaptureLatencyTrace

    package init(
        source: Source,
        eventUptime: TimeInterval = ProcessInfo.processInfo.systemUptime
    ) {
        self.trace = CaptureLatencyTrace(
            sessionID: UUID(),
            source: source,
            eventUptime: eventUptime
        )
    }

    package func mark(_ stage: CaptureLatencyTrace.Stage) {
        trace.mark(stage)
    }

    package func finish(_ outcome: CaptureLatencyTrace.Outcome) {
        trace.finish(outcome)
    }
}

/// No-op compatibility surface retained so trigger plumbing stays unchanged.
package final class CaptureLatencyTrace: @unchecked Sendable {
    package enum Stage: String, Sendable {
        case carbonEventReceived = "carbon-event-received"
        case doubleCommandDetected = "double-command-detected"
        case mainRunLoopCallback = "main-run-loop-callback"
        case handleTrigger = "handle-trigger"
        case startCapture = "start-capture"
        case overlayInitialized = "overlay-initialized"
        case activateRequested = "activate-requested"
        case backgroundPreparationStarted = "background-preparation-started"
        case windowEnumerationReady = "window-enumeration-ready"
        case windowEnumerationApplied = "window-enumeration-applied"
        case snapshotCaptureStarted = "snapshot-capture-started"
        case snapshotResultReady = "snapshot-result-ready"
        case snapshotResultApplied = "snapshot-result-applied"
        case overlayOrderedFront = "overlay-ordered-front"
        case firstDrawCompleted = "first-draw-completed"
        case firstFrame = "first-frame"
    }

    package enum Outcome: String, Sendable {
        case presented
        case cancelled
        case superseded
        case failed
        case ignored
        case rerouted
    }

    package init(
        sessionID _: UUID,
        source _: CaptureTriggerContext.Source,
        eventUptime _: TimeInterval
    ) {}

    package func mark(_: Stage) {}

    package func finish(_: Outcome) {}
}
