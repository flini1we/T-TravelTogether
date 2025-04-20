import Foundation
import Combine

final class RegistrationViewModel: Registratable {

    @Published var isFetchingRequest = false

    @Published var isPhoneValid = false
    @Published var isPasswordValid = false
    @Published var isPasswordConfirmed = false

    var isFetchingRequestPublisher: Published<Bool>.Publisher {
        $isFetchingRequest
    }
    var isPhoneValidPublisher: Published<Bool>.Publisher {
        $isPhoneValid
    }
    var isPasswordValidPublisher: Published<Bool>.Publisher {
        $isPasswordValid
    }
    var isPasswordConfirmedPublisher: Published<Bool>.Publisher {
        $isPasswordConfirmed
    }
    var isDataValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(
            $isPhoneValid,
            $isPasswordValid,
            $isPasswordConfirmed
        )
        .map { $0 && $1 && $2 }
        .eraseToAnyPublisher()
    }

    func register(completion: @escaping ((Result<String, Error>) -> Void)) {
        self.isFetchingRequest = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(.success("Valid"))
            self.isFetchingRequest = false
        }
    }

    func validatePhone(_ phone: String) -> Bool {
        let isValid = phone.range(
            of: RegularExpressions.russianPhoneNumber.expression,
            options: .regularExpression
        ) != nil
        isPhoneValid = isValid
        return isValid
    }

    func validatePassword(_ password: String) -> Bool {
        let isValid = password.range(
            of: RegularExpressions.password.expression,
            options: .regularExpression
        ) != nil
        isPasswordValid = isValid
        return isValid
    }

    func validatePasswordEquality(original password1: String?, confirmed password2: String) -> Bool {
        let isValid = isPasswordValid && (password1 ?? "") == password2
        isPasswordConfirmed = isValid
        return isValid
    }
}
