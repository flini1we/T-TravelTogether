import Foundation
import Contacts
import ContactsUI

protocol ICreateTripViewModel: AnyObject, CNContactPickerDelegate {
    var ogId: Int? { get set }
    var onDataHandling: (() -> (Date, Date)?)? { get set }
    var onClearingController: (() -> Void)? { get set }
    var onShowingIncorrectPriceAlert: ((UIAlertController) -> Void)? { get set }

    var tripMembers: [User] { get set }
    var tripMembersPublisher: Published<[User]>.Publisher { get }

    var isCreateButtonEnable: Bool { get }
    var isCreateButtonEnablePublisher: Published<Bool>.Publisher { get }

    var tripTitleText: String { get set }
    var tripTitleTextPublisher: Published<String>.Publisher { get }

    var tripPriceText: String { get set }
    var tripPricePublisher: Published<String>.Publisher { get }

    var createdTrip: TripDetail? { get set }
    var createdTripPublisher: Published<TripDetail?>.Publisher { get }

    var editedTrip: TripDetail? { get set }
    var editedTripPublisher: Published<TripDetail?>.Publisher { get }

    var selectedUsers: Set<String> { get set }

    func addMembers(phoneNumbers: [String])
    func clearData()
    func updateMembers(users: [User])
    func obtainContacts() -> [Contact]
    func createTrip(
        dates: (start: Date, finish: Date),
        completion: @escaping ((Result<TripDetail, CustomError>) -> Void)
    )
    func updateTrip(
        completion: @escaping ((Result<EditTripDTO, CustomError>) -> Void)
    )
    func isEditing() -> Bool
}
