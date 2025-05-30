import UIKit

enum SystemImages {

    case slashedEye(Bool),
         travellingTabBarImage,
         createTravelTabBarItem,
         archiveTabBarItem,
         location,
         calendar,
         leaveTrip,
         editTrip,
         remove,
         handRaised,
         circle(Bool),
         profileTabBarItem,
         profileDefault,
         changeLanguage,
         changeTheme,
         archiveTrips

    var image: UIImage {
        switch self {
        case .slashedEye(let isSlashed):
            return UIImage(systemName: isSlashed ? "eye.slash" : "eye")!
        case .travellingTabBarImage, .createTravelTabBarItem, .archiveTabBarItem, .profileTabBarItem:
            var image: UIImage!
            switch self {
            case .travellingTabBarImage:
                image = .travellingTab
            case .createTravelTabBarItem:
                image = .newTravelTab
            case .archiveTabBarItem:
                image = .archiveTab
            case .profileTabBarItem:
                image = .profileTabBar
            default: break
            }
            image = image.resized(to: CGSize(
                width: UIElementsValues.tabBarItem.value,
                height: UIElementsValues.tabBarItem.value))
            image.withTintColor(.primaryYellow)
            return image
        case .location:
            var image: UIImage = .locationMark
            image = image.resized(to: CGSize(
                width: UIElementsValues.locationMark.value,
                height: UIElementsValues.locationMark.value)
            )
            return image
        case .calendar:
            var image: UIImage = .calendar
            image = image.resized(to: CGSize(
                width: UIElementsValues.calendarIcon.value,
                height: UIElementsValues.calendarIcon.value)
            )
            image.withTintColor(.primaryBlue)
            return image
        case .leaveTrip:
            return UIImage(systemName: "rectangle.portrait.and.arrow.right")!
        case .editTrip:
            return UIImage(systemName: "pencil.line")!
        case .remove:
            return UIImage(systemName: "minus.circle.fill")!
        case .handRaised:
            return UIImage(systemName: "hand.raised.square.fill")!
        case .circle(let isSelected):
            return UIImage(systemName: isSelected ? "checkmark.circle.fill" : "circle")!
        case .profileDefault:
            return UIImage(systemName: "person.crop.circle.fill")!
        case .changeLanguage:
            return .changeLanguage
        case .changeTheme:
            return UIImage(systemName: "circle.lefthalf.filled")!
        case .archiveTrips:
            return .archiveTab
        }
    }
}
