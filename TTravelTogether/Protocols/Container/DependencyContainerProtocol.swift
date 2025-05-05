import UIKit
import Swinject

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
    func resolveCreateTripController() -> CreateTripController

    func resolveMainTabBarController() -> UITabBarController
}
