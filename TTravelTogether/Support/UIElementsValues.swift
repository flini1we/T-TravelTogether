import Foundation

enum UIElementsValues {
    case textFieldHeight, buttonHeight, systemButtonHeight, activiryIndicator

    var value: CGFloat {
        switch self {
        case .textFieldHeight, .buttonHeight:
            55
        case .systemButtonHeight:
            30
        case .activiryIndicator:
            75
        }
    }
}
