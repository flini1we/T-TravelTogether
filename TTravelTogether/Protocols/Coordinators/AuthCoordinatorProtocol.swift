import UIKit

protocol AuthCoordinatorProtocol: Coordinator {

    var onLoginSuccess: ((String) -> Void)? { get set }

    func showRegistration()
}
