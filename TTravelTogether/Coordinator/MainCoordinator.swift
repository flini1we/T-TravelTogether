import UIKit

final class MainCoordinator: NSObject, IMainCoordinator {

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
        tabBarController.delegate = self
        if let myTripsController =
            tabBarController
            .viewControllers?
            .compactMap({ $0 as? MyTripsController })
            .first { myTripsController.coordinator = self }
        navigationController.setViewControllers([tabBarController], animated: true)
    }
}

extension MainCoordinator: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is CreateTripController {
            let createTripController = dependencies.resolveCreateTripController()
            if let sheetController = createTripController.sheetPresentationController {
                if #available(iOS 16.0, *) {
                    let customDetent = UISheetPresentationController.Detent.custom { context in
                        return context.maximumDetentValue * 0.75
                    }
                    sheetController.detents = [customDetent]
                } else {
                    sheetController.detents = [.large()]
                }
            }
            tabBarController.present(createTripController, animated: true)
            return false
        }
        return true
    }
}
