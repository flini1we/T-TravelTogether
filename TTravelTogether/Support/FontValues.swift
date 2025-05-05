import Foundation

enum FontValues {
    case small, `default`, big, medium, title

    var value: CGFloat {
        switch self {
        case .small:
            14
        case .default:
            16
        case .medium:
            22
        case .big:
            28
        case .title:
            32
        }
    }
}
