import Foundation
import Combine

final class RegistrationViewModel {

    @Published var isFetchingRequest = false

    @Published var isPhoneValid = false
    @Published var isPasswordValid = false
    @Published var isPasswordConfirmed = false

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
        return phone.range(of: RegularExpressions.russianPhoneNumber.expression, options: .regularExpression) != nil
    }

    func validatePassword(_ password: String) -> Bool {
        password.range(of: RegularExpressions.password.expression, options: .regularExpression) != nil
    }

    func validatePasswordEquality(original password1: String?, confirmed password2: String) -> Bool {
        self.isPasswordValid && (password1 ?? "") == password2
    }
}
