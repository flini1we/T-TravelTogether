import UIKit
import Swinject
import Contacts
import ContactsUI

protocol DependencyContainerProtocol {

    func resolveLoginViewModel() -> ILoginViewModel
    func resolveRegistrationViewModel() -> IRegistrationViewModel
    func resolveMyTripsViewModel() -> IMyTripsViewModel
    func resolveTripDetailViewModel(tripId: UUID) -> ITripDetailViewModel
    func createTripViewModel() -> ICreateTripViewModel

    func resolveLoginController() -> LoginController
    func resolveRegistrationController() -> RegistrationController
    func resolveMyTripsController() -> MyTripsController
    func resolveTripDetailController(tripId: UUID) -> TripDetailController
    func resolveCreateTripController(user: User) -> CreateTripController

    func resolveContactsViewController() -> CNContactPickerViewController

    func resolveMainTabBarController() -> UITabBarController
}
