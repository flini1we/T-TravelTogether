import UIKit

final class MainCoordinator: MainCoordinatorProtocol {

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var dependencies: DependencyContainerProtocol

    init(navigationController: UINavigationController, dependencieProvider: DependencyContainerProtocol) {
        self.navigationController = navigationController
        self.dependencies = dependencieProvider
    }

    func start() {
        showMainTabBar()
    }

    func showTripDetail(tripId: UUID) {
        let detailVC = dependencies.resolveTripDetailController(tripId: tripId)
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
            .first {
                myTripsController.onShowingTripDetail = { [weak self] tripId in
                    guard let self else { return }
                    let tripDetailController = dependencies.resolveTripDetailController(tripId: tripId)
                    navigationController.pushViewController(tripDetailController, animated: true)
                }
            }
        navigationController.setViewControllers([tabBarController], animated: true)
    }
}
