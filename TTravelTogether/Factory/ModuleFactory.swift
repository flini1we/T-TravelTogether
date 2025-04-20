import UIKit

struct ModuleFactory: ModuleFactoryProtocol {
    func makeLoginModule() -> UIViewController {
        getModule(.login)
    }

    func makeRegistrationModule() -> UIViewController {
        getModule(.register)
    }
}

private extension ModuleFactory {

    func getModule(_ type: ModuleTypes) -> UIViewController {
        switch type {
        case .login:
            let loginViewModel: Loginable = LoginViewModel()
            let loginController = LoginController(viewModel: loginViewModel)
            return loginController
        case .register:
            let rigistrationViewModel = RegistrationViewModel()
            let registrationController = RegistrationController(viewModel: rigistrationViewModel)
            return registrationController
        }
    }
}
