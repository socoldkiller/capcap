import AppKit

/// Optional screen recorder. No capture/editor, OCR or upload target is required.
@MainActor
public final class CapcapRecordingSession {
    private let engine: RecordingEngine
    public var onProgress: ((Int) -> Void)?
    public var onCompletion: ((URL?, Error?) -> Void)?

    public init(framesPerSecond: Int = 30) {
        engine = RecordingEngine(fps: framesPerSecond)
        engine.onProgress = { [weak self] in self?.onProgress?($0) }
        engine.onCompletion = { [weak self] in self?.onCompletion?($0, $1) }
    }

    public func start(rect: NSRect, screen: NSScreen, systemAudio: Bool = false, microphone: Bool = false) {
        engine.startRecording(rect: rect, screen: screen,
            audioOptions: RecordingAudioOptions(systemAudio: systemAudio, microphone: microphone))
    }
    public func pause() { engine.pauseRecording() }
    public func resume() { engine.resumeRecording() }
    public func stop() { engine.stopRecording() }
    public func cancel() { engine.cancelRecording() }
}
