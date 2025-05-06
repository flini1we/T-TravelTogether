import UIKit

protocol IMainCoordinator: ICoordinator {

    var dependencies: DependencyContainerProtocol { get }
    var registratedUser: User! { get }

    func showTripDetail(_ id: UUID)
    func showContactList()
}
