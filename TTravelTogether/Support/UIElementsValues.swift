import Foundation

enum UIElementsValues {
    case textFieldHeight, buttonHeight, systemButtonHeight

    var value: CGFloat {
        switch self {
        case .textFieldHeight, .buttonHeight:
            55
        case .systemButtonHeight:
            30
        }
    }
}
