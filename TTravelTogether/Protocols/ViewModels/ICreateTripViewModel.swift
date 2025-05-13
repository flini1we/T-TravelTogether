import Foundation
import Contacts
import ContactsUI

protocol ICreateTripViewModel: AnyObject, CNContactPickerDelegate {
    var onClearingController: (() -> Void)? { get set }

    var tripMembers: [User] { get set }
    var tripMembersPublisher: Published<[User]>.Publisher { get }

    var isCreateButtonEnable: Bool { get }
    var isCreateButtonEnablePublisher: Published<Bool>.Publisher { get }

    var tripTitleText: String { get set }
    var tripTitleTextPublisher: Published<String>.Publisher { get }

    var tripPriceText: String { get set }
    var tripPricePublisher: Published<String>.Publisher { get }

    func addMembers(phoneNumbers: [String])
    func clearData()
}
