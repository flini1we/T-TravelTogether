import UIKit

final class AppFlowCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var dependencies: DependencyContainerProtocol

    private var authCoordinator: AuthCoordinatorProtocol?
    private var mainCoordinator: MainCoordinatorProtocol?

    init(navigationController: UINavigationController, dependencies: DependencyContainerProtocol) {
        self.navigationController = navigationController
        self.dependencies = dependencies

        authCoordinator = AuthCoordinator(
            navigationController: navigationController,
            dependencies: dependencies
        )
        mainCoordinator = MainCoordinator(
            navigationController: navigationController,
            dependencieProvider: dependencies
        )
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

        coordinator.onLoginSuccess = { [weak self] _ in
            self?.handleAuthSuccess()
        }

        authCoordinator = coordinator
        addChild(coordinator)
        coordinator.start()
    }

    func showMainFlow() {
        let coordinator = MainCoordinator(
            navigationController: navigationController,
            dependencieProvider: dependencies
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
