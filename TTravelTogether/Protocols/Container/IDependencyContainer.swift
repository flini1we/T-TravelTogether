import UIKit
import Swinject

protocol IDependencyContainer {

    func resolveLoginViewModel() -> ILoginViewModel
    func resolveRegistrationViewModel() -> IRegistrationViewModel
    func resolveMyTripsViewModel() -> IMyTripsViewModel
    func resolveTripDetailViewModel(tripId: UUID) -> ITripDetailViewModel
    func resolveTripViewModel() -> ICreateTripViewModel

    func resolveLoginController() -> LoginController
    func resolveRegistrationController() -> RegistrationController
    func resolveMyTripsController() -> MyTripsController
    func resolveTripDetailController(tripId: UUID) -> TripDetailController
    func resolveCreateTripController(user: User) -> CreateTripController
    func resolveContactsController(selectedContacts: [Contact]) -> ContactsController

    func resolveMainTabBarController() -> UITabBarController
}
