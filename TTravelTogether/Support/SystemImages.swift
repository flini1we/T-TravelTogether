import UIKit

enum SystemImages {

    case slashedEye(Bool),
         travellingTabBarImage,
         createTravelTabBarItem,
         archiveTabBarItem,
         location,
         calendar,
         leaveTrip,
         editTrip

    var image: UIImage {
        switch self {
        case .slashedEye(let isSlashed):
            return UIImage(systemName: isSlashed ? "eye.slash" : "eye")!
        case .travellingTabBarImage, .createTravelTabBarItem, .archiveTabBarItem:
            var image: UIImage!
            switch self {
            case .travellingTabBarImage:
                image = .travellingTab
            case .createTravelTabBarItem:
                image = .newTravelTab
            case .archiveTabBarItem:
                image = .archiveTab
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
        }
    }
}
