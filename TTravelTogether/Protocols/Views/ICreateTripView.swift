import UIKit

protocol ICreateTripView: AnyObject {

    var onShowingContacts: (() -> Void)? { get set }

    var createButton: UIButton { get }
    var tripTitleField: UITextField { get }
    var tripPriceField: UITextField { get }
}
