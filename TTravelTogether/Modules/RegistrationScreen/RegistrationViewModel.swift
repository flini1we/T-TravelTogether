import Foundation
import Combine

final class RegistrationViewModel: IRegistrationViewModel {
    private var networkService: INetworkService

    @Published var isFetchingRequest = false

    @Published var isNameValid = false
    @Published var isLastNameValid: Bool = false
    @Published var isPhoneValid = false
    @Published var isPasswordValid = false
    @Published var isPasswordConfirmed = false

    var isUserNameValidPublisher: Published<Bool>.Publisher {
        $isNameValid
    }
    var isUserLastNameValidPublisher: Published<Bool>.Publisher {
        $isLastNameValid
    }
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
        Publishers.CombineLatest(
            Publishers.CombineLatest3($isNameValid, $isLastNameValid, $isPhoneValid),
            Publishers.CombineLatest($isPasswordValid, $isPasswordConfirmed)
        )
        .map { firstGroup, secondGroup in
            let (nameValid, lastNameValid, phoneValid) = firstGroup
            let (passwordValid, passwordConfirmed) = secondGroup
            return nameValid && lastNameValid && phoneValid && passwordValid && passwordConfirmed
        }
        .eraseToAnyPublisher()
    }

    init(networkService: INetworkService) {
        self.networkService = networkService
    }

    func register(user: UserDTO, completion: @escaping ((Result<String, CustomError>) -> Void)) {
        isFetchingRequest = true
        networkService.register(user: user) { result in
            switch result {
            case .success(let message):
                completion(.success(message))
            case .failure(let error):
                completion(error.message.contains("400")
                           ? .failure(.hiddenError(.AppStrings.Auth.alreadyExists))
                           : .failure(error)
                )
            }
        }
    }

    func validateName(_ name: String) -> Bool {
        let isValid = name.range(
            of: RegularExpressions.userData.expression,
            options: .regularExpression
        ) != nil
        isNameValid = isValid
        return isValid
    }

    func validateLastName(_ lastName: String) -> Bool {
        let isValid = lastName.range(
            of: RegularExpressions.userData.expression,
            options: .regularExpression
        ) != nil
        isLastNameValid = isValid
        return isValid
    }

    func validatePhone(_ phone: String) -> Bool {
        let isValid = phone.range(
            of: RegularExpressions.russianPhoneNumber.expression,
            options: .regularExpression
        ) != nil
        isPhoneValid = isValid
        return isValid
    }

    func getUserNameErorrMessage(_ name: String) -> String {
        guard !name.isEmpty else { return .AppStrings.Auth.invalidUserName }
        if !name.first!.isUppercase { return .AppStrings.Auth.invalidStartUserName }
        if !isNameValid { return .AppStrings.Auth.invalidUserNameSymbols }
        return ""
    }

    func getUserLastNameErorrMessage(_ lastName: String) -> String {
        guard !lastName.isEmpty else { return .AppStrings.Auth.invalidUserLastName }
        if !lastName.first!.isUppercase { return .AppStrings.Auth.invalidStartUserLastName }
        if !isLastNameValid { return .AppStrings.Auth.invalidUserLastNameSymbols  }
        return ""
    }

    func getPhoneErrorMessage(_ phone: String) -> String {
        let phone = phone.filter { $0.isNumber }
        if phone.starts(with: String.AppStrings.Auth.phonePrefix89) &&
           phone.count > 11 {
            return .AppStrings.Auth.invalidPhoneLenght
        }

        if phone.starts(with: String.AppStrings.Auth.phonePrefixPlus79) &&
           phone.count > 12 {
            return .AppStrings.Auth.invalidPhoneLenght
        }

        if !phone.starts(with: String.AppStrings.Auth.phonePrefix89) &&
           !phone.starts(with: String.AppStrings.Auth.phonePrefixPlus79) {
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
