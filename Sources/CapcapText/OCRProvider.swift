import CapcapSupport
import Foundation

package enum OCRProviderKind: String, CaseIterable, Codable {
    case apple, glmOCR, baidu, tencent, google, azure, ocrSpace, openAICompatible, ollama

    package var displayName: String {
        switch self {
        case .apple: return L10n.ocrProviderApple
        case .glmOCR: return "GLM-OCR · Markdown"
        case .baidu: return L10n.ocrProviderBaidu
        case .tencent: return L10n.ocrProviderTencent
        case .google: return "Google Cloud Vision"
        case .azure: return "Azure AI Vision"
        case .ocrSpace: return "OCR.space"
        case .openAICompatible: return L10n.ocrProviderCompatible
        case .ollama: return "Ollama"
        }
    }

    package var hasGeometry: Bool { self != .openAICompatible && self != .ollama && self != .glmOCR }
    package var needsModel: Bool { self == .openAICompatible || self == .ollama }
    package var needsSecret: Bool { self == .baidu || self == .tencent }
    package var needsEndpoint: Bool { self == .openAICompatible || self == .ollama || self == .azure || self == .glmOCR }

    package var defaultEndpoint: String {
        switch self {
        case .glmOCR: return ""
        case .openAICompatible: return "https://api.openai.com/v1/chat/completions"
        case .ollama: return "http://localhost:11434/api/chat"
        default: return ""
        }
    }

    package var documentationURL: URL {
        let value: String
        switch self {
        case .apple: value = "https://developer.apple.com/documentation/vision/recognizing-text-in-images"
        case .glmOCR: value = "https://github.com/zai-org/GLM-OCR"
        case .baidu: value = "https://ai.baidu.com/ai-doc/OCR/Nkibizxlf"
        case .tencent: value = "https://cloud.tencent.com/document/api/866/33526"
        case .google: value = "https://docs.cloud.google.com/vision/docs/ocr"
        case .azure: value = "https://learn.microsoft.com/en-us/azure/ai-services/computer-vision/how-to/call-analyze-image-40"
        case .ocrSpace: value = "https://ocr.space/ocrapi"
        case .openAICompatible: value = "https://developers.openai.com/api/docs/guides/images-vision"
        case .ollama: value = "https://docs.ollama.com/capabilities/vision"
        }
        return URL(string: value)!
    }
}

package struct OCRProviderConfig: Codable {
    package var apiKey = ""
    package var secretKey = ""
    package var endpoint = ""
    package var model = ""
    package var region = "ap-guangzhou"

    package func normalized() -> Self {
        func trim(_ value: String) -> String { value.trimmingCharacters(in: .whitespacesAndNewlines) }
        return Self(apiKey: trim(apiKey), secretKey: trim(secretKey), endpoint: trim(endpoint),
                    model: trim(model), region: trim(region))
    }

    package func resolvedEndpoint(for kind: OCRProviderKind) -> String {
        endpoint.isEmpty ? kind.defaultEndpoint : endpoint
    }

    package func validate(for kind: OCRProviderKind) throws {
        if kind == .apple { return }
        if kind == .glmOCR { _ = try Self.validatedGLMEndpoint(resolvedEndpoint(for: kind)); return }
        if !kind.needsModel && apiKey.isEmpty { throw OCRProviderError.configuration }
        if kind.needsSecret && secretKey.isEmpty { throw OCRProviderError.configuration }
        if kind.needsModel && model.isEmpty { throw OCRProviderError.configuration }
        if kind == .tencent && region.isEmpty { throw OCRProviderError.configuration }
        if kind.needsEndpoint { _ = try OCRProviderConfig.validatedURL(resolvedEndpoint(for: kind)) }
    }

    /// The explicitly selected self-hosted provider permits HTTP on private IPv4 LANs.
    /// Other cloud providers retain the stricter HTTPS/loopback policy below.
    package static func validatedGLMEndpoint(_ endpoint: String) throws -> URL {
        guard let url = URL(string: endpoint), let host = url.host,
              url.user == nil, url.password == nil, url.fragment == nil else { throw OCRProviderError.endpoint }
        if url.scheme == "https" { return url }
        let components = host.split(separator: ".", omittingEmptySubsequences: false)
        let bytes = components.compactMap { UInt8($0) }
        let isPrivate = components.count == 4 && bytes.count == 4 &&
            (bytes[0] == 10 || bytes[0] == 127 || (bytes[0] == 192 && bytes[1] == 168) ||
             (bytes[0] == 172 && (16...31).contains(bytes[1])))
        guard url.scheme == "http", host == "localhost" || isPrivate else { throw OCRProviderError.endpoint }
        return url
    }

    /// Permit plain HTTP only for a local model server. Cloud credentials and
    /// screenshots must travel over TLS. Use the full API URL, without guessing paths.
    package static func validatedURL(_ endpoint: String) throws -> URL {
        guard let url = URL(string: endpoint), let host = url.host, !host.isEmpty,
              url.user == nil, url.password == nil, url.fragment == nil,
              url.scheme == "https" || (url.scheme == "http"
                && ["localhost", "127.0.0.1", "[::1]", "::1"].contains(host.lowercased())) else {
            throw OCRProviderError.endpoint
        }
        return url
    }
}

/// Follows the existing translation-provider persistence convention. Each
/// provider retains its own settings when the selected provider changes.
package enum OCRConfigStore {
    package static func load(_ kind: OCRProviderKind) -> OCRProviderConfig {
        let data = CapcapPreferences.defaults.data(forKey: key(kind))
        var config = data.flatMap { try? JSONDecoder().decode(OCRProviderConfig.self, from: $0) } ?? OCRProviderConfig()
        config.apiKey = CapcapSessionSecrets.value(for: "ocr.\(kind.rawValue).apiKey")
        config.secretKey = CapcapSessionSecrets.value(for: "ocr.\(kind.rawValue).secretKey")
        return config.normalized()
    }

    package static func save(_ config: OCRProviderConfig, for kind: OCRProviderKind) {
        var config = config.normalized()
        CapcapSessionSecrets.set(config.apiKey, for: "ocr.\(kind.rawValue).apiKey")
        CapcapSessionSecrets.set(config.secretKey, for: "ocr.\(kind.rawValue).secretKey")
        config.apiKey = ""
        config.secretKey = ""
        if let data = try? JSONEncoder().encode(config) {
            CapcapPreferences.defaults.set(data, forKey: key(kind))
        }
    }

    private static func key(_ kind: OCRProviderKind) -> String { "ocr.\(kind.rawValue).config" }
}

package struct OCRResult {
    package let text: String
    package let lines: [RecognizedTextLine]
    package let provider: OCRProviderKind

    package init(text: String? = nil, lines: [RecognizedTextLine] = [], provider: OCRProviderKind) {
        self.text = (text ?? lines.map(\.text).joined(separator: "\n"))
            .trimmingCharacters(in: .whitespacesAndNewlines)
        self.lines = lines
        self.provider = provider
    }
}

package enum OCRProviderError: LocalizedError {
    case configuration, endpoint, image, response, timeout
    case http(Int)
    case service(String)

    package var errorDescription: String? {
        switch self {
        case .configuration: return L10n.ocrConfigurationError
        case .endpoint: return L10n.ocrEndpointError
        case .image: return L10n.ocrImageError
        case .response: return L10n.ocrResponseError
        case .timeout: return L10n.ocrTimeoutError
        case .http(let code): return "\(L10n.ocrRequestFailed) HTTP \(code)"
        case .service(let code): return "\(L10n.ocrRequestFailed) \(code)"
        }
    }
}
