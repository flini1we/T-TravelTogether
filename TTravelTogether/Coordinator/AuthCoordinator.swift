import UIKit

final class AuthCoordinator: AuthCoordinatorProtocol {
    var onLoginSuccess: ((String) -> Void)?

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let loginScreen = SwinjectContainer.shared.resolveLoginController()
        loginScreen.goToRegistration = { [weak self] in
            self?.showRegistration()
        }
        loginScreen.onLoginSuccess = { [weak self] user in
            self?.onLoginSuccess?(user)
        }
        navigationController.setViewControllers([loginScreen], animated: false)
    }

    func showRegistration() {
        let registrationScreen = SwinjectContainer.shared.resolveRegistrationController()
        registrationScreen.registerButtonAction = { [weak self] _ in
            self?.navigationController.popViewController(animated: true)
        }
        navigationController.pushViewController(registrationScreen, animated: true)
    }
}
