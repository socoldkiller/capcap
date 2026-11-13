import Foundation
package enum ImageMergeTemplate: Int, CaseIterable {
    case horizontal
    case vertical
    case grid
    case longStitch

    package var title: String {
        switch self {
        case .horizontal: return L10n.imageMergeTemplateHorizontal
        case .vertical: return L10n.imageMergeTemplateVertical
        case .grid: return L10n.imageMergeTemplateGrid
        case .longStitch: return L10n.imageMergeTemplateLongStitch
        }
    }
}
