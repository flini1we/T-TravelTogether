import UIKit
import Combine

protocol Registratable: AnyObject {

    var isFetchingRequestPublisher: Published<Bool>.Publisher { get }
    var isPhoneValidPublisher: Published<Bool>.Publisher { get }
    var isPasswordValidPublisher: Published<Bool>.Publisher { get }
    var isPasswordConfirmedPublisher: Published<Bool>.Publisher { get }

    var isFetchingRequest: Bool { get set }
    var isPhoneValid: Bool { get set }
    var isPasswordValid: Bool { get set }
    var isPasswordConfirmed: Bool { get set }

    var isDataValid: AnyPublisher<Bool, Never> { get }

    func register(completion: @escaping ((Result<String, Error>) -> Void))
    func validatePhone(_ phone: String) -> Bool
    func validatePassword(_ password: String) -> Bool
    func validatePasswordEquality(original password1: String?, confirmed password2: String) -> Bool

    func getPhoneErrorMessage(_ phone: String) -> String
    func getPasswordErrorMessage(_ password: String) -> String
    func getConfirmedPasswordErrorMessage() -> String
}
