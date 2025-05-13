import UIKit

final class AppFlowCoordinator: ICoordinator {
    var user: User?

    var childCoordinators: [ICoordinator] = []
    var navigationController: UINavigationController
    var dependencies: DependencyContainerProtocol

    init(navigationController: UINavigationController, dependencies: DependencyContainerProtocol) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        let isLoggedIn = false
        isLoggedIn ? showMainFlow() : showAuthFlow()
    }
}

private extension AppFlowCoordinator {

    func showAuthFlow() {
        let coordinator = AuthCoordinator(
            navigationController: navigationController,
            dependencies: dependencies
        )
        coordinator.onLoginSuccess = { [weak self] user in
            self?.user = user
            self?.showMainFlow()
        }
        addChild(coordinator)
        coordinator.start()
    }

    func showMainFlow() {
        let coordinator = MainCoordinator(
            navigationController: navigationController,
            dependencieProvider: dependencies
        )
        coordinator.registratedUser = user
        addChild(coordinator)
        coordinator.start()
    }

    func handleAuthSuccess() {
        childCoordinators.removeAll { $0 is IAuthCoordinator }
        showMainFlow()
    }
}
