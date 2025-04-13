import Foundation

enum PaddingValues {
    case `default`, medium, big

    var value: CGFloat {
        switch self {
        case .default:
            15
        case .medium:
            20
        case .big:
            30
        }
    }
}
