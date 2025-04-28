import UIKit

final class AppFlowCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    private var authCoordinator: AuthCoordinatorProtocol?
    private var mainCoordinator: MainCoordinatorProtocol?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController

        authCoordinator = AuthCoordinator(navigationController: navigationController)
        mainCoordinator = MainCoordinator(navigationController: navigationController)
    }

    func start() {
        let isLoggedIn = false

        isLoggedIn ? showMainFlow() : showAuthFlow()
    }
}

private extension AppFlowCoordinator {
    func showAuthFlow() {
        let coordinator = AuthCoordinator(
            navigationController: navigationController
        )

        coordinator.onLoginSuccess = { [weak self] _ in
            self?.handleAuthSuccess()
        }

        authCoordinator = coordinator
        addChild(coordinator)
        coordinator.start()
    }

    func showMainFlow() {
        let coordinator = MainCoordinator(
            navigationController: navigationController
        )

        mainCoordinator = coordinator
        addChild(coordinator)
        coordinator.start()
    }

    func handleAuthSuccess() {
        authCoordinator.map { removeChild($0) }
        authCoordinator = nil
        showMainFlow()
    }
}
