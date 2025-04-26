import UIKit

protocol ModuleFactoryProtocol {

    func makeLoginModule() -> UIViewController
    func makeRegistrationModule() -> UIViewController

    func createMainTabBarController(coordinator: CoordinatorProtocol) -> UITabBarController
    func createTripDetailController(tripId id: UUID) -> UIViewController
}
