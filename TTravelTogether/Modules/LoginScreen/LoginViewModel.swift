import Foundation
import Combine

final class LoginViewModel: ObservableObject, ILoginViewModel {
    private var networkService: INetworkService

    @Published var isLoading: Bool = false

    var isLoadingPublisher: Published<Bool>.Publisher {
        $isLoading
    }

    init(networkService: INetworkService) {
        self.networkService = networkService
    }

    func login(
        userData: LoginUserDataType,
        completion: @escaping ((Result<LoginUserDataType, CustomError>) -> Void)
    ) {
        isLoading = true
        networkService.login(userData: validateLoginUserData(userData)) { result in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let failure):
                completion(.failure(failure.message.contains("401")
                                    ? .hiddenError(.AppStrings.Auth.wrongPhoneNumberOrPassword)
                                    : failure))
            }
        }
    }
}

private extension LoginViewModel {

    func validateLoginUserData(_ data: LoginUserDataType) -> LoginUserDataType {
        LoginUserDataType(
            RussianValidationService.shared.invalidate(
                phone: data.phoneNumber
            ), data.password)
    }
}
