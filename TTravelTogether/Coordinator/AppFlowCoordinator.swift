import UIKit

final class AppFlowCoordinator: ICoordinator {

    var childCoordinators: [ICoordinator] = []
    var navigationController: UINavigationController
    var dependencies: IDependencyContainer
    var userService: UserService

    init(navigationController: UINavigationController, dependencies: IDependencyContainer, userService: UserService) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.userService = userService
    }

    func start() {
        let isLoggedIn = userService.isAuthenticated
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
            guard let self else { return }
            userService.login(user)
            showMainFlow()
        }
        addChild(coordinator)
        coordinator.start()
    }

    func showMainFlow() {
        guard let user = userService.currentUser else {
            navigationController.present(AlertFactory.showUserError(), animated: true)
            // TODO: когда будет выход из аккаунта тут тоже прокину сразу чтоб на решу кидало
            return
        }

        let coordinator = MainCoordinator(
            navigationController: navigationController,
            dependencieProvider: dependencies,
            user: user
        )
        addChild(coordinator)
        coordinator.start()
    }

    func handleAuthSuccess() {
        childCoordinators.removeAll { $0 is IAuthCoordinator }
        showMainFlow()
    }
}
