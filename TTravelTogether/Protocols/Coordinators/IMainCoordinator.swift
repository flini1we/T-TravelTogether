import UIKit

protocol IMainCoordinator: ICoordinator {

    var dependencies: IDependencyContainer { get }

    func showTripDetail(_ id: UUID)
    func showContactList()
    func showEditTripScreen(for tripDetail: TripDetail)
}
