import UIKit

final class MainCoordinator: IMainCoordinator {

    var childCoordinators: [ICoordinator] = []
    var navigationController: UINavigationController
    var dependencies: DependencyContainerProtocol

    init(navigationController: UINavigationController, dependencieProvider: DependencyContainerProtocol) {
        self.navigationController = navigationController
        self.dependencies = dependencieProvider
    }

    func start() {
        showMainTabBar()
    }

    func showTripDetail(_ id: UUID) {
        let detailVC = dependencies.resolveTripDetailController(tripId: id)
        navigationController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(detailVC, animated: true)
    }
}

private extension MainCoordinator {

    func showMainTabBar() {
        let tabBarController = dependencies.resolveMainTabBarController()
        if let myTripsController =
            tabBarController
            .viewControllers?
            .compactMap({ $0 as? MyTripsController })
            .first { myTripsController.coordinator = self }
        navigationController.setViewControllers([tabBarController], animated: true)
    }
}
