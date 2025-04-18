import UIKit

protocol AuthFlowCoordinatorProtocol: AnyObject {

    var navigationController: UINavigationController { get set }
    var moduleFactory: ModuleFactoryProtocol { get }

    func start()
    func showLogin(user: String?)
    func showRegistration()
    func finishAuthFlow()
}
