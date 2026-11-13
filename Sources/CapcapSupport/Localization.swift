import Foundation
/// A language the app's UI can be displayed in. Raw values double as the
/// `appLanguage` UserDefaults value (kept stable for backward compatibility).
package enum AppLanguage: String, CaseIterable {
    case zh
    case zhTW = "zh-Hant"
    case en
    case ja
    case ko
    case fr
    case ru
    case vi

    /// Folder name (without extension) of the matching `.lproj` bundle inside
    /// `capcap.app/Contents/Resources/`.
    package var lprojName: String {
        switch self {
        case .zh: return "zh-Hans"
        case .zhTW: return "zh-Hant"
        default:  return rawValue
        }
    }

    /// Native language name shown in the in-app language picker.
    package var displayName: String {
        switch self {
        case .zh: return "简体中文"
        case .zhTW: return "繁體中文"
        case .en: return "English"
        case .ja: return "日本語"
        case .ko: return "한국어"
        case .fr: return "Français"
        case .ru: return "Русский"
        case .vi: return "Tiếng Việt"
        }
    }

    /// Best-effort match of the system's preferred languages to a supported
    /// app language — used on first launch before the user picks explicitly.
    package static var systemDefault: AppLanguage {
        for code in Locale.preferredLanguages {
            let lower = code.lowercased()
            if lower.hasPrefix("zh-hant") ||
                lower.hasPrefix("zh-tw") ||
                lower.hasPrefix("zh-hk") ||
                lower.hasPrefix("zh-mo") {
                return .zhTW
            }
            if lower.hasPrefix("zh") { return .zh }
            if lower.hasPrefix("ja") { return .ja }
            if lower.hasPrefix("ko") { return .ko }
            if lower.hasPrefix("fr") { return .fr }
            if lower.hasPrefix("ru") { return .ru }
            if lower.hasPrefix("vi") { return .vi }
            if lower.hasPrefix("en") { return .en }
        }
        return .en
    }
}

extension Notification.Name {
    package static let languageDidChange = Notification.Name("capcap.languageDidChange")
    package static let historyCacheEnabledDidChange = Notification.Name("capcap.historyCacheEnabledDidChange")
    package static let clipboardTextCacheEnabledDidChange = Notification.Name("capcap.clipboardTextCacheEnabledDidChange")
    package static let historyCacheLimitDidChange = Notification.Name("capcap.historyCacheLimitDidChange")
    package static let clipboardTextHistoryLimitDidChange = Notification.Name("capcap.clipboardTextHistoryLimitDidChange")
    package static let historyDidUpdate = Notification.Name("capcap.historyDidUpdate")
    package static let recordingSaveDirectoryDidChange = Notification.Name("capcap.recordingSaveDirectoryDidChange")
    package static let historyPanelDisplayModesDidChange = Notification.Name("capcap.historyPanelDisplayModesDidChange")
    package static let hotkeyDidChange = Notification.Name("capcap.hotkeyDidChange")
    package static let editorShortcutsDidChange = Notification.Name("capcap.editorShortcutsDidChange")
    package static let translationConfigDidChange = Notification.Name("capcap.translationConfigDidChange")
}

/// Centralized accessor for every user-facing string. Each property resolves a
/// key from the current language's `Localizable.strings`; the translations
/// themselves live in `Resources/<lang>.lproj/Localizable.strings`.
package enum L10n {
    package static var lang: AppLanguage { Defaults.language }

    private static func s(_ key: String) -> String { Localizer.string(key) }

    // Settings
    package static var settingsTitle: String { s("settingsTitle") }
    package static var showMenuBarIcon: String { s("showMenuBarIcon") }
    package static var permissionsHeader: String { s("permissionsHeader") }
    package static var accessibilityPermission: String { s("accessibilityPermission") }
    package static var accessibilityDescription: String { s("accessibilityDescription") }
    package static var screenRecordingPermission: String { s("screenRecordingPermission") }
    package static var screenRecordingDescription: String { s("screenRecordingDescription") }
    package static var launchApp: String { s("launchApp") }
    package static var launchAtLogin: String { s("launchAtLogin") }
    package static var pinAcrossSpaces: String { s("pinAcrossSpaces") }
    package static var pinAcrossSpacesHint: String { s("pinAcrossSpacesHint") }
    package static var historyCacheToggleLabel: String { s("historyCacheToggleLabel") }
    package static var historyCacheToggleHint: String { s("historyCacheToggleHint") }
    package static var clipboardTextCacheToggleLabel: String { s("clipboardTextCacheToggleLabel") }
    package static var clipboardTextCacheToggleHint: String { s("clipboardTextCacheToggleHint") }
    package static var clipboardTextHistoryLimitLabel: String { s("clipboardTextHistoryLimitLabel") }
    package static var historyCacheLabel: String { s("historyCacheLabel") }
    package static var historyPanelDisplayModeLabel: String { s("historyPanelDisplayModeLabel") }
    package static var historyPanelDisplayModeHint: String { s("historyPanelDisplayModeHint") }
    package static var historyPanelDialogMode: String { s("historyPanelDialogMode") }
    package static var historyPanelDialogModeHint: String { s("historyPanelDialogModeHint") }
    package static var historyPanelNotchMode: String { s("historyPanelNotchMode") }
    package static var historyPanelNotchModeHint: String { s("historyPanelNotchModeHint") }
    package static var historyNotchTriggerLabel: String { s("historyNotchTriggerLabel") }
    package static var historyNotchTriggerHover: String { s("historyNotchTriggerHover") }
    package static var historyNotchTriggerClick: String { s("historyNotchTriggerClick") }
    package static var countdownLabel: String { s("countdownLabel") }
    package static var countdownHint: String { s("countdownHint") }
    package static var countdownSecondsSuffix: String { s("countdownSecondsSuffix") }
    package static var windowShadowToggleLabel: String { s("windowShadowToggleLabel") }
    package static var windowShadowToggleHint: String { s("windowShadowToggleHint") }
    package static var shadowSizeLabel: String { s("shadowSizeLabel") }
    package static var windowShadowSizeHint: String { s("windowShadowSizeHint") }
    package static var savePathTitle: String { s("savePathTitle") }
    package static var savePathSubtitle: String { s("savePathSubtitle") }
    package static var askSaveLocationLabel: String { s("askSaveLocationLabel") }
    package static var askSaveLocationHint: String { s("askSaveLocationHint") }
    package static var autoRevealSavedFilesLabel: String { s("autoRevealSavedFilesLabel") }
    package static var autoRevealSavedFilesHint: String { s("autoRevealSavedFilesHint") }
    package static var recordingSavePathLabel: String { s("recordingSavePathLabel") }
    package static var recordingSaveFormatSettingLabel: String { s("recordingSaveFormatSettingLabel") }
    package static var screenshotSavePathLabel: String { s("screenshotSavePathLabel") }
    package static var savePathChoose: String { s("savePathChoose") }
    package static var savePathReveal: String { s("savePathReveal") }
    package static var chooseRecordingSavePathTitle: String { s("chooseRecordingSavePathTitle") }
    package static var chooseScreenshotSavePathTitle: String { s("chooseScreenshotSavePathTitle") }
    package static var screenshotQualityTitle: String { s("screenshotQualityTitle") }
    package static var screenshotQualitySubtitle: String { s("screenshotQualitySubtitle") }
    package static var screenshotQualityUploadLabel: String { s("screenshotQualityUploadLabel") }
    package static var screenshotQualitySaveLabel: String { s("screenshotQualitySaveLabel") }
    package static var screenshotQualityClipboardLabel: String { s("screenshotQualityClipboardLabel") }
    package static var screenshotQualityOriginal: String { s("screenshotQualityOriginal") }
    package static var screenshotQualityOriginalHint: String { s("screenshotQualityOriginalHint") }
    package static var screenshotQualityCompressed: String { s("screenshotQualityCompressed") }
    package static var screenshotQualityCompressedHint: String { s("screenshotQualityCompressedHint") }
    package static var screenshotQualityCompressingUpload: String { s("screenshotQualityCompressingUpload") }
    package static var screenshotQualityCompressingSave: String { s("screenshotQualityCompressingSave") }
    package static var screenshotQualityCompressingClipboard: String { s("screenshotQualityCompressingClipboard") }
    package static var screenshotCompressionFailed: String { s("screenshotCompressionFailed") }

    // Screenshot shortcut
    package static var shortcutHeader: String { s("shortcutHeader") }
    package static var shortcutHint: String { s("shortcutHint") }
    package static var shortcutDefaultDisplay: String { s("shortcutDefaultDisplay") }
    package static var shortcutSet: String { s("shortcutSet") }
    package static var shortcutCancel: String { s("shortcutCancel") }
    package static var shortcutWaiting: String { s("shortcutWaiting") }
    package static var shortcutNeedsModifierTitle: String { s("shortcutNeedsModifierTitle") }
    package static var shortcutNeedsModifier: String { s("shortcutNeedsModifier") }
    package static var shortcutRestore: String { s("shortcutRestore") }

    // Pin-image shortcut
    package static var quickPinShortcutHeader: String { s("quickPinShortcutHeader") }
    package static var quickPinShortcutDefaultDisplay: String { s("quickPinShortcutDefaultDisplay") }
    package static var quickPinShortcutClear: String { s("quickPinShortcutClear") }
    package static var selectedImagePinShortcutHeader: String { s("selectedImagePinShortcutHeader") }
    package static var selectedImagePinShortcutDefaultDisplay: String { s("selectedImagePinShortcutDefaultDisplay") }
    package static var selectedImagePinShortcutClear: String { s("selectedImagePinShortcutClear") }
    package static var clipboardImagePinShortcutHeader: String { s("clipboardImagePinShortcutHeader") }
    package static var clipboardImagePinShortcutDefaultDisplay: String { s("clipboardImagePinShortcutDefaultDisplay") }
    package static var clipboardImagePinShortcutClear: String { s("clipboardImagePinShortcutClear") }
    package static var clipboardTextPinShortcutHeader: String { s("clipboardTextPinShortcutHeader") }
    package static var clipboardTextPinShortcutDefaultDisplay: String { s("clipboardTextPinShortcutDefaultDisplay") }
    package static var clipboardTextPinShortcutClear: String { s("clipboardTextPinShortcutClear") }
    package static var selectedImagePinNoImage: String { s("selectedImagePinNoImage") }
    package static var clipboardImagePinNoImage: String { s("clipboardImagePinNoImage") }
    package static var clipboardTextPinNoText: String { s("clipboardTextPinNoText") }
    package static var pinFromFinderHint: String { s("pinFromFinderHint") }
    package static var pinFromClipboardHint: String { s("pinFromClipboardHint") }
    package static var pinFromClipboardTextHint: String { s("pinFromClipboardTextHint") }
    package static var pinToolbarClose: String { s("pinToolbarClose") }
    package static var pinToolbarCopy: String { s("pinToolbarCopy") }
    package static var pinToolbarDrag: String { s("pinToolbarDrag") }
    package static var pinToolbarEdit: String { s("pinToolbarEdit") }
    package static var pinToolbarEditText: String { s("pinToolbarEditText") }

    // Image-edit shortcuts
    package static var selectedImageEditShortcutHeader: String { s("selectedImageEditShortcutHeader") }
    package static var selectedImageEditShortcutHint: String { s("selectedImageEditShortcutHint") }
    package static var selectedImageEditShortcutDefaultDisplay: String { s("selectedImageEditShortcutDefaultDisplay") }
    package static var clipboardImageEditShortcutHeader: String { s("clipboardImageEditShortcutHeader") }
    package static var clipboardImageEditShortcutHint: String { s("clipboardImageEditShortcutHint") }
    package static var clipboardImageEditShortcutDefaultDisplay: String { s("clipboardImageEditShortcutDefaultDisplay") }
    package static var textRecognitionShortcutHeader: String { s("textRecognitionShortcutHeader") }
    package static var textRecognitionShortcutDefaultDisplay: String { s("textRecognitionShortcutDefaultDisplay") }
    package static var copyImageTextShortcutHeader: String { s("copyImageTextShortcutHeader") }
    package static var copyImageTextShortcutDefaultDisplay: String { s("copyImageTextShortcutDefaultDisplay") }
    package static var screenshotTranslationShortcutHeader: String { s("screenshotTranslationShortcutHeader") }
    package static var screenshotTranslationShortcutDefaultDisplay: String { s("screenshotTranslationShortcutDefaultDisplay") }
    package static var recordShortcutHeader: String { s("recordShortcutHeader") }
    package static var recordShortcutDefaultDisplay: String { s("recordShortcutDefaultDisplay") }
    package static var imageMergeShortcutHeader: String { s("imageMergeShortcutHeader") }
    package static var imageMergeShortcutDefaultDisplay: String { s("imageMergeShortcutDefaultDisplay") }
    package static var fileUploadShortcutHeader: String { s("fileUploadShortcutHeader") }
    package static var finderUploadShortcutDefaultDisplay: String { s("finderUploadShortcutDefaultDisplay") }
    package static var fullScreenScreenshotShortcutHeader: String { s("fullScreenScreenshotShortcutHeader") }
    package static var fullScreenScreenshotShortcutDefaultDisplay: String { s("fullScreenScreenshotShortcutDefaultDisplay") }
    package static var colorPickerShortcutHeader: String { s("colorPickerShortcutHeader") }
    package static var colorPickerShortcutDefaultDisplay: String { s("colorPickerShortcutDefaultDisplay") }

    // Magnifier lens panel (overlay magnifier lens panel)
    package static var magnifierLensPanelCoordinatesLabel: String { s("magnifierLensPanelCoordinatesLabel") }
    package static var magnifierLensPanelColorValueLabel: String { s("magnifierLensPanelColorValueLabel") }
    package static var magnifierLensPanelCoordinates: String { s("magnifierLensPanelCoordinates") }
    package static var magnifierLensPanelHex: String { s("magnifierLensPanelHex") }
    package static var magnifierLensPanelRgb: String { s("magnifierLensPanelRgb") }
    package static var magnifierLensPanelCopyHint: String { s("magnifierLensPanelCopyHint") }
    package static var magnifierLensPanelFormatHint: String { s("magnifierLensPanelFormatHint") }
    package static var magnifierLensPanelAspectFree: String { s("magnifierLensPanelAspectFree") }
    package static var magnifierLensPanelAspectHint: String { s("magnifierLensPanelAspectHint") }
    package static func magnifierLensPanelRgbString(r: Int, g: Int, b: Int) -> String {
        String(format: s("magnifierLensPanelRgbString"), r, g, b)
    }

    // Copy-to-clipboard shortcut (editor confirm)
    package static var clipboardShortcutHeader: String { s("clipboardShortcutHeader") }
    package static var clipboardShortcutHint: String { s("clipboardShortcutHint") }
    package static var clipboardShortcutDefaultDisplay: String { s("clipboardShortcutDefaultDisplay") }

    // History navigation shortcuts (editor)
    package static var previousHistoryImageShortcutHeader: String { s("previousHistoryImageShortcutHeader") }
    package static var nextHistoryImageShortcutHeader: String { s("nextHistoryImageShortcutHeader") }
    package static var historyPanelShortcutHeader: String { s("historyPanelShortcutHeader") }
    package static var historyPanelShortcutDefaultDisplay: String { s("historyPanelShortcutDefaultDisplay") }

    // Save-to-file shortcut (editor save)
    package static var fileSaveShortcutHeader: String { s("fileSaveShortcutHeader") }
    package static var fileSaveShortcutHint: String { s("fileSaveShortcutHint") }

    // Shortcut conflict
    package static var shortcutConflictTitle: String { s("shortcutConflictTitle") }
    package static var shortcutConflictScreenshot: String { s("shortcutConflictScreenshot") }
    package static var shortcutConflictCountdown: String { s("shortcutConflictCountdown") }
    package static var shortcutConflictQuickPin: String { s("shortcutConflictQuickPin") }
    package static var shortcutConflictSelectedImagePin: String { s("shortcutConflictSelectedImagePin") }
    package static var shortcutConflictClipboardImagePin: String { s("shortcutConflictClipboardImagePin") }
    package static var shortcutConflictClipboardTextPin: String { s("shortcutConflictClipboardTextPin") }
    package static var shortcutConflictClipboard: String { s("shortcutConflictClipboard") }
    package static var shortcutConflictFileSave: String { s("shortcutConflictFileSave") }
    package static var shortcutConflictPreviousHistoryImage: String { s("shortcutConflictPreviousHistoryImage") }
    package static var shortcutConflictNextHistoryImage: String { s("shortcutConflictNextHistoryImage") }
    package static var shortcutConflictHistoryPanel: String { s("shortcutConflictHistoryPanel") }
    package static var shortcutConflictSelectedImageEdit: String { s("shortcutConflictSelectedImageEdit") }
    package static var shortcutConflictClipboardImageEdit: String { s("shortcutConflictClipboardImageEdit") }
    package static var shortcutConflictTextRecognition: String { s("shortcutConflictTextRecognition") }
    package static var shortcutConflictCopyImageText: String { s("shortcutConflictCopyImageText") }
    package static var shortcutConflictScreenshotTranslation: String { s("shortcutConflictScreenshotTranslation") }
    package static var shortcutConflictRecord: String { s("shortcutConflictRecord") }
    package static var shortcutConflictImageMerge: String { s("shortcutConflictImageMerge") }
    package static var shortcutConflictFileUpload: String { s("shortcutConflictFileUpload") }
    package static var shortcutConflictFullScreenScreenshot: String { s("shortcutConflictFullScreenScreenshot") }
    package static var shortcutConflictColorPicker: String { s("shortcutConflictColorPicker") }

    // Menu bar
    package static var takeScreenshot: String { s("takeScreenshot") }
    package static var takeFullScreenScreenshot: String { s("takeFullScreenScreenshot") }
    package static var record: String { s("record") }
    package static var mergeImages: String { s("mergeImages") }
    package static var uploadFilesMenu: String { s("uploadFilesMenu") }
    package static var colorPicker: String { s("colorPicker") }
    package static var settings: String { s("settings") }
    package static var quitApp: String { s("quitApp") }
    package static var historyMenu: String { s("historyMenu") }
    package static var historyClear: String { s("historyClear") }
    package static var historyCleared: String { s("historyCleared") }
    package static var historyShowInFinder: String { s("historyShowInFinder") }
    package static var historyPanelLock: String { s("historyPanelLock") }
    package static var historyPanelUnlock: String { s("historyPanelUnlock") }
    package static var historyPanelMenu: String { s("historyPanelMenu") }
    package static var historyPanelDeleteAll: String { s("historyPanelDeleteAll") }
    package static func historyPanelDeleteSelected(_ count: Int) -> String {
        let key = count == 1 ? "historyPanelDeleteSelectedOne" : "historyPanelDeleteSelected"
        return String(format: s(key), count)
    }
    package static func historyPanelDeletedSelected(_ count: Int) -> String {
        let key = count == 1 ? "historyPanelDeletedSelectedOne" : "historyPanelDeletedSelected"
        return String(format: s(key), count)
    }
    package static var historyPanelFavorite: String { s("historyPanelFavorite") }
    package static var historyPanelUnfavorite: String { s("historyPanelUnfavorite") }
    package static var historyPanelItemFavorited: String { s("historyPanelItemFavorited") }
    package static var historyPanelItemUnfavorited: String { s("historyPanelItemUnfavorited") }
    package static var historyPanelFavoriteFailed: String { s("historyPanelFavoriteFailed") }
    package static func historyDeletedSkippingFavorites(removed: Int, skipped: Int) -> String {
        String(format: s("historyDeletedSkippingFavorites"), removed, skipped)
    }
    package static var historyPanelFilterAll: String { s("historyPanelFilterAll") }
    package static var historyPanelFilterScreenshots: String { s("historyPanelFilterScreenshots") }
    package static var historyPanelFilterGIF: String { s("historyPanelFilterGIF") }
    package static var historyPanelFilterMP4: String { s("historyPanelFilterMP4") }
    package static var historyPanelFilterColors: String { s("historyPanelFilterColors") }
    package static var historyPanelFilterText: String { s("historyPanelFilterText") }
    package static var historyPanelFilterFiles: String { s("historyPanelFilterFiles") }
    package static var historyPanelFolder: String { s("historyPanelFolder") }
    package static var historyPanelSearchFiles: String { s("historyPanelSearchFiles") }
    package static var historyPanelSourceUnavailable: String { s("historyPanelSourceUnavailable") }
    package static var historyPanelSourceUnavailableHint: String { s("historyPanelSourceUnavailableHint") }
    package static var historyFilePreviewPrevious: String { s("historyFilePreviewPrevious") }
    package static var historyFilePreviewNext: String { s("historyFilePreviewNext") }
    package static var historyFilePreviewLoading: String { s("historyFilePreviewLoading") }
    package static var historyFilePreviewRetry: String { s("historyFilePreviewRetry") }
    package static var historyFilePreviewUnavailable: String { s("historyFilePreviewUnavailable") }
    package static var historyPanelSearchColorsAndText: String { s("historyPanelSearchColorsAndText") }
    package static var historyPanelSearchColors: String { s("historyPanelSearchColors") }
    package static var historyPanelSearchText: String { s("historyPanelSearchText") }
    package static var historyPanelClearSearch: String { s("historyPanelClearSearch") }
    package static var historyPanelSearchNoResults: String { s("historyPanelSearchNoResults") }
    package static var historyPreviewTextSaveFailed: String { s("historyPreviewTextSaveFailed") }
    package static var historyPreviewCopyText: String { s("historyPreviewCopyText") }
    package static var historyPreviewTranslateText: String { s("historyPreviewTranslateText") }
    package static var historyPreviewConvertToQRCode: String { s("historyPreviewConvertToQRCode") }
    package static var historyPreviewQRCodeTooLong: String { s("historyPreviewQRCodeTooLong") }
    package static var historyPreviewOriginalText: String { s("historyPreviewOriginalText") }
    package static var historyPreviewQRCodeTitle: String { s("historyPreviewQRCodeTitle") }
    package static var historyPanelCopyHint: String { s("historyPanelCopyHint") }
    package static var historyPanelCopyDragHint: String { s("historyPanelCopyDragHint") }
    package static var historyPanelCopyMarkdownLink: String { s("historyPanelCopyMarkdownLink") }
    package static var historyPanelCopyPlainLink: String { s("historyPanelCopyPlainLink") }
    package static var historyPanelEmpty: String { s("historyPanelEmpty") }
    package static var historyPanelShortcutGuide: String { s("historyPanelShortcutGuide") }
    package static var historyPanelShortcutGuideHide: String { s("historyPanelShortcutGuideHide") }
    package static var historyPanelShortcutKeyClick: String { s("historyPanelShortcutKeyClick") }
    package static var historyPanelShortcutKeyDrag: String { s("historyPanelShortcutKeyDrag") }
    package static var historyPanelShortcutKeySpace: String { s("historyPanelShortcutKeySpace") }
    package static var historyPanelShortcutSearch: String { s("historyPanelShortcutSearch") }
    package static var historyPanelShortcutSwitchFilter: String { s("historyPanelShortcutSwitchFilter") }
    package static var historyPanelShortcutSwitchItem: String { s("historyPanelShortcutSwitchItem") }
    package static var historyPanelShortcutToggleSelection: String { s("historyPanelShortcutToggleSelection") }
    package static var historyPanelShortcutRangeSelection: String { s("historyPanelShortcutRangeSelection") }
    package static var historyPanelShortcutSelectAll: String { s("historyPanelShortcutSelectAll") }
    package static var historyPanelShortcutCancel: String { s("historyPanelShortcutCancel") }
    package static var historyPanelShortcutCopyItem: String { s("historyPanelShortcutCopyItem") }
    package static var historyPanelShortcutDragItem: String { s("historyPanelShortcutDragItem") }
    package static var historyPanelShortcutOpenPreview: String { s("historyPanelShortcutOpenPreview") }
    package static var historyPanelShortcutBrowsePreview: String { s("historyPanelShortcutBrowsePreview") }
    package static var historyPanelShortcutClosePreview: String { s("historyPanelShortcutClosePreview") }
    package static var historyPanelShortcutCopyPreview: String { s("historyPanelShortcutCopyPreview") }
    package static var historyPanelShortcutEditImage: String { s("historyPanelShortcutEditImage") }
    package static var historyPanelShortcutPinImage: String { s("historyPanelShortcutPinImage") }
    package static var historyPanelShortcutUploadImage: String { s("historyPanelShortcutUploadImage") }
    package static var historyPanelShortcutTranslateText: String { s("historyPanelShortcutTranslateText") }
    package static var historyPanelShortcutQRCode: String { s("historyPanelShortcutQRCode") }
    package static var historyPanelShortcutToggleGuide: String { s("historyPanelShortcutToggleGuide") }

    // Cursor chip
    package static var dragToScreenshot: String { s("dragToScreenshot") }
    package static var dragToQuickPin: String { s("dragToQuickPin") }
    package static var dragToScreenshotAspectFree: String { s("dragToScreenshotAspectFree") }
    package static func dragToScreenshotAspect(_ ratio: String) -> String {
        String(format: s("dragToScreenshotAspect"), ratio)
    }
    package static var dragToTextRecognition: String { s("dragToTextRecognition") }
    package static var dragToCopyImageText: String { s("dragToCopyImageText") }
    package static var dragToScreenshotTranslation: String { s("dragToScreenshotTranslation") }
    package static var dragToRecord: String { s("dragToRecord") }
    package static var dragToRecordAspectFree: String { s("dragToRecordAspectFree") }
    package static func dragToRecordAspect(_ ratio: String) -> String {
        String(format: s("dragToRecordAspect"), ratio)
    }

    // Toast
    package static var copiedToClipboard: String { s("copiedToClipboard") }
    package static var mergedLongScreenshot: String { s("mergedLongScreenshot") }
    package static var autoScrollPermissionNeeded: String { s("autoScrollPermissionNeeded") }
    package static var cropLongScreenshotHint: String { s("cropLongScreenshotHint") }
    package static var scrollCaptureHint: String { s("scrollCaptureHint") }
    package static var scrollCaptureManualHint: String { s("scrollCaptureManualHint") }
    package static var finderEditExitHint: String { s("finderEditExitHint") }
    package static var clipboardEditExitHint: String { s("clipboardEditExitHint") }
    package static var pinEditExitHint: String { s("pinEditExitHint") }
    package static var fullScreenEditExitHint: String { s("fullScreenEditExitHint") }
    package static var editSuspendedToast: String { s("editSuspendedToast") }
    package static var editSuspendedResumeToast: String { s("editSuspendedResumeToast") }
    package static var fullScreenScreenshotFailed: String { s("fullScreenScreenshotFailed") }
    package static var openImageNoImage: String { s("openImageNoImage") }
    package static var selectedImageEditNoImage: String { s("selectedImageEditNoImage") }
    package static var clipboardImageEditNoImage: String { s("clipboardImageEditNoImage") }
    package static var mergeEditExitHint: String { s("mergeEditExitHint") }
    package static var imageMergeNeedTwoImages: String { s("imageMergeNeedTwoImages") }
    package static var imageMergeSomeImagesSkipped: String { s("imageMergeSomeImagesSkipped") }
    package static var imageMergeNoClipboardImage: String { s("imageMergeNoClipboardImage") }
    package static var imageMergeFailed: String { s("imageMergeFailed") }
    package static var imageMergeSaved: String { s("imageMergeSaved") }
    package static func recordingSaved(to path: String) -> String {
        String(format: s("recordingSaved"), path)
    }
    package static var recordingCancelled: String { s("recordingCancelled") }
    package static var recordingExportingGIF: String { s("recordingExportingGIF") }
    package static var saveRecording: String { s("saveRecording") }
    package static var saveRecordingPrompt: String { s("saveRecordingPrompt") }
    package static var recordingFormatLabel: String { s("recordingFormatLabel") }
    package static var recordingFormatManual: String { s("recordingFormatManual") }
    package static var recordingFormatMP4: String { s("recordingFormatMP4") }
    package static var recordingFormatGIF: String { s("recordingFormatGIF") }
    package static var recordingFormatChoiceTitle: String { s("recordingFormatChoiceTitle") }
    package static var recordingFormatChoiceMessage: String { s("recordingFormatChoiceMessage") }

    // Recording audio
    package static var recordingSystemAudioLabel: String { s("recordingSystemAudioLabel") }
    package static var recordingSystemAudioHint: String { s("recordingSystemAudioHint") }
    package static var recordingMicrophoneLabel: String { s("recordingMicrophoneLabel") }
    package static var recordingMicrophoneHint: String { s("recordingMicrophoneHint") }
    package static var recordingMicrophoneDeniedTitle: String { s("recordingMicrophoneDeniedTitle") }
    package static var recordingMicrophoneDeniedMessage: String { s("recordingMicrophoneDeniedMessage") }
    package static var recordingMicrophoneOpenSettings: String { s("recordingMicrophoneOpenSettings") }
    package static var recordingMicrophoneTooltipOn: String { s("recordingMicrophoneTooltipOn") }
    package static var recordingMicrophoneTooltipOff: String { s("recordingMicrophoneTooltipOff") }
    package static var recordingSystemAudioTooltipOn: String { s("recordingSystemAudioTooltipOn") }
    package static var recordingSystemAudioTooltipOff: String { s("recordingSystemAudioTooltipOff") }
    package static var recordingMicrophoneDeviceLabel: String { s("recordingMicrophoneDeviceLabel") }
    package static var recordingMicrophoneDeviceDefault: String { s("recordingMicrophoneDeviceDefault") }
    package static var recordingMicrophoneDeviceMenuHint: String { s("recordingMicrophoneDeviceMenuHint") }
    package static var recordingSystemAudioChangeFailed: String { s("recordingSystemAudioChangeFailed") }
    package static var recordingMicrophoneStartFailed: String { s("recordingMicrophoneStartFailed") }

    // Microphone permission row
    package static var microphonePermission: String { s("microphonePermission") }
    package static var microphoneDescription: String { s("microphoneDescription") }
    package static func screenshotSaved(to path: String) -> String {
        String(format: s("screenshotSaved"), path)
    }
    package static var recordingStop: String { s("recordingStop") }
    package static var recordingPause: String { s("recordingPause") }
    package static var recordingResume: String { s("recordingResume") }
    package static func recordingFailed(_ message: String) -> String {
        String(format: s("recordingFailed"), message)
    }
    package static func screenshotSaveFailed(_ message: String) -> String {
        String(format: s("screenshotSaveFailed"), message)
    }
    package static func colorCopied(_ hex: String) -> String {
        String(format: s("colorCopied"), hex)
    }
    package static var qrCodeCopied: String { s("qrCodeCopied") }
    package static var qrCodeNotFound: String { s("qrCodeNotFound") }

    // Toolbar tooltips
    package static var tipRectangle: String { s("tipRectangle") }
    package static var tipEllipse: String { s("tipEllipse") }
    package static var tipArrow: String { s("tipArrow") }
    package static var tipLine: String { s("tipLine") }
    package static var tipPen: String { s("tipPen") }
    package static var tipMarker: String { s("tipMarker") }
    package static var tipSpotlight: String { s("tipSpotlight") }
    package static var tipMosaic: String { s("tipMosaic") }
    package static var mosaicGranularity: String { s("mosaicGranularity") }
    package static var mosaicBlur: String { s("mosaicBlur") }
    package static var mosaicBlurAmount: String { s("mosaicBlurAmount") }
    package static var tipEraser: String { s("tipEraser") }
    package static var tipMagnifier: String { s("tipMagnifier") }
    package static var tipNumbered: String { s("tipNumbered") }
    package static var tipText: String { s("tipText") }
    package static var tipQRCode: String { s("tipQRCode") }
    package static var tipEmoji: String { s("tipEmoji") }
    package static var tipMoreEmoji: String { s("tipMoreEmoji") }
    package static var tipMoreBeautifyPresets: String { s("tipMoreBeautifyPresets") }
    package static var tipInsertImage: String { s("tipInsertImage") }
    package static var tipColorPicker: String { s("tipColorPicker") }
    package static var tipPickedInkBottle: String { s("tipPickedInkBottle") }
    package static var tipUndo: String { s("tipUndo") }
    package static var tipRedo: String { s("tipRedo") }
    package static var tipMoveSelection: String { s("tipMoveSelection") }
    package static var tipScrollCapture: String { s("tipScrollCapture") }
    package static var tipBeautify: String { s("tipBeautify") }
    package static var tipRotate: String { s("tipRotate") }
    package static var tipRotateLeft: String { s("tipRotateLeft") }
    package static var tipRotateRight: String { s("tipRotateRight") }
    package static var tipOCR: String { s("tipOCR") }
    package static var tipScreenshotTranslate: String { s("tipScreenshotTranslate") }
    package static var tipSave: String { s("tipSave") }
    package static var tipPin: String { s("tipPin") }
    package static var tipRecord: String { s("tipRecord") }
    package static var windowCapturePreparing: String { s("windowCapturePreparing") }
    package static var tipCancel: String { s("tipCancel") }
    package static var tipConfirm: String { s("tipConfirm") }
    package static var tipScrollCropConfirm: String { s("tipScrollCropConfirm") }
    package static var copyQRCodeContent: String { s("copyQRCodeContent") }

    // Beautify
    package static var beautify: String { s("beautify") }
    package static var beautifyPresetTransparent: String { s("beautifyPresetTransparent") }
    package static var beautifyPresetPeachBlue: String { s("beautifyPresetPeachBlue") }
    package static var beautifyPresetMintTeal: String { s("beautifyPresetMintTeal") }
    package static var beautifyPresetPeachPink: String { s("beautifyPresetPeachPink") }
    package static var beautifyPresetBluePurple: String { s("beautifyPresetBluePurple") }
    package static var beautifyPresetWarmOrange: String { s("beautifyPresetWarmOrange") }
    package static var beautifyPresetTealPink: String { s("beautifyPresetTealPink") }
    package static var beautifyPresetDeepPurple: String { s("beautifyPresetDeepPurple") }
    package static var beautifyPresetNeutralGray: String { s("beautifyPresetNeutralGray") }
    package static var beautifyPresetWallpaper: String { s("beautifyPresetWallpaper") }
    package static var beautifyPresetAurora: String { s("beautifyPresetAurora") }
    package static var beautifyPresetSunsetGlow: String { s("beautifyPresetSunsetGlow") }
    package static var beautifyPresetOceanBlue: String { s("beautifyPresetOceanBlue") }
    package static var beautifyPresetLavenderMist: String { s("beautifyPresetLavenderMist") }
    package static var beautifyPresetForestMint: String { s("beautifyPresetForestMint") }
    package static var beautifyPresetRoseGold: String { s("beautifyPresetRoseGold") }
    package static var beautifyPresetMorningSky: String { s("beautifyPresetMorningSky") }
    package static var beautifyPresetCandyPop: String { s("beautifyPresetCandyPop") }
    package static var beautifyPresetCitrusGlow: String { s("beautifyPresetCitrusGlow") }
    package static var beautifyPresetMidnight: String { s("beautifyPresetMidnight") }
    package static var beautifyPresetCoralBloom: String { s("beautifyPresetCoralBloom") }
    package static var beautifyPresetArcticIce: String { s("beautifyPresetArcticIce") }
    package static var beautifyPresetSageCream: String { s("beautifyPresetSageCream") }
    package static var beautifyPresetGraphite: String { s("beautifyPresetGraphite") }
    package static var beautifyShadowSizeHint: String { s("beautifyShadowSizeHint") }

    // Text tool
    package static var textStrokeEffect: String { s("textStrokeEffect") }
    package static var textCalloutEffect: String { s("textCalloutEffect") }
    package static var textFontLabel: String { s("textFontLabel") }
    package static var textFontSystemDefault: String { s("textFontSystemDefault") }

    // Shape tool
    package static var shapeFillEffect: String { s("shapeFillEffect") }
    package static var shapeFillNone: String { s("shapeFillNone") }
    package static var shapeFillOpaque: String { s("shapeFillOpaque") }
    package static var shapeFillTranslucent: String { s("shapeFillTranslucent") }
    package static var shapeStyleStandard: String { s("shapeStyleStandard") }
    package static var shapeStyleRounded: String { s("shapeStyleRounded") }
    package static var shapeStyleHandDrawn: String { s("shapeStyleHandDrawn") }
    package static var arrowStyleTapered: String { s("arrowStyleTapered") }
    package static var arrowStyleDoubleEnded: String { s("arrowStyleDoubleEnded") }
    package static var arrowStyleLine: String { s("arrowStyleLine") }
    package static var arrowStyleDotTail: String { s("arrowStyleDotTail") }

    // Insert tools
    package static var insertImageFromClipboard: String { s("insertImageFromClipboard") }
    package static var insertImageFromFile: String { s("insertImageFromFile") }
    package static var insertImageChooseFile: String { s("insertImageChooseFile") }
    package static var insertImageNoClipboardImage: String { s("insertImageNoClipboardImage") }
    package static var scrollCaptureAutoScroll: String { s("scrollCaptureAutoScroll") }
    package static var scrollCaptureManualScroll: String { s("scrollCaptureManualScroll") }

    // Language
    package static var languageHeader: String { s("languageHeader") }

    // Settings sidebar tabs
    package static var settingsTabGeneral: String { s("settingsTabGeneral") }
    package static var settingsGeneralBasic: String { s("settingsGeneralBasic") }
    package static var settingsGeneralCapture: String { s("settingsGeneralCapture") }
    package static var settingsGeneralRecording: String { s("settingsGeneralRecording") }
    package static var settingsGeneralHistory: String { s("settingsGeneralHistory") }
    package static var settingsGeneralFiles: String { s("settingsGeneralFiles") }
    package static var settingsTabShortcuts: String { s("settingsTabShortcuts") }
    package static var settingsTabPermissions: String { s("settingsTabPermissions") }
    package static var settingsTabUpload: String { s("settingsTabUpload") }
    package static var settingsTabAbout: String { s("settingsTabAbout") }
    package static var settingsTabTranslation: String { s("settingsTabTranslation") }
    package static var settingsTabToolbar: String { s("settingsTabToolbar") }
    package static var settingsQuit: String { s("settingsQuit") }

    // Toolbar settings
    package static var toolbarSettingsPrimaryTitle: String { s("toolbarSettingsPrimaryTitle") }
    package static var toolbarSettingsPrimaryHint: String { s("toolbarSettingsPrimaryHint") }
    package static var toolbarSettingsSideTitle: String { s("toolbarSettingsSideTitle") }
    package static var toolbarSettingsSideHint: String { s("toolbarSettingsSideHint") }
    package static var toolbarSettingsHiddenTitle: String { s("toolbarSettingsHiddenTitle") }
    package static var toolbarSettingsHiddenHint: String { s("toolbarSettingsHiddenHint") }
    package static var toolbarSettingsFootnote: String { s("toolbarSettingsFootnote") }
    package static var toolbarSettingsShortcutHint: String { s("toolbarSettingsShortcutHint") }
    package static func toolbarSettingsShortcutRecording(_ action: String) -> String {
        String(format: s("toolbarSettingsShortcutRecording"), action)
    }
    package static var toolbarSettingsShortcutRecord: String { s("toolbarSettingsShortcutRecord") }
    package static var toolbarSettingsShortcutClear: String { s("toolbarSettingsShortcutClear") }
    package static var toolbarSettingsShortcutRestore: String { s("toolbarSettingsShortcutRestore") }
    package static var toolbarSettingsShortcutResetAll: String { s("toolbarSettingsShortcutResetAll") }
    package static var toolbarSettingsShortcutNone: String { s("toolbarSettingsShortcutNone") }
    package static var toolbarSettingsShortcutUnavailable: String { s("toolbarSettingsShortcutUnavailable") }
    package static var toolbarSettingsAdditionalShortcuts: String { s("toolbarSettingsAdditionalShortcuts") }
    package static var toolbarSettingsReset: String { s("toolbarSettingsReset") }
    package static var toolbarSettingsCancel: String { s("toolbarSettingsCancel") }
    package static var toolbarSettingsApply: String { s("toolbarSettingsApply") }
    package static var editorShortcutSelect: String { s("editorShortcutSelect") }
    package static var editorShortcutShapeFill: String { s("editorShortcutShapeFill") }
    package static func editorShortcutConflict(_ action: String) -> String {
        String(format: s("editorShortcutConflict"), action)
    }
    package static var editorShortcutReserved: String { s("editorShortcutReserved") }

    // About pane
    package static var aboutTagline: String { s("aboutTagline") }
    package static var aboutLicense: String { s("aboutLicense") }
    package static var aboutSourceCode: String { s("aboutSourceCode") }
    package static var aboutStarOnGitHub: String { s("aboutStarOnGitHub") }
    package static var aboutFeatureRequest: String { s("aboutFeatureRequest") }
    package static var aboutBugReport: String { s("aboutBugReport") }
    package static var aboutUpdateTitle: String { s("aboutUpdateTitle") }

    // Error log — About pane
    package static var aboutErrorLog: String { s("aboutErrorLog") }
    package static var aboutErrorLogNoCrash: String { s("aboutErrorLogNoCrash") }
    package static func aboutErrorLogLastCrash(_ date: String) -> String {
        String(format: s("aboutErrorLogLastCrash"), date)
    }
    package static var aboutErrorLogCopy: String { s("aboutErrorLogCopy") }
    package static var aboutErrorLogCopied: String { s("aboutErrorLogCopied") }
    package static var aboutErrorLogReveal: String { s("aboutErrorLogReveal") }
    package static var aboutErrorLogRefresh: String { s("aboutErrorLogRefresh") }
    package static var aboutErrorLogClear: String { s("aboutErrorLogClear") }
    package static var aboutErrorLogEmptyBody: String { s("aboutErrorLogEmptyBody") }

    // Updates — About pane
    package static var checkForUpdates: String { s("checkForUpdates") }
    package static var updateChecking: String { s("updateChecking") }
    package static var updateUpToDateStatus: String { s("updateUpToDateStatus") }
    package static func updateNewVersionStatus(_ v: String) -> String {
        String(format: s("updateNewVersionStatus"), v)
    }
    package static var updateFailedStatus: String { s("updateFailedStatus") }
    package static var updateDownloadButton: String { s("updateDownloadButton") }
    package static var updateRetryButton: String { s("updateRetryButton") }
    package static var updateInstallNowButton: String { s("updateInstallNowButton") }
    package static func updateDownloadingStatus(_ percent: Int) -> String {
        String(format: s("updateDownloadingStatus"), percent)
    }
    package static var updateInstallingStatus: String { s("updateInstallingStatus") }
    package static var updateInstallFailedStatus: String { s("updateInstallFailedStatus") }

    // Updates — menu bar
    package static var checkForUpdatesMenu: String { s("checkForUpdatesMenu") }
    package static var checkingForUpdatesMenu: String { s("checkingForUpdatesMenu") }
    package static func updateAvailableMenu(_ v: String) -> String {
        String(format: s("updateAvailableMenu"), v)
    }
    package static func updateDownloadingMenu(_ percent: Int) -> String {
        String(format: s("updateDownloadingMenu"), percent)
    }
    package static var updateInstallingMenu: String { s("updateInstallingMenu") }
    package static var updateInstallFailedMenu: String { s("updateInstallFailedMenu") }

    // Updates — progress HUD
    package static var updateCheckingHUD: String { s("updateCheckingHUD") }
    package static func updateDownloadingHUD(_ percent: Int) -> String {
        String(format: s("updateDownloadingHUD"), percent)
    }
    package static var updateVerifyingHUD: String { s("updateVerifyingHUD") }
    package static var updateUnzippingHUD: String { s("updateUnzippingHUD") }
    package static var updateInstallingHUD: String { s("updateInstallingHUD") }

    // Updates — manual check result alert
    package static func updateAvailableTitle(_ v: String) -> String {
        String(format: s("updateAvailableTitle"), v)
    }
    package static var updateAvailableBody: String { s("updateAvailableBody") }
    package static var updateUpToDateTitle: String { s("updateUpToDateTitle") }
    package static func updateUpToDateBody(_ v: String) -> String {
        String(format: s("updateUpToDateBody"), v)
    }
    package static var updateFailedTitle: String { s("updateFailedTitle") }
    package static var updateFailedBody: String { s("updateFailedBody") }
    package static var updateInstallFailedTitle: String { s("updateInstallFailedTitle") }
    package static var updateInstallFailedBody: String { s("updateInstallFailedBody") }
    package static var updateOpenPageButton: String { s("updateOpenPageButton") }
    package static var updateSkipButton: String { s("updateSkipButton") }
    package static var updateLaterButton: String { s("updateLaterButton") }
    package static var updateOKButton: String { s("updateOKButton") }

    // Quit confirmation dialog
    package static var quitConfirmTitle: String { s("quitConfirmTitle") }
    package static var quitConfirmMessage: String { s("quitConfirmMessage") }
    package static var quitConfirmAction: String { s("quitConfirmAction") }
    package static var quitConfirmCancel: String { s("quitConfirmCancel") }

    // Upload — toolbar / toast / progress
    package static var tipUpload: String { s("tipUpload") }
    package static var uploadingTitle: String { s("uploadingTitle") }
    package static var uploadCopied: String { s("uploadCopied") }
    package static var uploadCopiedMarkdown: String { s("uploadCopiedMarkdown") }
    package static var uploadNoProvider: String { s("uploadNoProvider") }
    package static var uploadFailedPrefix: String { s("uploadFailedPrefix") }

    // Upload — settings tab
    package static var uploadDefaultProvider: String { s("uploadDefaultProvider") }
    package static var uploadDefaultNone: String { s("uploadDefaultNone") }
    package static var uploadSetDefaultButton: String { s("uploadSetDefaultButton") }
    package static var uploadSaveButton: String { s("uploadSaveButton") }
    package static var uploadClearButton: String { s("uploadClearButton") }
    package static var uploadSavedToast: String { s("uploadSavedToast") }
    package static var uploadCurrentDefault: String { s("uploadCurrentDefault") }
    package static var uploadMarkdownToggleTitle: String { s("uploadMarkdownToggleTitle") }
    package static var uploadMarkdownToggleSubtitle: String { s("uploadMarkdownToggleSubtitle") }
    package static var filenameRuleTitle: String { s("filenameRuleTitle") }
    package static var filenameRuleSubtitle: String { s("filenameRuleSubtitle") }
    package static var filenameRulePresetLabel: String { s("filenameRulePresetLabel") }
    package static var filenameRulePresetCustom: String { s("filenameRulePresetCustom") }
    package static var filenameRulePresetShort: String { s("filenameRulePresetShort") }
    package static var filenameRulePresetCompact: String { s("filenameRulePresetCompact") }
    package static var filenameRulePresetUnique: String { s("filenameRulePresetUnique") }
    package static var filenameRulePresetCounter: String { s("filenameRulePresetCounter") }
    package static var filenameRulePresetRestore: String { s("filenameRulePresetRestore") }
    package static var filenameRuleImageLabel: String { s("filenameRuleImageLabel") }
    package static var filenameRuleRecordingLabel: String { s("filenameRuleRecordingLabel") }
    package static var filenameRuleVariablesLabel: String { s("filenameRuleVariablesLabel") }
    package static var filenameRuleVariableDate: String { s("filenameRuleVariableDate") }
    package static var filenameRuleVariableTime: String { s("filenameRuleVariableTime") }
    package static var filenameRuleVariableDaily: String { s("filenameRuleVariableDaily") }
    package static var filenameRuleVariableRandom: String { s("filenameRuleVariableRandom") }
    package static var filenameRuleVariableSize: String { s("filenameRuleVariableSize") }
    package static func filenameRulePreview(_ value: String) -> String {
        String(format: s("filenameRulePreview"), value)
    }

    // Upload — provider field labels
    package static var uploadFieldBucket: String { s("uploadFieldBucket") }
    package static var uploadFieldBucketSpace: String { s("uploadFieldBucketSpace") }
    package static var uploadFieldRegion: String { s("uploadFieldRegion") }
    package static var uploadFieldRegionOptional: String { s("uploadFieldRegionOptional") }
    package static var uploadFieldPathOptional: String { s("uploadFieldPathOptional") }
    package static var uploadFieldCustomUrlOptional: String { s("uploadFieldCustomUrlOptional") }
    package static var uploadFieldPublicDomain: String { s("uploadFieldPublicDomain") }
    package static var uploadFieldEndpointArea: String { s("uploadFieldEndpointArea") }
    package static var uploadFieldEndpointOptional: String { s("uploadFieldEndpointOptional") }
    package static var uploadFieldAccountId: String { s("uploadFieldAccountId") }
    package static var uploadTestImageFailed: String { s("uploadTestImageFailed") }

    // Upload — file dialog
    package static var finderUploadDialogTitle: String { s("finderUploadDialogTitle") }
    package static var finderUploadDialogHeading: String { s("finderUploadDialogHeading") }
    package static func finderUploadSummary(_ count: Int, _ provider: String) -> String {
        String(format: s("finderUploadSummary"), count, provider)
    }
    package static var finderUploadSelectAll: String { s("finderUploadSelectAll") }
    package static func finderUploadAction(_ count: Int) -> String {
        String(format: s("finderUploadAction"), count)
    }
    package static func finderUploadRetryAction(_ count: Int) -> String {
        String(format: s("finderUploadRetryAction"), count)
    }
    package static func finderUploadingProgress(_ current: Int, _ total: Int) -> String {
        String(format: s("finderUploadingProgress"), current, total)
    }
    package static var finderUploadSucceeded: String { s("finderUploadSucceeded") }
    package static var finderUploadFailed: String { s("finderUploadFailed") }
    package static var finderUploadErrorLogTitle: String { s("finderUploadErrorLogTitle") }
    package static var finderUploadUnknownSize: String { s("finderUploadUnknownSize") }
    package static func finderUploadReadFailed(_ message: String) -> String {
        String(format: s("finderUploadReadFailed"), message)
    }
    package static func finderUploadCompleted(_ count: Int) -> String {
        String(format: s("finderUploadCompleted"), count)
    }
    // Upload — provider names
    package static var providerTencentCOS: String { s("providerTencentCOS") }
    package static var providerQiniuKodo: String { s("providerQiniuKodo") }
    package static var providerAliyunOSS: String { s("providerAliyunOSS") }

    // Upload — errors
    package static var uploadErrMissingConfig: String { s("uploadErrMissingConfig") }
    package static var uploadErrInvalidConfigPrefix: String { s("uploadErrInvalidConfigPrefix") }
    package static var uploadErrNetworkPrefix: String { s("uploadErrNetworkPrefix") }
    package static func uploadErrServerPrefix(_ code: Int) -> String {
        String(format: s("uploadErrServerPrefix"), code)
    }
    package static var uploadErrUnexpectedResponsePrefix: String { s("uploadErrUnexpectedResponsePrefix") }
    package static func missingField(_ key: String) -> String {
        String(format: s("missingField"), key)
    }

    // Upload — test/validation pill
    package static var uploadStatusUntested: String { s("uploadStatusUntested") }
    package static var uploadStatusTesting: String { s("uploadStatusTesting") }
    package static var uploadStatusValid: String { s("uploadStatusValid") }
    package static var uploadStatusInvalid: String { s("uploadStatusInvalid") }

    // Upload — log lines
    package static var uploadLogStartingTest: String { s("uploadLogStartingTest") }
    package static var uploadLogConfigSaved: String { s("uploadLogConfigSaved") }
    package static func uploadLogMissingFields(_ keys: [String]) -> String {
        String(format: s("uploadLogMissingFields"), keys.joined(separator: ", "))
    }
    package static func uploadLogTestSucceeded(_ url: String) -> String {
        String(format: s("uploadLogTestSucceeded"), url)
    }
    package static func uploadLogTestFailed(_ message: String) -> String {
        String(format: s("uploadLogTestFailed"), message)
    }
    package static var uploadLogProviderDisabled: String { s("uploadLogProviderDisabled") }
    package static var uploadLogConfigCleared: String { s("uploadLogConfigCleared") }

    // Permissions — status label
    package static var permissionGranted: String { s("permissionGranted") }
    package static var permissionNotGranted: String { s("permissionNotGranted") }

    // OCR & Translation — result panel
    package static var ocrTextHeader: String { s("ocrTextHeader") }
    package static var settingsTabOCR: String { s("settingsTabOCR") }
    package static var ocrProviderApple: String { s("ocrProviderApple") }
    package static var ocrProviderBaidu: String { s("ocrProviderBaidu") }
    package static var ocrProviderTencent: String { s("ocrProviderTencent") }
    package static var ocrProviderCompatible: String { s("ocrProviderCompatible") }
    package static var ocrProviderLabel: String { s("ocrProviderLabel") }
    package static var ocrEndpointLabel: String { s("ocrEndpointLabel") }
    package static var ocrModelLabel: String { s("ocrModelLabel") }
    package static var ocrRegionLabel: String { s("ocrRegionLabel") }
    package static var ocrOptionalKey: String { s("ocrOptionalKey") }
    package static var ocrVisionModelHint: String { s("ocrVisionModelHint") }
    package static var ocrLocalDescription: String { s("ocrLocalDescription") }
    package static var ocrCloudDescription: String { s("ocrCloudDescription") }
    package static var ocrCompatibleDescription: String { s("ocrCompatibleDescription") }
    package static var ocrOllamaDescription: String { s("ocrOllamaDescription") }
    package static var ocrTextOnlyDescription: String { s("ocrTextOnlyDescription") }
    package static var ocrDocumentation: String { s("ocrDocumentation") }
    package static var ocrSettingsSaved: String { s("ocrSettingsSaved") }
    package static var ocrConfigurationError: String { s("ocrConfigurationError") }
    package static var ocrEndpointError: String { s("ocrEndpointError") }
    package static var ocrImageError: String { s("ocrImageError") }
    package static var ocrResponseError: String { s("ocrResponseError") }
    package static var ocrTimeoutError: String { s("ocrTimeoutError") }
    package static var ocrRequestFailed: String { s("ocrRequestFailed") }
    package static var ocrRecognizing: String { s("ocrRecognizing") }
    package static var ocrNoText: String { s("ocrNoText") }
    package static var ocrCopy: String { s("ocrCopy") }
    package static var ocrCopied: String { s("ocrCopied") }
    package static var ocrRetry: String { s("ocrRetry") }
    package static var ocrTranslating: String { s("ocrTranslating") }
    package static var ocrTranslateFailedPrefix: String { s("ocrTranslateFailedPrefix") }
    package static var ocrNoProviderTitle: String { s("ocrNoProviderTitle") }
    package static var ocrNoProviderHint: String { s("ocrNoProviderHint") }
    package static var ocrOpenSettings: String { s("ocrOpenSettings") }
    package static var ocrLineCopied: String { s("ocrLineCopied") }
    package static var copyImageTextCopying: String { s("copyImageTextCopying") }
    package static var copyImageTextCopied: String { s("copyImageTextCopied") }
    package static var copyImageTextNoText: String { s("copyImageTextNoText") }
    package static var screenshotTranslationHeader: String { s("screenshotTranslationHeader") }
    package static func screenshotTranslationLanguageButton(_ language: String) -> String {
        String(format: s("screenshotTranslationLanguageButton"), language)
    }
    package static var dictionaryEntryLabel: String { s("dictionaryEntryLabel") }
    package static var dictionaryPhoneticLabel: String { s("dictionaryPhoneticLabel") }
    package static var dictionaryPartOfSpeechLabel: String { s("dictionaryPartOfSpeechLabel") }
    package static var dictionaryDefinitionLabel: String { s("dictionaryDefinitionLabel") }
    package static var dictionaryExampleLabel: String { s("dictionaryExampleLabel") }
    package static var dictionaryDifficultyLabel: String { s("dictionaryDifficultyLabel") }
    package static var dictionaryNoProviderTitle: String { s("dictionaryNoProviderTitle") }
    package static var dictionaryNoProviderHint: String { s("dictionaryNoProviderHint") }

    // Translation — settings tab
    package static var translationDictionaryModeTitle: String { s("translationDictionaryModeTitle") }
    package static var translationDictionaryModeSubtitle: String { s("translationDictionaryModeSubtitle") }
    package static var translationTargetLanguage: String { s("translationTargetLanguage") }
    package static var translationTargetHint: String { s("translationTargetHint") }
    package static var translationApiKey: String { s("translationApiKey") }
    package static var translationApiKeyOptional: String { s("translationApiKeyOptional") }
    package static var translationModel: String { s("translationModel") }
    package static var translationEndpoint: String { s("translationEndpoint") }
    package static var translationEndpointOptional: String { s("translationEndpointOptional") }
    package static var translationSave: String { s("translationSave") }
    package static var translationClear: String { s("translationClear") }
    package static var translationConfigSaved: String { s("translationConfigSaved") }
    package static var translationTesting: String { s("translationTesting") }
    package static var translationTestPassed: String { s("translationTestPassed") }
    package static var translationTestFailed: String { s("translationTestFailed") }
    package static var translationTestFailedTitle: String { s("translationTestFailedTitle") }
    package static var translationProviderCustom: String { s("translationProviderCustom") }
    package static var translationAppleSubtitle: String { s("translationAppleSubtitle") }
    package static var translationErrAppleUnavailable: String { s("translationErrAppleUnavailable") }
    package static var translationMoveUp: String { s("translationMoveUp") }
    package static var translationMoveDown: String { s("translationMoveDown") }

    // Translation — target language names
    package static var transLangChinese: String { s("transLangChinese") }
    package static var transLangEnglish: String { s("transLangEnglish") }
    package static var transLangJapanese: String { s("transLangJapanese") }
    package static var transLangKorean: String { s("transLangKorean") }

    // Translation — errors
    package static var translationErrMissingAPIKey: String { s("translationErrMissingAPIKey") }
    package static var translationErrBadEndpoint: String { s("translationErrBadEndpoint") }
    package static var translationErrBadResponse: String { s("translationErrBadResponse") }

    // Image Merge workbench
    package static var imageMergeWindowTitle: String { s("imageMergeWindowTitle") }
    package static var imageMergeSources: String { s("imageMergeSources") }
    package static var imageMergeAddFiles: String { s("imageMergeAddFiles") }
    package static var imageMergeAddFromClipboard: String { s("imageMergeAddFromClipboard") }
    package static var imageMergeImageList: String { s("imageMergeImageList") }
    package static var imageMergeTemplate: String { s("imageMergeTemplate") }
    package static var imageMergeTemplateHorizontal: String { s("imageMergeTemplateHorizontal") }
    package static var imageMergeTemplateVertical: String { s("imageMergeTemplateVertical") }
    package static var imageMergeTemplateGrid: String { s("imageMergeTemplateGrid") }
    package static var imageMergeTemplateLongStitch: String { s("imageMergeTemplateLongStitch") }
    package static var imageMergeLayout: String { s("imageMergeLayout") }
    package static var imageMergeSpacing: String { s("imageMergeSpacing") }
    package static var imageMergeMargin: String { s("imageMergeMargin") }
    package static var imageMergeCornerRadius: String { s("imageMergeCornerRadius") }
    package static var imageMergeBackground: String { s("imageMergeBackground") }
    package static var imageMergeTransparent: String { s("imageMergeTransparent") }
    package static var imageMergeSolid: String { s("imageMergeSolid") }
    package static var imageMergeOutput: String { s("imageMergeOutput") }
    package static var imageMergeCopy: String { s("imageMergeCopy") }
    package static var imageMergeSave: String { s("imageMergeSave") }
    package static var imageMergeContinueEditing: String { s("imageMergeContinueEditing") }
    package static var imageMergeClose: String { s("imageMergeClose") }
    package static var imageMergeEmptyTitle: String { s("imageMergeEmptyTitle") }
    package static var imageMergeEmptyBody: String { s("imageMergeEmptyBody") }
    package static var imageMergeClipboardSourceName: String { s("imageMergeClipboardSourceName") }
}

