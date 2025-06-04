import UIKit
import Combine

protocol IContactsViewModel: AnyObject {

    var contacts: CurrentValueSubject<[Contact], Never> { get }
    var selectedContacts: Set<Contact> { get set }
    var onRequestAccess: ((UIAlertController) -> Void)? { get set }

    func clearData()
    func isContactSelected(_ contact: Contact) -> Bool
    func removeSelectedContact(_ contact: Contact)
}
