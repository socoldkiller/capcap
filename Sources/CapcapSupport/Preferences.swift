import Foundation
package struct Defaults {
    package static var language: AppLanguage {
        get {
            // Explicit user choice wins; otherwise follow the system locale on
            // first launch so a fresh install opens in a familiar language.
            if let raw = CapcapPreferences.defaults.string(forKey: "appLanguage"),
               let lang = AppLanguage(rawValue: raw) {
                return lang
            }
            return AppLanguage.systemDefault
        }
        set {
            let old = language
            CapcapPreferences.defaults.set(newValue.rawValue, forKey: "appLanguage")
            if newValue != old {
                NotificationCenter.default.post(name: .languageDidChange, object: nil)
            }
        }
    }
    package static var recordingMicrophoneDeviceUID: String? {
        get {
            CapcapPreferences.defaults.string(forKey: "recordingMicrophoneDeviceUID")
        }
        set {
            CapcapPreferences.defaults.set(newValue, forKey: "recordingMicrophoneDeviceUID")
        }
    }

}
