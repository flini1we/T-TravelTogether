import UIKit
import Swinject

protocol DependencyContainerProtocol {

    func resolveLoginViewModel() -> Loginable
    func resolveRegistrationViewModel() -> Registratable
    func resolveMyTripsViewModel() -> MyTripsVMProtocol
    func resolveTripDetailViewModel(tripId: UUID) -> TripDetailVMProtocol

    func resolveLoginController() -> LoginController
    func resolveRegistrationController() -> RegistrationController
    func resolveMyTripsController() -> MyTripsController
    func resolveTripDetailController(tripId: UUID) -> TripDetailController

    func resolveMainTabBarController() -> UITabBarController
}
