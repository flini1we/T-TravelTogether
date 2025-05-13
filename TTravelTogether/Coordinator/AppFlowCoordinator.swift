import UIKit

final class AppFlowCoordinator: ICoordinator {

    var childCoordinators: [ICoordinator] = []
    var navigationController: UINavigationController
    var dependencies: IDependencyContainer

    init(navigationController: UINavigationController, dependencies: IDependencyContainer) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        let isLoggedIn = UserService.shared.isAuthenticated
        _ = isLoggedIn ? showMainFlow() : showAuthFlow()
    }
}

private extension AppFlowCoordinator {

    func showAuthFlow() {
        let coordinator = AuthCoordinator(
            navigationController: navigationController,
            dependencies: dependencies
        )
        coordinator.onLoginSuccess = { [weak self] user in
            UserService.shared.login(user)
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
        addChild(coordinator)
        coordinator.start()
    }

    func handleAuthSuccess() {
        childCoordinators.removeAll { $0 is IAuthCoordinator }
        showMainFlow()
    }
}
