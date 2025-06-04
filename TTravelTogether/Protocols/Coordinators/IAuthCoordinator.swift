import UIKit

protocol IAuthCoordinator: ICoordinator {

    var dependencies: IDependencyContainer { get }

    func onLoginSuccess(_ userData: LoginUserDataType)
    func goToRegistration()
}
