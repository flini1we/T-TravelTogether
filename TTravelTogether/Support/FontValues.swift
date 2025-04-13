import Foundation

enum FontValues {
    case `default`, title

    var value: CGFloat {
        switch self {
        case .default:
            16
        case .title:
            22
        }
    }
}
