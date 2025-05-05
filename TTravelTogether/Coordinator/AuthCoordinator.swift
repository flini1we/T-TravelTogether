import UIKit

final class AuthCoordinator: AuthCoordinatorProtocol {

    var dependencies: DependencyContainerProtocol
    var onLoginSuccess: ((String) -> Void)?

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController, dependencies: DependencyContainerProtocol) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        let loginScreen = dependencies.resolveLoginController()
        loginScreen.goToRegistration = { [weak self] in
            self?.showRegistration()
        }
        loginScreen.onLoginSuccess = { [weak self] user in
            self?.onLoginSuccess?(user)
        }
        navigationController.setViewControllers([loginScreen], animated: false)
    }
}

private extension AuthCoordinator {

    func showRegistration() {
        let registrationScreen = dependencies.resolveRegistrationController()
        registrationScreen.registerButtonAction = { [weak self] _ in
            self?.navigationController.popViewController(animated: true)
        }
        navigationController.pushViewController(registrationScreen, animated: true)
    }
}
