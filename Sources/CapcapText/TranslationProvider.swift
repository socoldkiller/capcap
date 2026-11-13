import CapcapSupport
import Foundation

// MARK: - Target language

/// Languages the OCR text can be translated into. The source language is
/// detected locally before the provider request, so only the target is configurable.
package enum TranslationLanguage: String, CaseIterable {
    case chinese = "zh"
    case english = "en"
    case vietnamese = "vi"
    case hindi = "hi"
    case spanish = "es"
    case french = "fr"
    case arabic = "ar"
    case bengali = "bn"
    case portuguese = "pt"
    case russian = "ru"
    case urdu = "ur"
    case indonesian = "id"
    case german = "de"
    case japanese = "ja"
    case korean = "ko"
    case turkish = "tr"

    package static var appDefault: TranslationLanguage {
        switch Defaults.language {
        case .zh: return .chinese
        case .zhTW: return .chinese
        case .en: return .english
        case .vi: return .vietnamese
        case .ja: return .japanese
        case .ko: return .korean
        case .fr: return .french
        case .ru: return .russian
        }
    }

    package var displayName: String {
        switch self {
        case .chinese:    return "中文"
        case .english:    return "English"
        case .vietnamese: return "Tiếng Việt"
        case .hindi:      return "हिन्दी"
        case .spanish:    return "Español"
        case .french:     return "Français"
        case .arabic:     return "العربية"
        case .bengali:    return "বাংলা"
        case .portuguese: return "Português"
        case .russian:    return "Русский"
        case .urdu:       return "اردو"
        case .indonesian: return "Indonesia"
        case .german:     return "Deutsch"
        case .japanese:   return "日本語"
        case .korean:     return "한국어"
        case .turkish:    return "Türkçe"
        }
    }

    package var localeIdentifier: String {
        switch self {
        case .chinese:    return "zh-Hans"
        case .english:    return "en"
        case .vietnamese: return "vi"
        case .hindi:      return "hi"
        case .spanish:    return "es"
        case .french:     return "fr"
        case .arabic:     return "ar"
        case .bengali:    return "bn"
        case .portuguese: return "pt"
        case .russian:    return "ru"
        case .urdu:       return "ur"
        case .indonesian: return "id"
        case .german:     return "de"
        case .japanese:   return "ja"
        case .korean:     return "ko"
        case .turkish:    return "tr"
        }
    }

    package var localizedDisplayName: String {
        let locale = Locale(identifier: Defaults.language.lprojName)
        return locale.localizedString(forIdentifier: localeIdentifier) ?? displayName
    }

    /// English name fed into the translation prompt.
    package var promptName: String {
        switch self {
        case .chinese:    return "Simplified Chinese"
        case .english:    return "English"
        case .vietnamese: return "Vietnamese"
        case .hindi:      return "Hindi"
        case .spanish:    return "Spanish"
        case .french:     return "French"
        case .arabic:     return "Arabic"
        case .bengali:    return "Bengali"
        case .portuguese: return "Portuguese"
        case .russian:    return "Russian"
        case .urdu:       return "Urdu"
        case .indonesian: return "Indonesian"
        case .german:     return "German"
        case .japanese:   return "Japanese"
        case .korean:     return "Korean"
        case .turkish:    return "Turkish"
        }
    }
}

// MARK: - Provider kinds

/// Translation providers. OpenAI / DeepSeek / Custom all speak the OpenAI
/// chat-completions wire format; Claude, DeepL, and DeepLX use their own APIs.
package enum TranslationProviderKind: String, CaseIterable {
    case apple
    case openai
    case deepseek
    case deepl
    case deeplx
    case custom
    case claude

    package var displayName: String {
        switch self {
        case .apple:    return "Apple Translation"
        case .openai:   return "OpenAI"
        case .deepseek: return "DeepSeek"
        case .deepl:    return "DeepL"
        case .deeplx:   return "DeepLX"
        case .custom:   return L10n.translationProviderCustom
        case .claude:   return "Claude"
        }
    }

    /// Apple's on-device Translation framework is available starting in macOS 15.
    package var isAvailableOnCurrentSystem: Bool {
        switch self {
        case .apple:
            if #available(macOS 15.0, *) { return true }
            return false
        default:
            return true
        }
    }

    package var isAppleTranslation: Bool { self == .apple }

    /// Claude needs a different request shape and SSE parser.
    package var isClaude: Bool { self == .claude }

    /// DeepL uses a non-SSE JSON response instead of chat completions.
    package var isDeepL: Bool { self == .deepl }

    /// DeepLX uses a non-SSE JSON response instead of chat completions.
    package var isDeepLX: Bool { self == .deeplx }

    package var isDirectTranslationAPI: Bool { isDeepL || isDeepLX || isAppleTranslation }

    package var defaultEndpoint: String {
        switch self {
        case .apple:    return ""
        case .openai:   return "https://api.openai.com/v1/chat/completions"
        case .deepseek: return "https://api.deepseek.com/chat/completions"
        case .deepl:    return "https://api.deepl.com/v2/translate"
        case .deeplx:   return "https://api.deeplx.org/{{apiKey}}/translate"
        case .custom:   return ""
        case .claude:   return "https://api.anthropic.com/v1/messages"
        }
    }

    package var defaultModel: String {
        switch self {
        case .apple:    return ""
        case .openai:   return "gpt-4o-mini"
        case .deepseek: return "deepseek-v4-flash"
        case .deepl:    return ""
        case .deeplx:   return ""
        case .custom:   return ""
        case .claude:   return "claude-3-5-haiku-latest"
        }
    }

    /// Custom must supply its own endpoint; the rest ship a sensible default
    /// but still allow an override (e.g. a proxy).
    package var endpointRequired: Bool { self == .custom }

    /// DeepLX can be self-hosted without an API key.
    package var isAPIKeyRequired: Bool { !isDeepLX && !isAppleTranslation }
}

extension TranslationLanguage {
    /// DeepL target language code. Generic variants are used where possible;
    /// Chinese prefers the explicit simplified variant.
    package var deepLTargetCode: String {
        switch self {
        case .chinese:    return "ZH-HANS"
        case .english:    return "EN"
        case .vietnamese: return "VI"
        case .hindi:      return "HI"
        case .spanish:    return "ES"
        case .french:     return "FR"
        case .arabic:     return "AR"
        case .bengali:    return "BN"
        case .portuguese: return "PT"
        case .russian:    return "RU"
        case .urdu:       return "UR"
        case .indonesian: return "ID"
        case .german:     return "DE"
        case .japanese:   return "JA"
        case .korean:     return "KO"
        case .turkish:    return "TR"
        }
    }

}

// MARK: - Config model

package struct TranslationConfig {
    package var apiKey: String = ""
    package var model: String = ""
    package var endpoint: String = ""

    package func resolvedModel(for kind: TranslationProviderKind) -> String {
        let trimmed = model.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? kind.defaultModel : trimmed
    }

    package func resolvedEndpoint(for kind: TranslationProviderKind) -> String {
        let trimmed = endpoint.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? kind.defaultEndpoint : trimmed
    }
}

// MARK: - Dictionary mode

package struct DictionaryEntry: Codable, Equatable {
    package var word: String
    package var phonetic: String
    package var partOfSpeech: String
    package var definition: String
    package var example: String
    package var exampleTranslation: String
    package var difficulty: String

    package init(
        word: String = "",
        phonetic: String = "",
        partOfSpeech: String = "",
        definition: String = "",
        example: String = "",
        exampleTranslation: String = "",
        difficulty: String = ""
    ) {
        self.word = word
        self.phonetic = phonetic
        self.partOfSpeech = partOfSpeech
        self.definition = definition
        self.example = example
        self.exampleTranslation = exampleTranslation
        self.difficulty = difficulty
    }

    package init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        word = try container.decodeIfPresent(String.self, forKey: .word) ?? ""
        phonetic = try container.decodeIfPresent(String.self, forKey: .phonetic) ?? ""
        partOfSpeech = try container.decodeIfPresent(String.self, forKey: .partOfSpeech) ?? ""
        definition = try container.decodeIfPresent(String.self, forKey: .definition) ?? ""
        example = try container.decodeIfPresent(String.self, forKey: .example) ?? ""
        exampleTranslation = try container.decodeIfPresent(String.self, forKey: .exampleTranslation) ?? ""
        difficulty = try container.decodeIfPresent(String.self, forKey: .difficulty) ?? ""
    }

    package func normalized(fallbackWord: String) -> DictionaryEntry {
        DictionaryEntry(
            word: cleaned(word).isEmpty ? fallbackWord : cleaned(word),
            phonetic: cleaned(phonetic),
            partOfSpeech: cleaned(partOfSpeech),
            definition: cleaned(definition),
            example: cleaned(example),
            exampleTranslation: cleaned(exampleTranslation),
            difficulty: cleaned(difficulty)
        )
    }

    private func cleaned(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// MARK: - Persistence

/// Stores one JSON-encoded config plus an enabled flag per provider in
/// UserDefaults — mirrors the upload `ProviderConfigStore` pattern.
package enum TranslationConfigStore {
    private static let providerOrderKey = "translation.providerOrder"

    private static func configKey(for kind: TranslationProviderKind) -> String {
        "translation.\(kind.rawValue).config"
    }

    private static func enabledKey(for kind: TranslationProviderKind) -> String {
        "translation.\(kind.rawValue).enabled"
    }

    package static func load(_ kind: TranslationProviderKind) -> TranslationConfig {
        guard let data = CapcapPreferences.defaults.data(forKey: configKey(for: kind)),
              let dict = try? JSONDecoder().decode([String: String].self, from: data) else {
            return TranslationConfig()
        }
        return TranslationConfig(
            apiKey: CapcapSessionSecrets.value(for: "translation.\(kind.rawValue).apiKey"),
            model: dict["model"] ?? "",
            endpoint: dict["endpoint"] ?? ""
        )
    }

    package static func save(_ config: TranslationConfig, for kind: TranslationProviderKind) {
        CapcapSessionSecrets.set(config.apiKey.trimmingCharacters(in: .whitespacesAndNewlines),
                                for: "translation.\(kind.rawValue).apiKey")
        let dict = [
            "model": config.model.trimmingCharacters(in: .whitespacesAndNewlines),
            "endpoint": config.endpoint.trimmingCharacters(in: .whitespacesAndNewlines),
        ]
        if let data = try? JSONEncoder().encode(dict) {
            CapcapPreferences.defaults.set(data, forKey: configKey(for: kind))
        }
        NotificationCenter.default.post(name: .translationConfigDidChange, object: nil)
    }

    package static func clear(_ kind: TranslationProviderKind) {
        CapcapSessionSecrets.set("", for: "translation.\(kind.rawValue).apiKey")
        CapcapPreferences.defaults.removeObject(forKey: configKey(for: kind))
        NotificationCenter.default.post(name: .translationConfigDidChange, object: nil)
    }

    package static func isEnabled(_ kind: TranslationProviderKind) -> Bool {
        let key = enabledKey(for: kind)
        if CapcapPreferences.defaults.object(forKey: key) == nil {
            return false
        }
        return CapcapPreferences.defaults.bool(forKey: key)
    }

    package static func setEnabled(_ enabled: Bool, for kind: TranslationProviderKind) {
        CapcapPreferences.defaults.set(enabled, forKey: enabledKey(for: kind))
        NotificationCenter.default.post(name: .translationConfigDidChange, object: nil)
    }

    /// True when the saved config has the fields a request needs.
    package static func isConfigured(_ kind: TranslationProviderKind) -> Bool {
        if kind.isAppleTranslation { return kind.isAvailableOnCurrentSystem }
        let cfg = load(kind)
        if kind.isAPIKeyRequired {
            guard !cfg.apiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }
        }
        if kind.endpointRequired {
            return !cfg.endpoint.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        return true
    }

    /// Enabled AND configured — the providers shown in the OCR panel.
    package static func isUsable(_ kind: TranslationProviderKind) -> Bool {
        kind.isAvailableOnCurrentSystem && isEnabled(kind) && isConfigured(kind)
    }

    package static func orderedKinds() -> [TranslationProviderKind] {
        let saved = CapcapPreferences.defaults.stringArray(forKey: providerOrderKey) ?? []
        var seen = Set<TranslationProviderKind>()
        var result: [TranslationProviderKind] = []

        for raw in saved {
            guard let kind = TranslationProviderKind(rawValue: raw),
                  kind.isAvailableOnCurrentSystem,
                  !seen.contains(kind) else { continue }
            result.append(kind)
            seen.insert(kind)
        }

        for kind in TranslationProviderKind.allCases
            where kind.isAvailableOnCurrentSystem && !seen.contains(kind) {
            result.append(kind)
            seen.insert(kind)
        }

        return result
    }

    package static func setProviderOrder(_ kinds: [TranslationProviderKind]) {
        var seen = Set<TranslationProviderKind>()
        var normalized: [TranslationProviderKind] = []

        for kind in kinds where !seen.contains(kind) {
            normalized.append(kind)
            seen.insert(kind)
        }

        for kind in TranslationProviderKind.allCases where !seen.contains(kind) {
            normalized.append(kind)
            seen.insert(kind)
        }

        CapcapPreferences.defaults.set(normalized.map(\.rawValue), forKey: providerOrderKey)
        NotificationCenter.default.post(name: .translationConfigDidChange, object: nil)
    }

    package static func usableKinds() -> [TranslationProviderKind] {
        orderedKinds().filter { isUsable($0) }
    }
}

// MARK: - Target language preference

extension Defaults {
    package static var translationTargetLanguage: TranslationLanguage {
        get {
            let raw = CapcapPreferences.defaults.string(forKey: "translation.targetLanguage") ?? ""
            return TranslationLanguage(rawValue: raw) ?? .chinese
        }
        set {
            CapcapPreferences.defaults.set(newValue.rawValue, forKey: "translation.targetLanguage")
        }
    }

    package static var translationDictionaryMode: Bool {
        get { CapcapPreferences.defaults.bool(forKey: "translation.dictionaryMode") }
        set {
            CapcapPreferences.defaults.set(newValue, forKey: "translation.dictionaryMode")
            NotificationCenter.default.post(name: .translationConfigDidChange, object: nil)
        }
    }
}
