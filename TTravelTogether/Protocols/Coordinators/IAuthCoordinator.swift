import UIKit

protocol IAuthCoordinator: ICoordinator {

    var dependencies: IDependencyContainer { get }

    func onLoginSuccess(_ user: String)
    func goToRegistration()
}
