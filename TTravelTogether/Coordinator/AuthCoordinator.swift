import UIKit

final class AuthCoordinator: IAuthCoordinator {

    var onLoginSuccess: ((User) -> Void)?

    var dependencies: IDependencyContainer
    var childCoordinators: [ICoordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController, dependencies: IDependencyContainer) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        let loginScreen = dependencies.resolveLoginController()
        loginScreen.coordinator = self
        navigationController.setViewControllers([loginScreen], animated: false)
    }

    func onLoginSuccess(_ user: String) {
        onLoginSuccess?(User(phoneNumber: user))
    }

    func goToRegistration() {
        showRegistration()
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
