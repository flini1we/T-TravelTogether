import Foundation

enum PaddingValues {
    case tiny, `default`, medium, big

    var value: CGFloat {
        switch self {
        case .tiny:
            7.5
        case .default:
            15
        case .medium:
            20
        case .big:
            30
        }
    }
}
