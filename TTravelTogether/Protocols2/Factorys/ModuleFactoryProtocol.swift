import UIKit

protocol ModuleFactoryProtocol {

    func makeLoginModule() -> UIViewController
    func makeRegistrationModule() -> UIViewController
}
