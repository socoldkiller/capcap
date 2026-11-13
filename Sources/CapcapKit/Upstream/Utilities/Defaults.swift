import CapcapSupport
import Foundation

extension Defaults {
    private static var defaults: UserDefaults {
        CapcapPreferences.defaults
    }

    package static var doubleTapInterval: TimeInterval {
        get {
            let val = defaults.double(forKey: "doubleTapInterval")
            return val > 0 ? val : 0.3
        }
        set {
            defaults.set(newValue, forKey: "doubleTapInterval")
        }
    }

    // Custom screenshot hotkey. When the key is absent, no custom hotkey is set
    // (fall back to double-tap ⌘). keyCode 0 is a valid value — it is the `A` key
    // (kVK_ANSI_A) — so presence must be checked via `hasCustomScreenshotHotkey`,
    // never by comparing the key code to 0.
    // Modifiers are stored using Carbon flags (cmdKey | shiftKey | optionKey | controlKey).

    package static var screenshotHotkeyKeyCode: Int {
        get { defaults.integer(forKey: "screenshotHotkeyKeyCode") }
        set { defaults.set(newValue, forKey: "screenshotHotkeyKeyCode") }
    }

    package static var screenshotHotkeyModifiers: Int {
        get { defaults.integer(forKey: "screenshotHotkeyModifiers") }
        set { defaults.set(newValue, forKey: "screenshotHotkeyModifiers") }
    }

    package static var hasCustomScreenshotHotkey: Bool {
        defaults.object(forKey: "screenshotHotkeyKeyCode") != nil
    }

    package static func clearScreenshotHotkey() {
        defaults.removeObject(forKey: "screenshotHotkeyKeyCode")
        defaults.removeObject(forKey: "screenshotHotkeyModifiers")
    }

    package static let selectionAspectRatioPresets: [CGFloat] = [
        1.0,
        2.35,
        3.0,
        3.0 / 2.0,
        4.0 / 3.0,
        9.0 / 16.0,
        16.0 / 9.0,
    ]

    package static var selectionAspectRatio: Double {
        get {
            let ratio = defaults.double(forKey: "selectionAspectRatio")
            return ratio > 0 && ratio.isFinite ? ratio : 0
        }
        set {
            guard newValue > 0, newValue.isFinite else {
                clearSelectionAspectRatio()
                return
            }
            defaults.set(newValue, forKey: "selectionAspectRatio")
        }
    }

    package static var hasSelectionAspectRatio: Bool {
        defaults.object(forKey: "selectionAspectRatio") != nil && selectionAspectRatio > 0
    }

    package static func clearSelectionAspectRatio() {
        defaults.removeObject(forKey: "selectionAspectRatio")
    }

    private static func clearLegacyPinHotkey() {
        defaults.removeObject(forKey: "pinHotkeyKeyCode")
        defaults.removeObject(forKey: "pinHotkeyModifiers")
    }

    // Custom pin-image hotkeys. They are global Carbon hotkeys with no
    // defaults: users opt in from Settings. Quick Pin captures a screen
    // selection; the other shortcuts read Finder or clipboard content.

    package static var quickPinHotkeyKeyCode: Int {
        get { defaults.integer(forKey: "quickPinHotkeyKeyCode") }
        set { defaults.set(newValue, forKey: "quickPinHotkeyKeyCode") }
    }

    package static var quickPinHotkeyModifiers: Int {
        get { defaults.integer(forKey: "quickPinHotkeyModifiers") }
        set { defaults.set(newValue, forKey: "quickPinHotkeyModifiers") }
    }

    package static var hasCustomQuickPinHotkey: Bool {
        defaults.object(forKey: "quickPinHotkeyKeyCode") != nil
    }

    package static func clearQuickPinHotkey() {
        defaults.removeObject(forKey: "quickPinHotkeyKeyCode")
        defaults.removeObject(forKey: "quickPinHotkeyModifiers")
    }

    package static var selectedImagePinHotkeyKeyCode: Int {
        get { defaults.integer(forKey: "selectedImagePinHotkeyKeyCode") }
        set { defaults.set(newValue, forKey: "selectedImagePinHotkeyKeyCode") }
    }

    package static var selectedImagePinHotkeyModifiers: Int {
        get { defaults.integer(forKey: "selectedImagePinHotkeyModifiers") }
        set { defaults.set(newValue, forKey: "selectedImagePinHotkeyModifiers") }
    }

    package static var hasCustomSelectedImagePinHotkey: Bool {
        defaults.object(forKey: "selectedImagePinHotkeyKeyCode") != nil
    }

    package static func clearSelectedImagePinHotkey() {
        defaults.removeObject(forKey: "selectedImagePinHotkeyKeyCode")
        defaults.removeObject(forKey: "selectedImagePinHotkeyModifiers")
    }

    package static var clipboardImagePinHotkeyKeyCode: Int {
        get { defaults.integer(forKey: "clipboardImagePinHotkeyKeyCode") }
        set { defaults.set(newValue, forKey: "clipboardImagePinHotkeyKeyCode") }
    }

    package static var clipboardImagePinHotkeyModifiers: Int {
        get { defaults.integer(forKey: "clipboardImagePinHotkeyModifiers") }
        set { defaults.set(newValue, forKey: "clipboardImagePinHotkeyModifiers") }
    }

    package static var hasCustomClipboardImagePinHotkey: Bool {
        defaults.object(forKey: "clipboardImagePinHotkeyKeyCode") != nil
    }

    package static func clearClipboardImagePinHotkey() {
        defaults.removeObject(forKey: "clipboardImagePinHotkeyKeyCode")
        defaults.removeObject(forKey: "clipboardImagePinHotkeyModifiers")
    }

    package static var clipboardTextPinHotkeyKeyCode: Int {
        get { defaults.integer(forKey: "clipboardTextPinHotkeyKeyCode") }
        set { defaults.set(newValue, forKey: "clipboardTextPinHotkeyKeyCode") }
    }

    package static var clipboardTextPinHotkeyModifiers: Int {
        get { defaults.integer(forKey: "clipboardTextPinHotkeyModifiers") }
        set { defaults.set(newValue, forKey: "clipboardTextPinHotkeyModifiers") }
    }

    package static var hasCustomClipboardTextPinHotkey: Bool {
        defaults.object(forKey: "clipboardTextPinHotkeyKeyCode") != nil
    }

    package static func clearClipboardTextPinHotkey() {
        defaults.removeObject(forKey: "clipboardTextPinHotkeyKeyCode")
        defaults.removeObject(forKey: "clipboardTextPinHotkeyModifiers")
    }

    package static func resetShortcutHotkeysToDefaults() {
        clearScreenshotHotkey()
        clearLegacyPinHotkey()
        clearQuickPinHotkey()
        clearSelectedImagePinHotkey()
        clearClipboardImagePinHotkey()
        clearClipboardTextPinHotkey()
        clearSelectedImageEditHotkey()
        clearClipboardImageEditHotkey()
        clearTextRecognitionHotkey()
        clearCopyImageTextHotkey()
        clearScreenshotTranslationHotkey()
        clearRecordHotkey()
        clearImageMergeHotkey()
        clearFinderUploadHotkey()
        clearFullScreenScreenshotHotkey()
        clearColorPickerHotkey()
        clearClipboardHotkey()
        clearFileSaveHotkey()
        clearPreviousHistoryImageHotkey()
        clearNextHistoryImageHotkey()
        clearHistoryPanelHotkey()
    }

    // Custom image-edit hotkeys. They are global Carbon hotkeys with no
    // defaults: users opt in from Settings. The selected-image shortcut reads
    // one image selected in Finder; the clipboard-image shortcut reads only
    // the clipboard image.

    package static var selectedImageEditHotkeyKeyCode: Int {
        get { defaults.integer(forKey: "selectedImageEditHotkeyKeyCode") }
        set { defaults.set(newValue, forKey: "selectedImageEditHotkeyKeyCode") }
    }

    package static var selectedImageEditHotkeyModifiers: Int {
        get { defaults.integer(forKey: "selectedImageEditHotkeyModifiers") }
        set { defaults.set(newValue, forKey: "selectedImageEditHotkeyModifiers") }
    }

    package static var hasCustomSelectedImageEditHotkey: Bool {
        defaults.object(forKey: "selectedImageEditHotkeyKeyCode") != nil
    }

    package static func clearSelectedImageEditHotkey() {
        defaults.removeObject(forKey: "selectedImageEditHotkeyKeyCode")
        defaults.removeObject(forKey: "selectedImageEditHotkeyModifiers")
    }

    package static var clipboardImageEditHotkeyKeyCode: Int {
        get { defaults.integer(forKey: "clipboardImageEditHotkeyKeyCode") }
        set { defaults.set(newValue, forKey: "clipboardImageEditHotkeyKeyCode") }
    }

    package static var clipboardImageEditHotkeyModifiers: Int {
        get { defaults.integer(forKey: "clipboardImageEditHotkeyModifiers") }
        set { defaults.set(newValue, forKey: "clipboardImageEditHotkeyModifiers") }
    }

    package static var hasCustomClipboardImageEditHotkey: Bool {
        defaults.object(forKey: "clipboardImageEditHotkeyKeyCode") != nil
    }

    package static func clearClipboardImageEditHotkey() {
        defaults.removeObject(forKey: "clipboardImageEditHotkeyKeyCode")
        defaults.removeObject(forKey: "clipboardImageEditHotkeyModifiers")
    }

    // Custom OCR/translation hotkeys. They are global Carbon hotkeys with no
    // defaults: users opt in from Settings, then select a region that is sent
    // straight to the corresponding result panel.

    package static var textRecognitionHotkeyKeyCode: Int {
        get { defaults.integer(forKey: "textRecognitionHotkeyKeyCode") }
        set { defaults.set(newValue, forKey: "textRecognitionHotkeyKeyCode") }
    }

    package static var textRecognitionHotkeyModifiers: Int {
        get { defaults.integer(forKey: "textRecognitionHotkeyModifiers") }
        set { defaults.set(newValue, forKey: "textRecognitionHotkeyModifiers") }
    }

    package static var hasCustomTextRecognitionHotkey: Bool {
        defaults.object(forKey: "textRecognitionHotkeyKeyCode") != nil
    }

    package static func clearTextRecognitionHotkey() {
        defaults.removeObject(forKey: "textRecognitionHotkeyKeyCode")
        defaults.removeObject(forKey: "textRecognitionHotkeyModifiers")
    }

    package static var copyImageTextHotkeyKeyCode: Int {
        get { defaults.integer(forKey: "copyImageTextHotkeyKeyCode") }
        set { defaults.set(newValue, forKey: "copyImageTextHotkeyKeyCode") }
    }

    package static var copyImageTextHotkeyModifiers: Int {
        get { defaults.integer(forKey: "copyImageTextHotkeyModifiers") }
        set { defaults.set(newValue, forKey: "copyImageTextHotkeyModifiers") }
    }

    package static var hasCustomCopyImageTextHotkey: Bool {
        defaults.object(forKey: "copyImageTextHotkeyKeyCode") != nil
    }

    package static func clearCopyImageTextHotkey() {
        defaults.removeObject(forKey: "copyImageTextHotkeyKeyCode")
        defaults.removeObject(forKey: "copyImageTextHotkeyModifiers")
    }

    package static var screenshotTranslationHotkeyKeyCode: Int {
        get { defaults.integer(forKey: "screenshotTranslationHotkeyKeyCode") }
        set { defaults.set(newValue, forKey: "screenshotTranslationHotkeyKeyCode") }
    }

    package static var screenshotTranslationHotkeyModifiers: Int {
        get { defaults.integer(forKey: "screenshotTranslationHotkeyModifiers") }
        set { defaults.set(newValue, forKey: "screenshotTranslationHotkeyModifiers") }
    }

    package static var hasCustomScreenshotTranslationHotkey: Bool {
        defaults.object(forKey: "screenshotTranslationHotkeyKeyCode") != nil
    }

    package static func clearScreenshotTranslationHotkey() {
        defaults.removeObject(forKey: "screenshotTranslationHotkeyKeyCode")
        defaults.removeObject(forKey: "screenshotTranslationHotkeyModifiers")
    }

    package static var recordHotkeyKeyCode: Int {
        get { defaults.integer(forKey: "recordHotkeyKeyCode") }
        set { defaults.set(newValue, forKey: "recordHotkeyKeyCode") }
    }

    package static var recordHotkeyModifiers: Int {
        get { defaults.integer(forKey: "recordHotkeyModifiers") }
        set { defaults.set(newValue, forKey: "recordHotkeyModifiers") }
    }

    package static var hasCustomRecordHotkey: Bool {
        defaults.object(forKey: "recordHotkeyKeyCode") != nil
    }

    package static func clearRecordHotkey() {
        defaults.removeObject(forKey: "recordHotkeyKeyCode")
        defaults.removeObject(forKey: "recordHotkeyModifiers")
    }

    package static var imageMergeHotkeyKeyCode: Int {
        get { defaults.integer(forKey: "imageMergeHotkeyKeyCode") }
        set { defaults.set(newValue, forKey: "imageMergeHotkeyKeyCode") }
    }

    package static var imageMergeHotkeyModifiers: Int {
        get { defaults.integer(forKey: "imageMergeHotkeyModifiers") }
        set { defaults.set(newValue, forKey: "imageMergeHotkeyModifiers") }
    }

    package static var hasCustomImageMergeHotkey: Bool {
        defaults.object(forKey: "imageMergeHotkeyKeyCode") != nil
    }

    package static func clearImageMergeHotkey() {
        defaults.removeObject(forKey: "imageMergeHotkeyKeyCode")
        defaults.removeObject(forKey: "imageMergeHotkeyModifiers")
    }

    // Custom file upload shortcut. This is a global Carbon hotkey with
    // no default so users can choose a combination that fits their workflow.
    package static var finderUploadHotkeyKeyCode: Int {
        get { defaults.integer(forKey: "finderUploadHotkeyKeyCode") }
        set { defaults.set(newValue, forKey: "finderUploadHotkeyKeyCode") }
    }

    package static var finderUploadHotkeyModifiers: Int {
        get { defaults.integer(forKey: "finderUploadHotkeyModifiers") }
        set { defaults.set(newValue, forKey: "finderUploadHotkeyModifiers") }
    }

    package static var hasCustomFinderUploadHotkey: Bool {
        defaults.object(forKey: "finderUploadHotkeyKeyCode") != nil
    }

    package static func clearFinderUploadHotkey() {
        defaults.removeObject(forKey: "finderUploadHotkeyKeyCode")
        defaults.removeObject(forKey: "finderUploadHotkeyModifiers")
    }

    package static var fullScreenScreenshotHotkeyKeyCode: Int {
        get { defaults.integer(forKey: "fullScreenScreenshotHotkeyKeyCode") }
        set { defaults.set(newValue, forKey: "fullScreenScreenshotHotkeyKeyCode") }
    }

    package static var fullScreenScreenshotHotkeyModifiers: Int {
        get { defaults.integer(forKey: "fullScreenScreenshotHotkeyModifiers") }
        set { defaults.set(newValue, forKey: "fullScreenScreenshotHotkeyModifiers") }
    }

    package static var hasCustomFullScreenScreenshotHotkey: Bool {
        defaults.object(forKey: "fullScreenScreenshotHotkeyKeyCode") != nil
    }

    package static func clearFullScreenScreenshotHotkey() {
        defaults.removeObject(forKey: "fullScreenScreenshotHotkeyKeyCode")
        defaults.removeObject(forKey: "fullScreenScreenshotHotkeyModifiers")
    }

    package static var colorPickerHotkeyKeyCode: Int {
        get { defaults.integer(forKey: "colorPickerHotkeyKeyCode") }
        set { defaults.set(newValue, forKey: "colorPickerHotkeyKeyCode") }
    }

    package static var colorPickerHotkeyModifiers: Int {
        get { defaults.integer(forKey: "colorPickerHotkeyModifiers") }
        set { defaults.set(newValue, forKey: "colorPickerHotkeyModifiers") }
    }

    package static var hasCustomColorPickerHotkey: Bool {
        defaults.object(forKey: "colorPickerHotkeyKeyCode") != nil
    }

    package static func clearColorPickerHotkey() {
        defaults.removeObject(forKey: "colorPickerHotkeyKeyCode")
        defaults.removeObject(forKey: "colorPickerHotkeyModifiers")
    }

    package static var imageMergeTemplate: ImageMergeTemplate {
        get {
            let rawValue = defaults.integer(forKey: "imageMergeTemplate")
            return ImageMergeTemplate(rawValue: rawValue) ?? .horizontal
        }
        set {
            defaults.set(newValue.rawValue, forKey: "imageMergeTemplate")
        }
    }

    package static var imageMergeSpacing: Double {
        get {
            if defaults.object(forKey: "imageMergeSpacing") == nil {
                return 12
            }
            return min(max(defaults.double(forKey: "imageMergeSpacing"), 0), 80)
        }
        set {
            defaults.set(min(max(newValue.rounded(), 0), 80), forKey: "imageMergeSpacing")
        }
    }

    package static var imageMergeMargin: Double {
        get {
            if defaults.object(forKey: "imageMergeMargin") == nil {
                return 24
            }
            return min(max(defaults.double(forKey: "imageMergeMargin"), 0), 120)
        }
        set {
            defaults.set(min(max(newValue.rounded(), 0), 120), forKey: "imageMergeMargin")
        }
    }

    package static var imageMergeCornerRadius: Double {
        get {
            if defaults.object(forKey: "imageMergeCornerRadius") == nil {
                return 0
            }
            return min(max(defaults.double(forKey: "imageMergeCornerRadius"), 0), 80)
        }
        set {
            defaults.set(min(max(newValue.rounded(), 0), 80), forKey: "imageMergeCornerRadius")
        }
    }

    package static var imageMergeBackgroundIsSolid: Bool {
        get { defaults.bool(forKey: "imageMergeBackgroundIsSolid") }
        set { defaults.set(newValue, forKey: "imageMergeBackgroundIsSolid") }
    }

    package static var imageMergeBackgroundColorHex: String {
        get {
            normalizedHexColor(defaults.string(forKey: "imageMergeBackgroundColorHex")) ?? "#FFFFFF"
        }
        set {
            defaults.set(normalizedHexColor(newValue) ?? "#FFFFFF", forKey: "imageMergeBackgroundColorHex")
        }
    }

    package static var recordingSaveFormat: ScreenRecordingFormat {
        get {
            guard let raw = defaults.string(forKey: "recordingSaveFormat"),
                  let format = ScreenRecordingFormat(rawValue: raw)
            else {
                return .mp4
            }
            return format
        }
        set {
            defaults.set(newValue.rawValue, forKey: "recordingSaveFormat")
        }
    }

    package static var recordingSavePreference: RecordingSavePreference {
        get {
            guard let raw = defaults.string(forKey: "recordingSavePreference"),
                  let preference = RecordingSavePreference(rawValue: raw)
            else {
                return .manual
            }
            return preference
        }
        set {
            defaults.set(newValue.rawValue, forKey: "recordingSavePreference")
        }
    }

    /// Whether the next recording should capture system audio (what the Mac is
    /// playing). Requires screen-recording permission (already needed for video)
    /// — no separate permission prompt for the user.
    package static var recordingSystemAudioEnabled: Bool {
        get {
            if defaults.object(forKey: "recordingSystemAudioEnabled") == nil {
                return false
            }
            return defaults.bool(forKey: "recordingSystemAudioEnabled")
        }
        set {
            defaults.set(newValue, forKey: "recordingSystemAudioEnabled")
        }
    }

    /// Whether the next recording should capture microphone audio. Requires
    /// microphone permission; permission is requested lazily when the user
    /// first enables this toggle.
    package static var recordingMicrophoneEnabled: Bool {
        get {
            if defaults.object(forKey: "recordingMicrophoneEnabled") == nil {
                return false
            }
            return defaults.bool(forKey: "recordingMicrophoneEnabled")
        }
        set {
            defaults.set(newValue, forKey: "recordingMicrophoneEnabled")
        }
    }

    /// UID of the CoreAudio input device used for microphone recording.
    /// nil means the system default input device. If the persisted device is
    /// unplugged at recording time, the system default is used instead.

    /// When true (default), screenshot "Save to file" shows a save panel.
    /// When false, screenshots write straight to `screenshotSaveDirectory`.
    package static var askSaveLocation: Bool {
        get {
            if defaults.object(forKey: "askSaveLocation") == nil {
                return true
            }
            return defaults.bool(forKey: "askSaveLocation")
        }
        set {
            defaults.set(newValue, forKey: "askSaveLocation")
        }
    }

    package static var autoRevealSavedFiles: Bool {
        get {
            if defaults.object(forKey: "autoRevealSavedFiles") == nil {
                return true
            }
            return defaults.bool(forKey: "autoRevealSavedFiles")
        }
        set {
            defaults.set(newValue, forKey: "autoRevealSavedFiles")
        }
    }

    package static var defaultRecordingSaveDirectory: URL {
        defaultDocumentsDirectory.appendingPathComponent("record", isDirectory: true)
    }

    package static var defaultScreenshotSaveDirectory: URL {
        defaultDocumentsDirectory.appendingPathComponent("screenshots", isDirectory: true)
    }

    package static var recordingSaveDirectory: URL {
        get {
            normalizedDirectoryURL(
                defaults.string(forKey: "recordingSaveDirectory"),
                fallback: defaultRecordingSaveDirectory
            )
        }
        set {
            let normalized = newValue.standardizedFileURL
            let oldValue = recordingSaveDirectory
            defaults.set(normalized.path, forKey: "recordingSaveDirectory")
            if oldValue != normalized {
                NotificationCenter.default.post(name: .recordingSaveDirectoryDidChange, object: nil)
            }
        }
    }

    package static var screenshotSaveDirectory: URL {
        get {
            normalizedDirectoryURL(
                defaults.string(forKey: "screenshotSaveDirectory"),
                fallback: defaultScreenshotSaveDirectory
            )
        }
        set {
            defaults.set(newValue.standardizedFileURL.path, forKey: "screenshotSaveDirectory")
        }
    }

    package static var screenshotUploadQuality: ScreenshotImageQuality {
        get { screenshotQuality(forKey: "screenshotUploadQuality") }
        set { defaults.set(newValue.rawValue, forKey: "screenshotUploadQuality") }
    }

    package static var screenshotSaveQuality: ScreenshotImageQuality {
        get { screenshotQuality(forKey: "screenshotSaveQuality") }
        set { defaults.set(newValue.rawValue, forKey: "screenshotSaveQuality") }
    }

    package static var screenshotClipboardQuality: ScreenshotImageQuality {
        get { screenshotQuality(forKey: "screenshotClipboardQuality") }
        set { defaults.set(newValue.rawValue, forKey: "screenshotClipboardQuality") }
    }

    private static func screenshotQuality(forKey key: String) -> ScreenshotImageQuality {
        guard let raw = defaults.string(forKey: key) else {
            return ScreenshotImageQuality.defaultValue
        }
        if raw == "balanced" || raw == "compact" {
            return .compressed
        }
        return ScreenshotImageQuality(rawValue: raw) ?? ScreenshotImageQuality.defaultValue
    }

    package static let defaultImageFilenameTemplate = "capcap-{date}-{time}"
    package static let defaultRecordingFilenameTemplate = "capcap-rec-{date}-{time}"

    package static var imageFilenameTemplate: String {
        get {
            normalizedFilenameTemplate(
                defaults.string(forKey: "imageFilenameTemplate"),
                fallback: defaultImageFilenameTemplate
            )
        }
        set {
            defaults.set(
                normalizedFilenameTemplate(newValue, fallback: defaultImageFilenameTemplate),
                forKey: "imageFilenameTemplate"
            )
        }
    }

    package static var recordingFilenameTemplate: String {
        get {
            normalizedFilenameTemplate(
                defaults.string(forKey: "recordingFilenameTemplate"),
                fallback: defaultRecordingFilenameTemplate
            )
        }
        set {
            defaults.set(
                normalizedFilenameTemplate(newValue, fallback: defaultRecordingFilenameTemplate),
                forKey: "recordingFilenameTemplate"
            )
        }
    }

    private static func normalizedFilenameTemplate(_ value: String?, fallback: String) -> String {
        let trimmed = (value ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? fallback : trimmed
    }

    private static var defaultDocumentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            ?? URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Documents", isDirectory: true)
    }

    private static func normalizedDirectoryURL(_ value: String?, fallback: URL) -> URL {
        let trimmed = (value ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return fallback.standardizedFileURL }
        let expanded = (trimmed as NSString).expandingTildeInPath
        return URL(fileURLWithPath: expanded, isDirectory: true).standardizedFileURL
    }

    package static func filenameSequenceValue(scope: String, dayStamp: String?, consume: Bool) -> Int {
        if let dayStamp {
            let counterKey = "filenameDailyCounter.\(scope)"
            let dayKey = "filenameDailyCounterDay.\(scope)"
            let currentDay = defaults.string(forKey: dayKey)
            let currentValue = currentDay == dayStamp ? defaults.integer(forKey: counterKey) : 0
            let nextValue = currentValue + 1
            if consume {
                defaults.set(dayStamp, forKey: dayKey)
                defaults.set(nextValue, forKey: counterKey)
            }
            return nextValue
        }

        let key = "filenameCounter.\(scope)"
        let nextValue = defaults.integer(forKey: key) + 1
        if consume {
            defaults.set(nextValue, forKey: key)
        }
        return nextValue
    }

    // Custom copy-to-clipboard hotkey used inside the editor overlay to
    // confirm the screenshot. When absent, the default is "double-tap ⌘",
    // detected via the global flag monitor (KeyMonitor) — see AppDelegate.
    // Unlike the screenshot and pin hotkeys this is matched locally against
    // keyDown events instead of registered as a Carbon global hotkey, so it
    // may be bare (no modifiers). Presence must be checked via
    // `hasCustomClipboardHotkey` since key code 0 (`A`) is a valid value.

    private static func migrateLegacySaveHotkeyIfNeeded() {
        // capcap ≤ 1.x stored this same hotkey under "saveHotkey*". Migrate
        // once on first read so existing users don't lose their binding.
        let migratedKey = "clipboardHotkeyMigrated"
        guard !defaults.bool(forKey: migratedKey) else { return }
        defaults.set(true, forKey: migratedKey)
        guard defaults.object(forKey: "saveHotkeyKeyCode") != nil,
              defaults.object(forKey: "clipboardHotkeyKeyCode") == nil
        else { return }
        defaults.set(defaults.integer(forKey: "saveHotkeyKeyCode"), forKey: "clipboardHotkeyKeyCode")
        defaults.set(defaults.integer(forKey: "saveHotkeyModifiers"), forKey: "clipboardHotkeyModifiers")
        defaults.removeObject(forKey: "saveHotkeyKeyCode")
        defaults.removeObject(forKey: "saveHotkeyModifiers")
    }

    package static var clipboardHotkeyKeyCode: Int {
        get {
            migrateLegacySaveHotkeyIfNeeded()
            return defaults.integer(forKey: "clipboardHotkeyKeyCode")
        }
        set { defaults.set(newValue, forKey: "clipboardHotkeyKeyCode") }
    }

    package static var clipboardHotkeyModifiers: Int {
        get {
            migrateLegacySaveHotkeyIfNeeded()
            return defaults.integer(forKey: "clipboardHotkeyModifiers")
        }
        set { defaults.set(newValue, forKey: "clipboardHotkeyModifiers") }
    }

    package static var hasCustomClipboardHotkey: Bool {
        migrateLegacySaveHotkeyIfNeeded()
        return defaults.object(forKey: "clipboardHotkeyKeyCode") != nil
    }

    package static func clearClipboardHotkey() {
        defaults.removeObject(forKey: "clipboardHotkeyKeyCode")
        defaults.removeObject(forKey: "clipboardHotkeyModifiers")
    }

    // Custom save-to-file hotkey used inside the editor overlay to invoke
    // the configured-directory file save. When absent, defaults to ⌘S.
    // Matched locally against keyDown events, same as the clipboard hotkey.

    package static var fileSaveHotkeyKeyCode: Int {
        get { defaults.integer(forKey: "fileSaveHotkeyKeyCode") }
        set { defaults.set(newValue, forKey: "fileSaveHotkeyKeyCode") }
    }

    package static var fileSaveHotkeyModifiers: Int {
        get { defaults.integer(forKey: "fileSaveHotkeyModifiers") }
        set { defaults.set(newValue, forKey: "fileSaveHotkeyModifiers") }
    }

    package static var hasCustomFileSaveHotkey: Bool {
        defaults.object(forKey: "fileSaveHotkeyKeyCode") != nil
    }

    package static func clearFileSaveHotkey() {
        defaults.removeObject(forKey: "fileSaveHotkeyKeyCode")
        defaults.removeObject(forKey: "fileSaveHotkeyModifiers")
    }

    // History navigation hotkeys used inside the editor overlay. Defaults are
    // comma for previous and period for next. Like clipboard/save editor
    // hotkeys, bare keys are allowed because matching is local to the editor.

    package static var previousHistoryImageHotkeyKeyCode: Int {
        get { defaults.integer(forKey: "previousHistoryImageHotkeyKeyCode") }
        set { defaults.set(newValue, forKey: "previousHistoryImageHotkeyKeyCode") }
    }

    package static var previousHistoryImageHotkeyModifiers: Int {
        get { defaults.integer(forKey: "previousHistoryImageHotkeyModifiers") }
        set { defaults.set(newValue, forKey: "previousHistoryImageHotkeyModifiers") }
    }

    package static var hasCustomPreviousHistoryImageHotkey: Bool {
        defaults.object(forKey: "previousHistoryImageHotkeyKeyCode") != nil
    }

    package static func clearPreviousHistoryImageHotkey() {
        defaults.removeObject(forKey: "previousHistoryImageHotkeyKeyCode")
        defaults.removeObject(forKey: "previousHistoryImageHotkeyModifiers")
    }

    package static var nextHistoryImageHotkeyKeyCode: Int {
        get { defaults.integer(forKey: "nextHistoryImageHotkeyKeyCode") }
        set { defaults.set(newValue, forKey: "nextHistoryImageHotkeyKeyCode") }
    }

    package static var nextHistoryImageHotkeyModifiers: Int {
        get { defaults.integer(forKey: "nextHistoryImageHotkeyModifiers") }
        set { defaults.set(newValue, forKey: "nextHistoryImageHotkeyModifiers") }
    }

    package static var hasCustomNextHistoryImageHotkey: Bool {
        defaults.object(forKey: "nextHistoryImageHotkeyKeyCode") != nil
    }

    package static func clearNextHistoryImageHotkey() {
        defaults.removeObject(forKey: "nextHistoryImageHotkeyKeyCode")
        defaults.removeObject(forKey: "nextHistoryImageHotkeyModifiers")
    }

    // History panel shortcut. Defaults to unset; users can opt in from
    // Settings. The global hotkey opens the dialog mode when enabled, or the
    // notch mode when dialog mode is disabled.

    package static var historyPanelHotkeyKeyCode: Int {
        get { defaults.integer(forKey: "historyPanelHotkeyKeyCode") }
        set { defaults.set(newValue, forKey: "historyPanelHotkeyKeyCode") }
    }

    package static var historyPanelHotkeyModifiers: Int {
        get { defaults.integer(forKey: "historyPanelHotkeyModifiers") }
        set { defaults.set(newValue, forKey: "historyPanelHotkeyModifiers") }
    }

    package static var hasCustomHistoryPanelHotkey: Bool {
        defaults.object(forKey: "historyPanelHotkeyKeyCode") != nil
    }

    package static func clearHistoryPanelHotkey() {
        defaults.removeObject(forKey: "historyPanelHotkeyKeyCode")
        defaults.removeObject(forKey: "historyPanelHotkeyModifiers")
    }

    package static var penColor: Int {
        get {
            let val = defaults.integer(forKey: "penColor")
            return val == 0 ? 0xFF0000 : val
        }
        set {
            defaults.set(newValue, forKey: "penColor")
        }
    }

    package static var penWidth: Double {
        get {
            let val = defaults.double(forKey: "penWidth")
            return val > 0 ? val : 3.0
        }
        set {
            defaults.set(newValue, forKey: "penWidth")
        }
    }

    package static let editorLineWidthMin: Double = 1
    package static let editorLineWidthMax: Double = 16
    package static let markerLineWidthMax: Double = 10
    package static let numberSizeMin: Double = 1
    package static let numberSizeDefault: Double = 5
    package static let numberSizeMax: Double = 25

    package static var lastEditorColorHex: String? {
        get {
            normalizedHexColor(defaults.string(forKey: "lastEditorColorHex"))
        }
        set {
            if let normalized = normalizedHexColor(newValue) {
                defaults.set(normalized, forKey: "lastEditorColorHex")
            } else {
                defaults.removeObject(forKey: "lastEditorColorHex")
            }
        }
    }

    package static var lastEditorLineWidth: Double {
        get {
            if defaults.object(forKey: "lastEditorLineWidth") == nil {
                return 4.0
            }
            return clampedEditorLineWidth(defaults.double(forKey: "lastEditorLineWidth"))
        }
        set {
            defaults.set(clampedEditorLineWidth(newValue), forKey: "lastEditorLineWidth")
        }
    }

    package static var lastNumberSize: Double {
        get {
            guard defaults.object(forKey: "lastNumberSize") != nil else {
                return numberSizeDefault
            }
            return clampedNumberSize(defaults.double(forKey: "lastNumberSize"))
        }
        set {
            defaults.set(clampedNumberSize(newValue), forKey: "lastNumberSize")
        }
    }

    package static var lastMarkerColorHex: String? {
        get {
            normalizedHexColor(defaults.string(forKey: "lastMarkerColorHex"))
        }
        set {
            if let normalized = normalizedHexColor(newValue) {
                defaults.set(normalized, forKey: "lastMarkerColorHex")
            } else {
                defaults.removeObject(forKey: "lastMarkerColorHex")
            }
        }
    }

    package static var lastMarkerLineWidth: Double {
        get {
            if defaults.object(forKey: "lastMarkerLineWidth") == nil {
                return 5.0
            }
            return clampedMarkerLineWidth(defaults.double(forKey: "lastMarkerLineWidth"))
        }
        set {
            defaults.set(clampedMarkerLineWidth(newValue), forKey: "lastMarkerLineWidth")
        }
    }

    package static var mosaicBlockSize: Double {
        get {
            let val = defaults.double(forKey: "mosaicBlockSize")
            guard val > 0 else { return 12.0 }
            return min(max(val, mosaicBlockSizeMin), mosaicBlockSizeMax)
        }
        set {
            defaults.set(min(max(newValue, mosaicBlockSizeMin), mosaicBlockSizeMax), forKey: "mosaicBlockSize")
        }
    }

    package static let mosaicBlockSizeMin: Double = 4
    package static let mosaicBlockSizeMax: Double = 48

    package static var mosaicStyle: MosaicStyle {
        get { MosaicStyle(rawValue: defaults.string(forKey: "mosaicStyle") ?? "") ?? .pixelate }
        set { defaults.set(newValue.rawValue, forKey: "mosaicStyle") }
    }

    package static let mosaicBlurRadiusMin: Double = 1
    package static let mosaicBlurRadiusMax: Double = 48

    package static var mosaicBlurRadius: Double {
        get {
            guard defaults.object(forKey: "mosaicBlurRadius") != nil else { return 12 }
            return normalizedMosaicBlurRadius(defaults.double(forKey: "mosaicBlurRadius"))
        }
        set { defaults.set(normalizedMosaicBlurRadius(newValue), forKey: "mosaicBlurRadius") }
    }

    package static func normalizedMosaicBlurRadius(_ value: Double) -> Double {
        value.isFinite ? min(max(value, mosaicBlurRadiusMin), mosaicBlurRadiusMax) : 12
    }

    package static let textFontSizeMin: Double = 10
    package static let textFontSizeMax: Double = 100

    package static var lastTextFontSize: Double {
        get {
            if defaults.object(forKey: "lastTextFontSize") == nil {
                return 20
            }
            let val = defaults.double(forKey: "lastTextFontSize")
            return min(max(val, textFontSizeMin), textFontSizeMax)
        }
        set {
            defaults.set(min(max(newValue, textFontSizeMin), textFontSizeMax), forKey: "lastTextFontSize")
        }
    }

    /// Last font family selected in the editor's font picker, reused for new text annotations
    /// Normalized at the persistence boundary: a family that is no longer
    /// installed reads back as nil, i.e. the system bold default.
    package static var textFontName: String? {
        get {
            guard let name = defaults.string(forKey: "textFontName"), !name.isEmpty else {
                return nil
            }
            return FontCatalog.isInstalled(name) ? name : nil
        }
        set {
            if let newValue, !newValue.isEmpty {
                defaults.set(newValue, forKey: "textFontName")
            } else {
                defaults.removeObject(forKey: "textFontName")
            }
        }
    }

    /// Whether the text tool's outline checkbox was last left on.
    package static var lastTextStroke: Bool {
        get { defaults.bool(forKey: "lastTextStroke") }
        set { defaults.set(newValue, forKey: "lastTextStroke") }
    }

    /// Whether the text tool's callout checkbox was last left on.
    package static var lastTextCallout: Bool {
        get { defaults.bool(forKey: "lastTextCallout") }
        set { defaults.set(newValue, forKey: "lastTextCallout") }
    }

    /// Last rectangle/ellipse fill mode. Migrates the previous checkbox
    /// preference by treating its "on" state as the old opaque fill.
    package static var lastShapeFillMode: ShapeFillMode {
        get {
            guard let raw = defaults.string(forKey: "lastShapeFillMode"),
                  let mode = ShapeFillMode(rawValue: raw) else {
                return defaults.bool(forKey: "lastShapeFill") ? .opaque : .none
            }
            return mode
        }
        set {
            defaults.set(newValue.rawValue, forKey: "lastShapeFillMode")
            defaults.set(newValue.isFilled, forKey: "lastShapeFill")
        }
    }

    package static var lastShapeStrokeStyle: ShapeStrokeStyle {
        get {
            guard let raw = defaults.string(forKey: "lastShapeStrokeStyle"),
                  let style = ShapeStrokeStyle(rawValue: raw) else {
                return .standard
            }
            return style
        }
        set {
            defaults.set(newValue.rawValue, forKey: "lastShapeStrokeStyle")
        }
    }

    /// Whether the rectangle/ellipse tool's legacy fill checkbox was last left on.
    package static var lastShapeFill: Bool {
        get { lastShapeFillMode.isFilled }
        set { lastShapeFillMode = newValue ? .opaque : .none }
    }

    package static var lastArrowStyle: ArrowStyle {
        get {
            guard let raw = defaults.string(forKey: "lastArrowStyle"),
                  let style = ArrowStyle(rawValue: raw) else {
                return .tapered
            }
            return style
        }
        set {
            defaults.set(newValue.rawValue, forKey: "lastArrowStyle")
        }
    }

    package static var lastPickedColorHex: String? {
        get {
            guard historyCacheEnabled else { return nil }
            return normalizedHexColor(defaults.string(forKey: "lastPickedColorHex"))
        }
        set {
            if let normalized = normalizedHexColor(newValue) {
                defaults.set(normalized, forKey: "lastPickedColorHex")
            } else {
                defaults.removeObject(forKey: "lastPickedColorHex")
            }
        }
    }

    package static var recentEmojis: [String] {
        get {
            normalizedEmojiList(defaults.stringArray(forKey: "recentEmojis") ?? [])
        }
        set {
            let normalized = normalizedEmojiList(newValue)
            if normalized.isEmpty {
                defaults.removeObject(forKey: "recentEmojis")
            } else {
                defaults.set(normalized, forKey: "recentEmojis")
            }
        }
    }

    private static func normalizedEmojiList(_ values: [String]) -> [String] {
        var result: [String] = []
        for value in values {
            let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty, !result.contains(trimmed) else { continue }
            result.append(trimmed)
            if result.count == 10 { break }
        }
        return result
    }

    private static func normalizedHexColor(_ hex: String?) -> String? {
        guard var trimmed = hex?.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() else {
            return nil
        }
        if trimmed.hasPrefix("#") { trimmed.removeFirst() }
        guard trimmed.count == 6, UInt32(trimmed, radix: 16) != nil else { return nil }
        return "#\(trimmed)"
    }

    private static func clampedEditorLineWidth(_ width: Double) -> Double {
        min(max(width, editorLineWidthMin), editorLineWidthMax)
    }

    private static func clampedNumberSize(_ size: Double) -> Double {
        min(max(size, numberSizeMin), numberSizeMax)
    }

    private static func clampedMarkerLineWidth(_ width: Double) -> Double {
        min(max(width, editorLineWidthMin), markerLineWidthMax)
    }

    private static func clampedUnitInterval(_ value: Double) -> Double {
        min(1, max(0, value))
    }

    private static func normalizedMagnifierLensPanelMagnifiedSize(_ value: Int) -> Int {
        switch value {
        case 96, 144, 192:
            return value
        default:
            return 144
        }
    }

    private static func normalizedMagnifierLensPanelMagnification(_ value: Double) -> Double {
        guard value.isFinite else { return 4.0 }
        return min(16.0, max(1.0, value))
    }

    package static var lastBeautifyPresetID: String? {
        get { defaults.string(forKey: "lastBeautifyPresetID") }
        set { defaults.set(newValue, forKey: "lastBeautifyPresetID") }
    }

    package static var beautifyToolbarPresetIDs: [String] {
        get {
            normalizedUniqueStringList(
                defaults.stringArray(forKey: "beautifyToolbarPresetIDs") ?? [],
                limit: 8
            )
        }
        set {
            let normalized = normalizedUniqueStringList(newValue, limit: 8)
            if normalized.isEmpty {
                defaults.removeObject(forKey: "beautifyToolbarPresetIDs")
            } else {
                defaults.set(normalized, forKey: "beautifyToolbarPresetIDs")
            }
        }
    }

    package static var lastBeautifyShadowSize: Double {
        get {
            // Preserve the old slider position once, without sharing any state
            // with the window-capture projection preferences.
            if defaults.object(forKey: "lastBeautifyShadowSize") == nil {
                let legacy = defaults.object(forKey: "lastBeautifyPadding") as? NSNumber
                let size = BeautifyRenderer.normalizedShadowSize(
                    CGFloat(legacy?.doubleValue ?? Double(BeautifyRenderer.shadowSizeDefault))
                )
                defaults.set(Double(size), forKey: "lastBeautifyShadowSize")
            }
            return Double(BeautifyRenderer.normalizedShadowSize(
                CGFloat(defaults.double(forKey: "lastBeautifyShadowSize"))
            ))
        }
        set {
            defaults.set(
                Double(BeautifyRenderer.normalizedShadowSize(CGFloat(newValue))),
                forKey: "lastBeautifyShadowSize"
            )
        }
    }

    private static func normalizedUniqueStringList(_ values: [String], limit: Int) -> [String] {
        var result: [String] = []
        for value in values {
            let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty, !result.contains(trimmed) else { continue }
            result.append(trimmed)
            if result.count == limit { break }
        }
        return result
    }

    /// The user's last explicit beautify toggle, independent of temporary editor state
    package static var lastBeautifyEnabled: Bool {
        get {
            if defaults.object(forKey: "lastBeautifyEnabled") == nil {
                defaults.set(defaults.bool(forKey: "beautifyAutoEnabled"), forKey: "lastBeautifyEnabled")
                defaults.removeObject(forKey: "beautifyAutoEnabled")
            }
            return defaults.bool(forKey: "lastBeautifyEnabled")
        }
        set {
            defaults.set(newValue, forKey: "lastBeautifyEnabled")
            defaults.removeObject(forKey: "beautifyAutoEnabled")
        }
    }

    package static let historyCacheMin: Int = 10
    package static let historyCacheMax: Int = 200
    package static let historyCacheStep: Int = 10
    package static let clipboardTextHistoryLimitMin: Int = 50
    package static let clipboardTextHistoryLimitMax: Int = 500
    package static let clipboardTextHistoryLimitStep: Int = 50

    package static var historyCacheEnabled: Bool {
        get {
            if defaults.object(forKey: "historyCacheEnabled") == nil {
                return true
            }
            return defaults.bool(forKey: "historyCacheEnabled")
        }
        set {
            let oldValue = historyCacheEnabled
            defaults.set(newValue, forKey: "historyCacheEnabled")
            if !newValue {
                lastPickedColorHex = nil
            }
            if oldValue != newValue {
                NotificationCenter.default.post(name: .historyCacheEnabledDidChange, object: nil)
            }
        }
    }

    /// Background color used in dark mode (when `magnifierLensPanelFollowSystemAppearance` is on).
    /// Stored as 0–1 RGBA components. Default: black with 80% alpha.
    package static var magnifierLensPanelDarkBackgroundRed: Double {
        get { defaults.object(forKey: "magnifierLensPanelDarkBackgroundRed") == nil ? 0 : defaults.double(forKey: "magnifierLensPanelDarkBackgroundRed") }
        set { defaults.set(clampedUnitInterval(newValue), forKey: "magnifierLensPanelDarkBackgroundRed") }
    }
    package static var magnifierLensPanelDarkBackgroundGreen: Double {
        get { defaults.object(forKey: "magnifierLensPanelDarkBackgroundGreen") == nil ? 0 : defaults.double(forKey: "magnifierLensPanelDarkBackgroundGreen") }
        set { defaults.set(clampedUnitInterval(newValue), forKey: "magnifierLensPanelDarkBackgroundGreen") }
    }
    package static var magnifierLensPanelDarkBackgroundBlue: Double {
        get { defaults.object(forKey: "magnifierLensPanelDarkBackgroundBlue") == nil ? 0 : defaults.double(forKey: "magnifierLensPanelDarkBackgroundBlue") }
        set { defaults.set(clampedUnitInterval(newValue), forKey: "magnifierLensPanelDarkBackgroundBlue") }
    }
    package static var magnifierLensPanelDarkBackgroundAlpha: Double {
        get { defaults.object(forKey: "magnifierLensPanelDarkBackgroundAlpha") == nil ? 0.80 : defaults.double(forKey: "magnifierLensPanelDarkBackgroundAlpha") }
        set { defaults.set(clampedUnitInterval(newValue), forKey: "magnifierLensPanelDarkBackgroundAlpha") }
    }

    /// Background color used in light mode (when `magnifierLensPanelFollowSystemAppearance` is on).
    /// Stored as 0–1 RGBA components. Default: white with 80% alpha.
    package static var magnifierLensPanelLightBackgroundRed: Double {
        get { defaults.object(forKey: "magnifierLensPanelLightBackgroundRed") == nil ? 1 : defaults.double(forKey: "magnifierLensPanelLightBackgroundRed") }
        set { defaults.set(clampedUnitInterval(newValue), forKey: "magnifierLensPanelLightBackgroundRed") }
    }
    package static var magnifierLensPanelLightBackgroundGreen: Double {
        get { defaults.object(forKey: "magnifierLensPanelLightBackgroundGreen") == nil ? 1 : defaults.double(forKey: "magnifierLensPanelLightBackgroundGreen") }
        set { defaults.set(clampedUnitInterval(newValue), forKey: "magnifierLensPanelLightBackgroundGreen") }
    }
    package static var magnifierLensPanelLightBackgroundBlue: Double {
        get { defaults.object(forKey: "magnifierLensPanelLightBackgroundBlue") == nil ? 1 : defaults.double(forKey: "magnifierLensPanelLightBackgroundBlue") }
        set { defaults.set(clampedUnitInterval(newValue), forKey: "magnifierLensPanelLightBackgroundBlue") }
    }
    package static var magnifierLensPanelLightBackgroundAlpha: Double {
        get { defaults.object(forKey: "magnifierLensPanelLightBackgroundAlpha") == nil ? 0.80 : defaults.double(forKey: "magnifierLensPanelLightBackgroundAlpha") }
        set { defaults.set(clampedUnitInterval(newValue), forKey: "magnifierLensPanelLightBackgroundAlpha") }
    }

    /// When `true`, the lens picks the dark/light background color based on the
    /// current macOS appearance. When `false`, the dark color is always used.
    package static var magnifierLensPanelFollowSystemAppearance: Bool {
        get {
            if defaults.object(forKey: "magnifierLensPanelFollowSystemAppearance") == nil {
                return true
            }
            return defaults.bool(forKey: "magnifierLensPanelFollowSystemAppearance")
        }
        set {
            defaults.set(newValue, forKey: "magnifierLensPanelFollowSystemAppearance")
        }
    }

    /// Side length (in points) of the magnified area. One of 96, 144, 192.
    package static var magnifierLensPanelMagnifiedSize: Int {
        get {
            if defaults.object(forKey: "magnifierLensPanelMagnifiedSize") == nil {
                return 144
            }
            return normalizedMagnifierLensPanelMagnifiedSize(defaults.integer(forKey: "magnifierLensPanelMagnifiedSize"))
        }
        set {
            defaults.set(normalizedMagnifierLensPanelMagnifiedSize(newValue), forKey: "magnifierLensPanelMagnifiedSize")
        }
    }

    /// Magnification factor for the lens. Controls how many source pixels are
    /// sampled: source region = magnified display size / magnification.
    /// Higher values = tighter zoom (smaller source region). Default 4×,
    /// clamped to 1×...16× for hidden UserDefaults overrides.
    package static var magnifierLensPanelMagnification: Double {
        get {
            if defaults.object(forKey: "magnifierLensPanelMagnification") == nil {
                return 4.0
            }
            return normalizedMagnifierLensPanelMagnification(
                defaults.double(forKey: "magnifierLensPanelMagnification")
            )
        }
        set {
            defaults.set(
                normalizedMagnifierLensPanelMagnification(newValue),
                forKey: "magnifierLensPanelMagnification"
            )
        }
    }

    /// Horizontal offset (in points) between the cursor and the panel's left edge.
    package static var magnifierLensPanelOffsetX: Double {
        get {
            if defaults.object(forKey: "magnifierLensPanelOffsetX") == nil {
                return 15
            }
            return defaults.double(forKey: "magnifierLensPanelOffsetX")
        }
        set {
            defaults.set(newValue, forKey: "magnifierLensPanelOffsetX")
        }
    }

    /// Vertical offset (in points) between the cursor and the panel's top edge
    /// when the panel sits below the cursor.
    package static var magnifierLensPanelOffsetY: Double {
        get {
            if defaults.object(forKey: "magnifierLensPanelOffsetY") == nil {
                return 15
            }
            return defaults.double(forKey: "magnifierLensPanelOffsetY")
        }
        set {
            defaults.set(newValue, forKey: "magnifierLensPanelOffsetY")
        }
    }

    /// Whether to show the "Press ⌘+C to copy color" hint row in the lens.
    package static var magnifierLensPanelShowCopyHint: Bool {
        get {
            if defaults.object(forKey: "magnifierLensPanelShowCopyHint") == nil {
                return true
            }
            return defaults.bool(forKey: "magnifierLensPanelShowCopyHint")
        }
        set {
            defaults.set(newValue, forKey: "magnifierLensPanelShowCopyHint")
        }
    }

    /// Whether to show the "Press F to switch color format" hint row in the lens.
    /// The stored key keeps its original name for preference compatibility.
    package static var magnifierLensPanelShowFormatHint: Bool {
        get {
            if defaults.object(forKey: "magnifierLensPanelShowShiftHint") == nil {
                return true
            }
            return defaults.bool(forKey: "magnifierLensPanelShowShiftHint")
        }
        set {
            defaults.set(newValue, forKey: "magnifierLensPanelShowShiftHint")
        }
    }

    /// Coordinate mode for the lens display: `.points` shows AppKit
    /// screen-point coordinates (default); `.pixels` shows physical
    /// CGImage pixel coordinates matching the snapshot resolution.
    package enum MagnifierLensPanelCoordinateMode: String {
        case points
        case pixels
    }
    package static var magnifierLensPanelCoordinateMode: MagnifierLensPanelCoordinateMode {
        get {
            guard let raw = defaults.string(forKey: "magnifierLensPanelCoordinateMode"),
                  let mode = MagnifierLensPanelCoordinateMode(rawValue: raw) else {
                return .pixels
            }
            return mode
        }
        set {
            defaults.set(newValue.rawValue, forKey: "magnifierLensPanelCoordinateMode")
        }
    }

    /// Crosshair colour — RGBA components stored as 0–1 doubles.
    /// Default: #A8BDFC at 65% alpha.
    package static var magnifierLensPanelCrosshairRed: Double {
        get { defaults.object(forKey: "magnifierLensPanelCrosshairRed") == nil ? 0xA8 / 255.0 : defaults.double(forKey: "magnifierLensPanelCrosshairRed") }
        set { defaults.set(clampedUnitInterval(newValue), forKey: "magnifierLensPanelCrosshairRed") }
    }
    package static var magnifierLensPanelCrosshairGreen: Double {
        get { defaults.object(forKey: "magnifierLensPanelCrosshairGreen") == nil ? 0xBD / 255.0 : defaults.double(forKey: "magnifierLensPanelCrosshairGreen") }
        set { defaults.set(clampedUnitInterval(newValue), forKey: "magnifierLensPanelCrosshairGreen") }
    }
    package static var magnifierLensPanelCrosshairBlue: Double {
        get { defaults.object(forKey: "magnifierLensPanelCrosshairBlue") == nil ? 0xFC / 255.0 : defaults.double(forKey: "magnifierLensPanelCrosshairBlue") }
        set { defaults.set(clampedUnitInterval(newValue), forKey: "magnifierLensPanelCrosshairBlue") }
    }
    package static var magnifierLensPanelCrosshairAlpha: Double {
        get { defaults.object(forKey: "magnifierLensPanelCrosshairAlpha") == nil ? 0.65 : defaults.double(forKey: "magnifierLensPanelCrosshairAlpha") }
        set { defaults.set(clampedUnitInterval(newValue), forKey: "magnifierLensPanelCrosshairAlpha") }
    }

    /// Crosshair line width in points. Default 6, clamped to 1–30.
    package static var magnifierLensPanelCrosshairWidth: Double {
        get {
            if defaults.object(forKey: "magnifierLensPanelCrosshairWidth") == nil { return 6 }
            return defaults.double(forKey: "magnifierLensPanelCrosshairWidth")
        }
        set { defaults.set(min(30, max(1, newValue)), forKey: "magnifierLensPanelCrosshairWidth") }
    }

    package static var clipboardTextCacheEnabled: Bool {
        get {
            if defaults.object(forKey: "clipboardTextCacheEnabled") == nil {
                return false
            }
            return defaults.bool(forKey: "clipboardTextCacheEnabled")
        }
        set {
            let oldValue = clipboardTextCacheEnabled
            defaults.set(newValue, forKey: "clipboardTextCacheEnabled")
            if oldValue != newValue {
                NotificationCenter.default.post(name: .clipboardTextCacheEnabledDidChange, object: nil)
            }
        }
    }

    package static var clipboardTextHistoryLimit: Int {
        get {
            if defaults.object(forKey: "clipboardTextHistoryLimit") == nil {
                return 100
            }
            let value = defaults.integer(forKey: "clipboardTextHistoryLimit")
            return normalizedClipboardTextHistoryLimit(value)
        }
        set {
            defaults.set(
                normalizedClipboardTextHistoryLimit(newValue),
                forKey: "clipboardTextHistoryLimit"
            )
            NotificationCenter.default.post(name: .clipboardTextHistoryLimitDidChange, object: nil)
        }
    }

    package static var isHistoryCacheAvailable: Bool {
        historyCacheEnabled || clipboardTextCacheEnabled || HistoryManager.shared.hasFavoriteEntries()
    }

    package static let countdownSecondsMin: Int = 3
    package static let countdownSecondsMax: Int = 10

    package static var countdownSeconds: Int {
        get {
            if defaults.object(forKey: "countdownSeconds") == nil {
                return countdownSecondsMin
            }
            let val = defaults.integer(forKey: "countdownSeconds")
            return min(max(val, countdownSecondsMin), countdownSecondsMax)
        }
        set {
            let clamped = min(max(newValue, countdownSecondsMin), countdownSecondsMax)
            defaults.set(clamped, forKey: "countdownSeconds")
        }
    }

    package static var historyCacheLimit: Int {
        get {
            if defaults.object(forKey: "historyCacheLimit") == nil {
                return 10
            }
            let val = defaults.integer(forKey: "historyCacheLimit")
            return normalizedHistoryCacheLimit(val)
        }
        set {
            defaults.set(normalizedHistoryCacheLimit(newValue), forKey: "historyCacheLimit")
            NotificationCenter.default.post(name: .historyCacheLimitDidChange, object: nil)
        }
    }

    private static func normalizedHistoryCacheLimit(_ value: Int) -> Int {
        let clamped = min(max(value, historyCacheMin), historyCacheMax)
        let offset = clamped - historyCacheMin
        let snapped = historyCacheMin + ((offset + historyCacheStep / 2) / historyCacheStep) * historyCacheStep
        return min(max(snapped, historyCacheMin), historyCacheMax)
    }

    private static func normalizedClipboardTextHistoryLimit(_ value: Int) -> Int {
        let clamped = min(max(value, clipboardTextHistoryLimitMin), clipboardTextHistoryLimitMax)
        let offset = clamped - clipboardTextHistoryLimitMin
        let snapped = clipboardTextHistoryLimitMin
            + ((offset + clipboardTextHistoryLimitStep / 2) / clipboardTextHistoryLimitStep)
            * clipboardTextHistoryLimitStep
        return min(max(snapped, clipboardTextHistoryLimitMin), clipboardTextHistoryLimitMax)
    }

    package enum HistoryNotchTriggerMode: String, CaseIterable {
        case hover
        case click

        package var localizedTitle: String {
            switch self {
            case .hover: return L10n.historyNotchTriggerHover
            case .click: return L10n.historyNotchTriggerClick
            }
        }
    }

    package static var historyNotchTriggerMode: HistoryNotchTriggerMode {
        get {
            HistoryNotchTriggerMode(rawValue: defaults.string(forKey: "historyNotchTriggerMode") ?? "") ?? .hover
        }
        set { defaults.set(newValue.rawValue, forKey: "historyNotchTriggerMode") }
    }

    package static var historyPanelDialogEnabled: Bool {
        get {
            historyPanelDisplayMode == .dialog
        }
        set {
            if newValue {
                setHistoryPanelDisplayMode(.dialog)
            }
        }
    }

    package static var historyPanelNotchEnabled: Bool {
        get {
            historyPanelDisplayMode == .notch
        }
        set {
            if newValue {
                setHistoryPanelDisplayMode(historyPanelNotchAvailable ? .notch : .dialog)
            }
        }
    }

    package static var historyPanelNotchAvailable: Bool {
        DisplayCapabilities.supportsHistoryPanelNotch
    }

    private enum HistoryPanelDisplayMode {
        case dialog
        case notch
    }

    private static var historyPanelDisplayMode: HistoryPanelDisplayMode {
        let hasDialog = defaults.object(forKey: "historyPanelDialogEnabled") != nil
        let hasNotch = defaults.object(forKey: "historyPanelNotchEnabled") != nil
        guard hasDialog || hasNotch else {
            return historyPanelNotchAvailable ? .notch : .dialog
        }

        let dialog = hasDialog ? defaults.bool(forKey: "historyPanelDialogEnabled") : false
        let notch = hasNotch ? defaults.bool(forKey: "historyPanelNotchEnabled") : false
        if dialog { return .dialog }
        if notch, historyPanelNotchAvailable { return .notch }
        return .dialog
    }

    private static func setHistoryPanelDisplayMode(_ mode: HistoryPanelDisplayMode) {
        let mode = mode == .notch && !historyPanelNotchAvailable ? .dialog : mode
        let oldMode = historyPanelDisplayMode
        defaults.set(mode == .dialog, forKey: "historyPanelDialogEnabled")
        defaults.set(mode == .notch, forKey: "historyPanelNotchEnabled")
        if oldMode != mode {
            NotificationCenter.default.post(name: .historyPanelDisplayModesDidChange, object: nil)
        }
    }

    package static var showMenuBar: Bool {
        get {
            if defaults.object(forKey: "showMenuBar") == nil {
                return true
            }
            return defaults.bool(forKey: "showMenuBar")
        }
        set {
            defaults.set(newValue, forKey: "showMenuBar")
        }
    }

    package static var pinAcrossSpaces: Bool {
        get { defaults.bool(forKey: "pinAcrossSpaces") }
        set { defaults.set(newValue, forKey: "pinAcrossSpaces") }
    }

    // Window-capture drop shadow. When enabled, single-window screenshots get
    // rounded corners and a macOS-style drop shadow in the final output.
    // Rounded corners are always applied to window captures; this toggle only
    // governs the shadow.

    package static let windowShadowSizeMin: Double = 6
    package static let windowShadowSizeMax: Double = 60

    package static var windowShadowEnabled: Bool {
        get {
            if defaults.object(forKey: "windowShadowEnabled") == nil {
                return true
            }
            return defaults.bool(forKey: "windowShadowEnabled")
        }
        set {
            defaults.set(newValue, forKey: "windowShadowEnabled")
        }
    }

    package static var windowShadowSize: Double {
        get {
            if defaults.object(forKey: "windowShadowSize") == nil {
                return 22
            }
            let val = defaults.double(forKey: "windowShadowSize")
            return min(max(val, windowShadowSizeMin), windowShadowSizeMax)
        }
        set {
            defaults.set(min(max(newValue, windowShadowSizeMin), windowShadowSizeMax), forKey: "windowShadowSize")
        }
    }


}
