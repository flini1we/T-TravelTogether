import UIKit

protocol AuthCoordinatorProtocol: Coordinator {

    var dependencies: DependencyContainerProtocol { get }
    var onLoginSuccess: ((String) -> Void)? { get set }
}
