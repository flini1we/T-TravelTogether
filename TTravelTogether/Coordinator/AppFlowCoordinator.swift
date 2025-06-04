import UIKit

final class AppFlowCoordinator: IAppFlowCoordinator {

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

    func finish() {
        userService.logout()
        showAuthFlow()
    }
}

private extension AppFlowCoordinator {

    func showAuthFlow() {
        let coordinator = AuthCoordinator(
            navigationController: navigationController,
            dependencies: dependencies
        )
        coordinator.onLoginSuccess = { [weak self] userData in
            guard let self else { return }
            let authUser = User(phoneNumber: userData.phoneNumber)
            userService.login(authUser)
            showMainFlow()
        }
        addChild(coordinator)
        coordinator.start()
    }

    func showMainFlow() {
        guard let user = userService.currentUser else {
            navigationController.present(AlertFactory.showUserError(), animated: true)
            userService.logout()
            showAuthFlow()
            return
        }
        let coordinator = MainCoordinator(
            navigationController: navigationController,
            dependencieProvider: dependencies,
            user: user
        )
        coordinator.coordinator = self
        addChild(coordinator)
        coordinator.start()
    }

    func handleAuthSuccess() {
        childCoordinators.removeAll { $0 is IAuthCoordinator }
        showMainFlow()
    }
}
