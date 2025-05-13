import UIKit

protocol IAuthCoordinator: ICoordinator {

    var dependencies: DependencyContainerProtocol { get }

    func onLoginSuccess(_ user: String)
    func goToRegistration()
}
