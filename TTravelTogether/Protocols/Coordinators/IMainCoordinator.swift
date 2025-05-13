import UIKit

protocol IMainCoordinator: ICoordinator {

    var dependencies: IDependencyContainer { get }

    func showTripDetail(_ id: UUID)
    func showContactList()
}
