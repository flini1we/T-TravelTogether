import UIKit

final class MainCoordinator: MainCoordinatorProtocol {

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showMainTabBar()
    }

    func showTripDetail(tripId: UUID) {
        let detailVC = SwinjectContainer.shared.resolveTripDetailController(tripId: tripId)
        navigationController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(detailVC, animated: true)
    }
}

private extension MainCoordinator {

    func showMainTabBar() {
        let tabBarController = SwinjectContainer.shared.resolveMainTabBarController()
        if let myTripsController =
            tabBarController
            .viewControllers?
            .compactMap({ $0 as? MyTripsController })
            .first
        {
            myTripsController.onShowingTripDetail = { [weak self] tripId in
                let tripDetailController = SwinjectContainer.shared.resolveTripDetailController(tripId: tripId)
                self?.navigationController.pushViewController(tripDetailController, animated: true)
            }
        }
        navigationController.setViewControllers([tabBarController], animated: true)
    }
}
