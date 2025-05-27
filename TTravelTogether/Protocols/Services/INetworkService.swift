import Foundation

protocol INetworkService {

    func register(
        user: UserDTO,
        completion: @escaping (Result<String, CustomError>) -> Void
    )
    func login(
        userData: LoginUserDataType,
        completion: @escaping ((Result<LoginUserDataType, CustomError>) -> Void)
    )
}
