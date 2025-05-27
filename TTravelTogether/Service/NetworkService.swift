import UIKit
import Alamofire

final class NetworkService: INetworkService {
    private var tokenManager: ITokenManager

    private lazy var jsonDecoder: JSONDecoder = { JSONDecoder() }()
    private lazy var jsonEncoder: JSONEncoder = { JSONEncoder() }()

    init(tokenManager: ITokenManager) {
        self.tokenManager = tokenManager
    }

    func register(
        user: UserDTO,
        completion: @escaping (Result<String, CustomError>) -> Void
    ) {
        let parameters: [String: String] = [
            "phoneNumber": user.phoneNumber,
            "firstName": user.name,
            "lastName": user.lastName,
            "password": user.password,
            "confirmPassword": user.passwordConfirmation
        ]
        AF.request(
            Network.BASE_URL + Network.register.getQuery,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default
        )
        .validate()
        .responseString { response in
            switch response.result {
            case .success(let message):
                completion(.success(message))
            case .failure(_):
                completion(.failure(self.decodeToCustomError(response: response)))
            }
        }
    }

    func login(
        userData: LoginUserDataType,
        completion: @escaping ((Result<LoginUserDataType, CustomError>) -> Void)
    ) {
        let parameters: [String: String] = [
            "phoneNumber": userData.phoneNumber,
            "password": userData.password
        ]
        AF.request(
            Network.BASE_URL + Network.login.getQuery,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default
        )
        .validate()
        .responseString { response in
            switch response.result {
            case .success(let responseString):
                if let responceData = responseString.data(using: .utf8),
                   let tokenData = try? self.jsonDecoder.decode(TokenResponseData.self, from: responceData) {

                    if self.tokenManager.save(token: tokenData.accessToken, type: .access) &&
                       self.tokenManager.save(token: tokenData.refreshToken, type: .refresh) {
                        completion(.success(userData))
                    } else {
                        completion(
                            .failure(
                                CustomError(
                                    message: KeychainError.updateTokensError.localizedDescription
                                )
                            )
                        )
                    }
                } else {
                    completion(.failure(.errorToDecodeTokens()))
                }
            case .failure(let error):
                completion(.failure(CustomError(message: error.localizedDescription)))
            }
        }
    }
}

private extension NetworkService {

    func decodeToCustomError(response: AFDataResponse<String>) -> CustomError {
        if let data = response.data,
           let errorResponse = try? self.jsonDecoder.decode(CustomError.self, from: data) {
            return errorResponse
        } else {
            return .hiddenError(.AppStrings.Errors.hiddenMessage)
        }
    }
}
