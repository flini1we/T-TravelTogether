import UIKit

protocol IMainCoordinator: ICoordinator {

    var dependencies: DependencyContainerProtocol { get }
    var registratedUser: User! { get }

    func showTripDetail(for id: UUID)
    func showContactList()
}
