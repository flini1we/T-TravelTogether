import UIKit

final class AppCoordinator: CoordinatorProtocol {

    var navigationController: UINavigationController
    var moduleFactory: ModuleFactoryProtocol

    private var isRegistrationShown = false

    init(navigationController: UINavigationController, moduleFactory: ModuleFactoryProtocol) {
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
    }

    func start() {
        showLogin(user: nil)
    }

    func showLogin(user: String?) {
        let loginViewController = moduleFactory.makeLoginModule()
        if let loginViewController = loginViewController as? LoginController {
            loginViewController.coordinator = self
        }
        if isRegistrationShown {
            navigationController.popViewController(animated: true)
        } else {
            navigationController.setViewControllers([loginViewController], animated: false)
        }
    }

    func showRegistration() {
        isRegistrationShown = true
        let registrationController = moduleFactory.makeRegistrationModule()
        if let registrationController = registrationController as? RegistrationController {
            registrationController.coordinator = self
        }
        navigationController.pushViewController(registrationController, animated: true)
    }

    func showMainTabBar() {
        let tabBarController = moduleFactory.createMainTabBarController(coordinator: self)
        navigationController.setViewControllers([tabBarController], animated: true)
    }

    func showTripDetail(_ tripId: UUID) {
        let tripDetailController = moduleFactory.createTripDetailController(tripId: tripId)
        navigationController.pushViewController(tripDetailController, animated: true)
    }

    func finish() { }
}
