import UIKit
import Swinject

protocol IDependencyContainer {

    func resolveLoginViewModel() -> ILoginViewModel
    func resolveRegistrationViewModel() -> IRegistrationViewModel
    func resolveMyTripsViewModel() -> IMyTripsViewModel
    func resolveTripDetailViewModel(tripId: UUID, user: User) -> ITripDetailViewModel
    func resolveTripViewModel() -> ICreateTripViewModel

    func resolveLoginController() -> LoginController
    func resolveRegistrationController() -> RegistrationController
    func resolveMyTripsController() -> MyTripsController
    func resolveTripDetailController(tripId: UUID, user: User) -> TripDetailController
    func resolveCreateTripController(user: User) -> CreateTripController
    func resolveContactsController(selectedContacts: [Contact]) -> ContactsController
 
    func resolveMainTabBarController() -> UITabBarController
}
