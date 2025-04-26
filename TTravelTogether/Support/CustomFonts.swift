import UIKit

enum CustomFonts {

    case `default`(CGFloat), bold(CGFloat)

    var font: UIFont {
        switch self {
        case .default(let value):
            return .systemFont(ofSize: value)
        case .bold(let value):
            return .boldSystemFont(ofSize: value)
        }
    }
}
