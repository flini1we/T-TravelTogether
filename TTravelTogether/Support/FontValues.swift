import Foundation

enum FontValues {
    case small, `default`, semiDefault, big, medium, semiMedium, title

    var value: CGFloat {
        switch self {
        case .small:
            14
        case .default:
            16
        case .semiDefault:
            18
        case .medium:
            22
        case .semiMedium:
            24
        case .big:
            28
        case .title:
            32
        }
    }
}
