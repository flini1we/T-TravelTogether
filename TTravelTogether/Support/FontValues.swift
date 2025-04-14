import Foundation

enum FontValues {
    case small, `default`, title

    var value: CGFloat {
        switch self {
        case .small:
            14
        case .default:
            16
        case .title:
            22
        }
    }
}
