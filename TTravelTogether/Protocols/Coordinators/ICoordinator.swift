import UIKit

protocol ICoordinator: AnyObject {

    var childCoordinators: [ICoordinator] { get set }
    var navigationController: UINavigationController { get set }
    var dependencies: IDependencyContainer { get }

    func start()
}

extension ICoordinator {

    func addChild(_ coordinator: ICoordinator) {
        childCoordinators.append(coordinator)
    }
}
