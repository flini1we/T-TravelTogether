import Foundation
import Combine

final class RegistrationViewModel: IRegistrationViewModel {

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

    func getPhoneErrorMessage(_ phone: String) -> String {
        guard !isPhoneValid else { return "" }

        if phone.starts(with: String.AppStrings.Auth.phonePrefix89) && phone.count > 11 {
            return .AppStrings.Auth.invalidPhoneLenght
        } else if phone.starts(with: String.AppStrings.Auth.phonePrefixPlus79) && phone.count > 12 {
            return .AppStrings.Auth.invalidPhoneLenght
        } else if !phone.starts(with: String.AppStrings.Auth.phonePrefix89) || !phone.starts(with: String.AppStrings.Auth.phonePrefixPlus79) {
            return .AppStrings.Auth.invalidPhoneStartsWith
        }
        return ""
    }

    func validatePassword(_ password: String) -> Bool {
        let isValid = password.range(
            of: RegularExpressions.password.expression,
            options: .regularExpression
        ) != nil
        isPasswordValid = isValid
        return isValid
    }

    func getPasswordErrorMessage(_ password: String) -> String {
        guard !isPasswordValid else { return "" }

        if password.count < .AppIntegers.passwordMinLength {
            return .AppStrings.Auth.invalidPasswordLengthMin
        } else if password.count > .AppIntegers.passwordMaxLength {
            return .AppStrings.Auth.invalidPasswordLengthMax
        } else if !password.contains(where: { $0.isUppercase }) ||
                  !password.contains(where: { $0.isNumber }) {
            return .AppStrings.Auth.invalidPasswordData
        }
        return ""
    }

    func validatePasswordEquality(original password1: String?, confirmed password2: String) -> Bool {
        let isValid = isPasswordValid && (password1 ?? "") == password2
        isPasswordConfirmed = isValid
        return isValid
    }

    func getConfirmedPasswordErrorMessage() -> String {
        return !isPasswordConfirmed ? .AppStrings.Auth.invalidPasswordConfirmed : ""
    }
}
