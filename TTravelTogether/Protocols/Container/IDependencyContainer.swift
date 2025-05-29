import UIKit
import Swinject

protocol IDependencyContainer {

    func resolveLoginViewModel() -> ILoginViewModel
    func resolveRegistrationViewModel() -> IRegistrationViewModel
    func resolveMyTripsViewModel() -> IMyTripsViewModel
    func resolveTripViewModel() -> ICreateTripViewModel

    func resolveLoginController() -> LoginController
    func resolveRegistrationController() -> RegistrationController
    func resolveMyTripsController() -> MyTripsController
    func resolveTripDetailController(tripId: Int, user: User) -> TripDetailController
    func resolveCreateTripController(user: User) -> CreateTripController
    func resolveContactsController(selectedContacts: [Contact]) -> ContactsController

    func resolveNetworkService() -> INetworkService

    func resolveMainTabBarController() -> UITabBarController
}
