import UIKit

enum CustomFonts {

    case `default`(CGFloat), title

    var font: UIFont {
        switch self {
        case .default(let value):
            return .systemFont(ofSize: value)
        case .title:
            return .boldSystemFont(ofSize: FontValues.title.value)
        }
    }
}
