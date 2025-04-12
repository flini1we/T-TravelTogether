import Foundation

enum PaddingValues {
    case `default`

    var value: CGFloat {
        switch self {
        case .default:
            15
        }
    }
}
