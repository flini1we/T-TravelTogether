import UIKit

enum CustomFonts {

    case `default`, title

    var font: UIFont {
        switch self {
        case .default:
            return .systemFont(ofSize: FontValues.default.value)
        case .title:
            return .boldSystemFont(ofSize: FontValues.title.value)
        }
    }
}
