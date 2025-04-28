import UIKit

protocol MainCoordinatorProtocol: Coordinator {

    var dependencies: DependencyContainerProtocol { get }

    func showTripDetail(tripId: UUID)
}
