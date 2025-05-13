import Foundation

enum PaddingValues {
    case tiny, small, `default`, medium, semiBig, big, large

    var value: CGFloat {
        switch self {
        case .tiny:
            4
        case .small:
            8
        case .default:
            16
        case .medium:
            20
        case .semiBig:
            26
        case .big:
            32
        case .large:
            48
        }
    }
}
