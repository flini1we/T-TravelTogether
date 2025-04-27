import UIKit

protocol MainCoordinatorProtocol: Coordinator {

    var factory: ModuleFactoryProtocol { get set }

    func showTripDetail(tripId: UUID)
}
