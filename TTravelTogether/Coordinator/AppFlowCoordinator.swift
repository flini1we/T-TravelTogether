import UIKit

final class AppFlowCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    private var moduleFactory: ModuleFactoryProtocol
    private var authCoordinator: AuthCoordinatorProtocol?
    private var mainCoordinator: MainCoordinatorProtocol?

    init(navigationController: UINavigationController, factory: ModuleFactoryProtocol) {
        self.navigationController = navigationController
        self.moduleFactory = factory

        authCoordinator = AuthCoordinator(navigationController: navigationController, factory: moduleFactory)
        mainCoordinator = MainCoordinator(navigationController: navigationController, factory: moduleFactory)
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
            factory: moduleFactory
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
            factory: moduleFactory
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
