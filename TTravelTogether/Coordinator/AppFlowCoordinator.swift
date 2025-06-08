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
        showFakeLaunch()
    }

    func finish() {
        userService.logout()
        NotificationCenter
            .default
            .post(name: NSNotification.Name(.AppStrings.Notification.clearScreend), object: nil)
        showAuthFlow()
    }
}

private extension AppFlowCoordinator {

    func showFakeLaunch() {
        let launchController = FakeModuleViewController()
        navigationController.setViewControllers([launchController], animated: false)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 0.25) {
                launchController.titleImageView.alpha = 0
            } completion: { _ in
                let isLoggedIn = self.userService.isAuthenticated
                _ = isLoggedIn ? self.showMainFlow() : self.showAuthFlow()
            }
        }
    }

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
