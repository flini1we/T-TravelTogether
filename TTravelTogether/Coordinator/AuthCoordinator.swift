import UIKit

final class AuthCoordinator: AuthCoordinatorProtocol {
    var onLoginSuccess: ((String) -> Void)?

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var factory: ModuleFactoryProtocol

    init(navigationController: UINavigationController, factory: ModuleFactoryProtocol) {
        self.navigationController = navigationController
        self.factory = factory
    }

    func start() {
        let loginScreen = factory.makeLoginModule()
        if let loginScreen = loginScreen as? LoginController {
            loginScreen.goToRegistration = { [weak self] in
                self?.showRegistration()
            }

            loginScreen.onLoginSuccess = { [weak self] user in
                self?.onLoginSuccess?(user)
            }
        }
        navigationController.setViewControllers([loginScreen], animated: false)
    }

    func showRegistration() {
        let registrationScreen = factory.makeRegistrationModule()
        if let registrationScreen = registrationScreen as? RegistrationController {
            registrationScreen.registerButtonAction = { [weak self] _ in
                self?.navigationController.popViewController(animated: true)
            }
        }
        navigationController.pushViewController(registrationScreen, animated: true)
    }
}
