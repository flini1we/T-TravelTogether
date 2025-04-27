import UIKit

protocol ModuleFactoryProtocol {

    var onTripDetailControllerShow: ((UUID) -> Void)? { get set }

    func makeLoginModule() -> UIViewController
    func makeRegistrationModule() -> UIViewController

    func createMainTabBarController() -> UITabBarController
    func createTripDetailController(tripId id: UUID) -> UIViewController
}
