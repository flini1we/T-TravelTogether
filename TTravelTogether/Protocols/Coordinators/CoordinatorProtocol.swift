import UIKit

protocol CoordinatorProtocol: AnyObject {

    var navigationController: UINavigationController { get set }
    var moduleFactory: ModuleFactoryProtocol { get }

    func start()
    func showLogin(user: String?)
    func showRegistration()
    func showMainTabBar()
    func showTripDetail(_ tripId: UUID)
    func finish()
}
