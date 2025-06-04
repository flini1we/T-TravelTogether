import UIKit
import Combine

protocol IRegistrationViewModel: AnyObject {

    var isFetchingRequestPublisher: Published<Bool>.Publisher { get }
    var isUserNameValidPublisher: Published<Bool>.Publisher { get }
    var isUserLastNameValidPublisher: Published<Bool>.Publisher { get }
    var isPhoneValidPublisher: Published<Bool>.Publisher { get }
    var isPasswordValidPublisher: Published<Bool>.Publisher { get }
    var isPasswordConfirmedPublisher: Published<Bool>.Publisher { get }

    var isFetchingRequest: Bool { get set }
    var isNameValid: Bool { get set }
    var isLastNameValid: Bool { get set }
    var isPhoneValid: Bool { get set }
    var isPasswordValid: Bool { get set }
    var isPasswordConfirmed: Bool { get set }

    var isDataValid: AnyPublisher<Bool, Never> { get }

    func register(user: UserDTO, completion: @escaping ((Result<String, CustomError>) -> Void))
    func validateName(_ name: String) -> Bool
    func validateLastName(_ lastName: String) -> Bool
    func validatePhone(_ phone: String) -> Bool
    func validatePassword(_ password: String) -> Bool
    func validatePasswordEquality(original password1: String?, confirmed password2: String) -> Bool

    func getUserNameErorrMessage(_ name: String) -> String
    func getUserLastNameErorrMessage(_ lastName: String) -> String
    func getPhoneErrorMessage(_ phone: String) -> String
    func getPasswordErrorMessage(_ password: String) -> String
    func getConfirmedPasswordErrorMessage() -> String
}
