import CapcapSupport
import Foundation

package protocol DirectTranslationProvider {
    static func translate(
        text: String,
        target: TranslationLanguage,
        config: TranslationConfig
    ) async throws -> String
}
