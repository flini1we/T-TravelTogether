import UIKit

enum PaymentOption: Int, CaseIterable {

    case forYour, forAll, split

    var image: UIImage {
        switch self {
        case .forYour:
            return UIImage(systemName: "person.fill")!
            ///return .payForYourself
        case .forAll:
            return UIImage(systemName: "person.3.sequence.fill")!
            ///return .payForAll
        case .split:
            return UIImage(systemName: "person.fill.badge.plus")!
            ///return .splitEqually
        }
    }
}
