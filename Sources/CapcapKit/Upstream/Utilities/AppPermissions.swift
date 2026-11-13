import CapcapSupport
import AppKit
import AVFoundation

package enum AppPermissions {
    package static var allRequiredGranted: Bool {
        accessibilityGranted && screenRecordingGranted
    }

    package static var accessibilityGranted: Bool {
        AXIsProcessTrusted()
    }

    package static var screenRecordingGranted: Bool {
        CGPreflightScreenCaptureAccess()
    }

    /// Optional permission — NOT part of `allRequiredGranted`. Synchronous,
    /// non-prompting check.
    package static var microphoneGranted: Bool {
        AVAudioApplication.shared.recordPermission == .granted
    }

    /// True once the user explicitly denied access (macOS then ignores
    /// re-prompts, so we deep-link to System Settings instead).
    package static var microphoneDenied: Bool {
        AVAudioApplication.shared.recordPermission == .denied
    }

    /// Async-prompt for mic permission; completion on the main actor. macOS
    /// shows the prompt once — later calls just report the current state.
    package static func requestMicrophonePermission(completion: @escaping @MainActor (Bool) -> Void) {
        AVAudioApplication.requestRecordPermission { granted in
            Task { @MainActor in
                completion(granted)
            }
        }
    }
}
