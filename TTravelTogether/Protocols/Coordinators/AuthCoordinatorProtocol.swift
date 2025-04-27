import UIKit

protocol AuthCoordinatorProtocol: Coordinator {

    var onLoginSuccess: ((String) -> Void)? { get set }
    var factory: ModuleFactoryProtocol { get set }

    func showRegistration()
}
