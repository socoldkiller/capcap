import CapcapSupport
import AppKit
import Foundation

/// Narrow interface used by the AppKit translation panel. The concrete bridge
/// is isolated below because macOS 15-25 only vend TranslationSession through a
/// SwiftUI view modifier; no public AppKit session initializer exists there.
@MainActor
package protocol AppleTranslationSessionProviding: AnyObject {
    var hostView: NSView { get }
    func translate(text: String, target: TranslationLanguage) async throws -> String
    func cancel()
}

@MainActor
package enum AppleTranslationSessionProviderFactory {
    package static func makeProvider() -> AppleTranslationSessionProviding? {
#if canImport(Translation) && canImport(SwiftUI)
        guard #available(macOS 15.0, *) else { return nil }
        return AppleTranslationSessionProvider()
#else
        return nil
#endif
    }
}

#if canImport(Translation) && canImport(SwiftUI)
import SwiftUI
import Translation

@available(macOS 15.0, *)
@MainActor
private final class AppleTranslationSessionProvider: AppleTranslationSessionProviding {
    private let model = AppleTranslationBridgeModel()

    package lazy var hostView: NSView = {
        NSHostingView(rootView: AppleTranslationBridgeView(model: model))
    }()

    package func translate(text: String, target: TranslationLanguage) async throws -> String {
        try await model.translate(text: text, target: target)
    }

    package func cancel() {
        model.cancel()
    }
}

@available(macOS 15.0, *)
@MainActor
private final class AppleTranslationBridgeModel: ObservableObject {
    @Published package var configuration: TranslationSession.Configuration?

    private struct PendingRequest {
        package let id: UUID
        package let text: String
        package let continuation: CheckedContinuation<String, Error>
    }

    private var pendingRequest: PendingRequest?

    package func translate(text: String, target: TranslationLanguage) async throws -> String {
        let requestID = UUID()
        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                pendingRequest?.continuation.resume(throwing: CancellationError())
                pendingRequest = PendingRequest(
                    id: requestID,
                    text: text,
                    continuation: continuation
                )

                let targetLanguage = Locale.Language(identifier: target.localeIdentifier)
                var nextConfiguration = TranslationSession.Configuration(
                    source: nil,
                    target: targetLanguage
                )
                if let current = configuration,
                   current.source == nil,
                   current.target == targetLanguage {
                    nextConfiguration = current
                    nextConfiguration.invalidate()
                }
                configuration = nextConfiguration
            }
        } onCancel: {
            Task { @MainActor [weak self] in
                self?.cancel(requestID: requestID)
            }
        }
    }

    package func performPendingTranslation(using session: TranslationSession) async {
        guard let request = pendingRequest else { return }
        do {
            let response = try await session.translate(request.text)
            finish(requestID: request.id, result: .success(response.targetText))
        } catch {
            finish(requestID: request.id, result: .failure(error))
        }
    }

    package func cancel() {
        guard let request = pendingRequest else {
            configuration = nil
            return
        }
        pendingRequest = nil
        configuration = nil
        request.continuation.resume(throwing: CancellationError())
    }

    private func cancel(requestID: UUID) {
        guard pendingRequest?.id == requestID else { return }
        cancel()
    }

    private func finish(requestID: UUID, result: Result<String, Error>) {
        guard let request = pendingRequest, request.id == requestID else { return }
        pendingRequest = nil
        configuration = nil
        request.continuation.resume(with: result)
    }
}

@available(macOS 15.0, *)
private struct AppleTranslationBridgeView: View {
    @ObservedObject package var model: AppleTranslationBridgeModel

    package var body: some View {
        Color.clear
            .allowsHitTesting(false)
            .translationTask(model.configuration) { session in
                await model.performPendingTranslation(using: session)
            }
    }
}
#endif
