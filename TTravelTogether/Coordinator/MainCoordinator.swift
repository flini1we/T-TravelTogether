import UIKit

final class MainCoordinator: MainCoordinatorProtocol {

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var factory: ModuleFactoryProtocol

    init(navigationController: UINavigationController, factory: ModuleFactoryProtocol) {
        self.navigationController = navigationController
        self.factory = factory
    }

    func start() {
        showMainTabBar()
    }

    func showTripDetail(tripId: UUID) {
        let detailVC = factory.createTripDetailController(tripId: tripId)
        navigationController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(detailVC, animated: true)
    }
}

private extension MainCoordinator {

    func showMainTabBar() {
        let tabBarController = factory.createMainTabBarController()
        factory.onTripDetailControllerShow = { [weak self] tripId in
            self?.showTripDetail(tripId: tripId)
        }
        navigationController.setViewControllers([tabBarController], animated: true)
    }
}
