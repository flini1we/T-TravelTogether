import UIKit

protocol IMainCoordinator: ICoordinator {

    var dependencies: DependencyContainerProtocol { get }

    func showTripDetail(_ id: UUID)
}
