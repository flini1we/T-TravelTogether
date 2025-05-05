import Foundation
import UIKit

enum UIElementsValues {

    case textFieldHeight,
         buttonHeight,
         systemButtonHeight,
         activiryIndicator,
         tabBarItem,
         locationMark,
         tripCellHeight,
         calendarIcon,
         memberCollectionViewCell,
         anyNavigationBarItem

    var value: CGFloat {
        switch self {
        case .textFieldHeight, .buttonHeight:
            55
        case .systemButtonHeight, .locationMark:
            30
        case .activiryIndicator:
            75
        case .tabBarItem:
            35
        case .tripCellHeight:
            100
        case .calendarIcon:
            20
        case .anyNavigationBarItem:
            24
        default:
            0
        }
    }

    func padding(_ value: CGFloat) -> CGFloat {
        return self.value - value
    }

    var size: CGSize {
        switch self {
        case .memberCollectionViewCell:
            let width = UIScreen.main.bounds.width / 3
            return CGSize(width: width, height: width / 1.75)
        default:
            return 0.getSize
        }
    }
}
