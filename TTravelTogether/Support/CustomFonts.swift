import UIKit

enum CustomFonts {

    case `default`(CGFloat), bold(CGFloat), medium(CGFloat)

    var font: UIFont {
        switch self {
        case .default(let value):
            return .init(name: "TinkoffSans-Regular", size: value) ?? .systemFont(ofSize: value)
        case .bold(let value):
            return .init(name: "TinkoffSans-Bold", size: value) ?? .boldSystemFont(ofSize: value)
        case .medium(let value):
            return .init(name: "TinkoffSans-Medium", size: value) ?? .systemFont(ofSize: value)
        }
    }
}
