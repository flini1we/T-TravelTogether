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
        .responseString { [weak self] response in
            guard let self else { return }
            switch response.result {
            case .success(let message):
                completion(.success(message))
            case .failure(_):
                completion(.failure(decodeToCustomError(response: response)))
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
        .responseDecodable(of: TokenResponseData.self) { [weak self] response in
            guard let self else { return }
            switch response.result {
            case .success(let responseData):
                if tokenManager.save(token: responseData.accessToken, type: .access) &&
                   tokenManager.save(token: responseData.refreshToken, type: .refresh) {
                    completion(.success(userData))
                } else {
                    completion(
                        .failure(CustomError(message: KeychainError.updateTokensError.localizedDescription))
                    )
                }
            case .failure(let error):
                completion(.failure(CustomError(message: error.localizedDescription)))
            }
        }
    }

    func createTrip(
        tripDetail: CreateTripDTO,
        completion: @escaping ((Result<CreateTripDTO, CustomError>) -> Void)
    ) {
        guard
            let accessToken = tokenManager.getToken(type: .access),
            let refreshToken = tokenManager.getToken(type: .refresh)
        else {
            completion(.failure(.accessTokenIsNil()))
            return
        }
        let params: [String: Any] = [
            "name": tripDetail.title,
            "totalBudget": tripDetail.price,
            "dateOfBegin": tripDetail.start,
            "dateOfEnd": tripDetail.end,
            "participantPhones": tripDetail.participants
        ]
        AF.request(
            Network.BASE_URL + Network.createTrip.getQuery,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: .getAccessHeader(for: accessToken)
        )
        .validate()
        .response { [weak self] response in
            guard let self else { return }
            switch response.result {
            case .success(_):
                completion(.success(tripDetail))
            case .failure(let error):
                if isUnauthorized(response.response?.statusCode) {
                    refreshTokens(refreshToken: refreshToken) { [weak self] response in
                        switch response {
                        case .success(_):
                            self?.createTrip(tripDetail: tripDetail, completion: completion)
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    completion(.failure(.hiddenError(error.localizedDescription)))
                }
            }
        }
    }

    func getActiveTrips(completion: @escaping ((Result<[TripDTO], CustomError>) -> Void)) {
        guard
            let accessToken = tokenManager.getToken(type: .access),
            let refreshToken = tokenManager.getToken(type: .refresh)
        else {
            completion(.failure(.accessTokenIsNil()))
            return
        }
        AF.request(
            Network.BASE_URL + Network.myTrips.getQuery,
            method: .get,
            encoding: JSONEncoding.default,
            headers: .getAccessHeader(for: accessToken)
        )
        .validate()
        .responseDecodable(of: [TripDTO].self) { [weak self] response in
            guard let self else { return }
            switch response.result {
            case .success(let tripsDTO):
                completion(.success(tripsDTO))
            case .failure(let error):
                if isUnauthorized(response.response?.statusCode) {
                    refreshTokens(refreshToken: refreshToken) { [weak self] response in
                        switch response {
                        case .success(_):
                            self?.getActiveTrips(completion: completion)
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    completion(.failure(.hiddenError(error.localizedDescription)))
                }
            }
        }
    }

    func getTripDetail(
        id: Int,
        completion: @escaping ((Result<TripDetailDTO, CustomError>) -> Void)
    ) {
        guard
            let accessToken = tokenManager.getToken(type: .access),
            let refreshToken = tokenManager.getToken(type: .refresh)
        else {
            completion(.failure(.accessTokenIsNil()))
            return
        }
        AF.request(
            Network.BASE_URL + Network.tripDetail(id).getQuery,
            method: .get,
            encoding: JSONEncoding.default,
            headers: .getAccessHeader(for: accessToken)
        )
        .validate()
        .responseDecodable(of: TripDetailDTO.self) { [weak self] result in
            guard let self else { return }
            switch result.result {
            case .success(let tripDetailDTO):
                completion(.success(tripDetailDTO))
            case .failure(let error):
                if isUnauthorized(result.response?.statusCode) {
                    refreshTokens(refreshToken: refreshToken) { [weak self] result in
                        switch result {
                        case .success(_):
                            self?.getTripDetail(id: id, completion: completion)
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    completion(.failure(.hiddenError(error.localizedDescription)))
                }
            }
        }
    }

    func updateTrip(
        tripDetail: EditTripDTO,
        completion: @escaping ((Result<EditTripDTO, CustomError>) -> Void)
    ) {
        guard
            let accessToken = tokenManager.getToken(type: .access),
            let refreshToken = tokenManager.getToken(type: .refresh)
        else {
            completion(.failure(.accessTokenIsNil()))
            return
        }
        let params: [String: Any] = [
            "id": tripDetail.id,
            "name": tripDetail.title,
            "totalBudget": tripDetail.price,
            "dateOfBegin": tripDetail.start,
            "dateOfEnd": tripDetail.end,
            "participantPhones": tripDetail.members.compactMap({
                RussianValidationService.shared.invalidate(phone: $0.phoneNumber)
            })
        ]
        AF.request(
            Network.BASE_URL + Network.updateTrip.getQuery,
            method: .put,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: .getAccessHeader(for: accessToken)
        )
        .validate()
        .responseDecodable(of: EditTripDTO.self) { [weak self] response in
            guard let self else { return }
            switch response.result {
            case .success(let tripDetailDTO):
                completion(.success(tripDetailDTO))
            case .failure(let error):
                if isUnauthorized(response.response?.statusCode) {
                    refreshTokens(refreshToken: refreshToken) { [weak self] result in
                        switch result {
                        case .success(_):
                            self?.updateTrip(tripDetail: tripDetail, completion: completion)
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    completion(.failure(.hiddenError(error.localizedDescription)))
                }
            }
        }
    }

    func leaveTrip(
        with id: Int,
        completion: @escaping ((Result<Void, CustomError>) -> Void)
    ) {
        guard
            let accessToken = tokenManager.getToken(type: .access),
            let refreshToken = tokenManager.getToken(type: .refresh)
        else {
            completion(.failure(.accessTokenIsNil()))
            return
        }
        let params: [String: Any] = [
            .AppStrings.Network.tripIdRequestParam: id
        ]
        AF.request(
            Network.BASE_URL + Network.leaveTrip(id).getQuery,
            method: .delete,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: .getAccessHeader(for: accessToken)
        )
        .validate()
        .response { [weak self] resul in
            guard let self else { return }
            switch resul.result {
            case .success(let data):
                completion(.success(()))
            case .failure(let error):
                if isUnauthorized(resul.response?.statusCode) {
                    refreshTokens(refreshToken: refreshToken) { [weak self] result in
                        switch result {
                        case .success(_):
                            self?.leaveTrip(with: id, completion: completion)
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    completion(.failure(.hiddenError(error.localizedDescription)))
                }
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

    func refreshTokens(
        refreshToken: String,
        completion: @escaping ((Result<TokenResponseData, CustomError>) -> Void)
    ) {
        AF.upload(
            multipartFormData: { multipart in
                if let tokenData = refreshToken.data(using: .utf8) {
                    multipart.append(tokenData, withName: .AppStrings.KeyChain.refreshTokenHeader)
                }
            },
            to: Network.BASE_URL + Network.refresh.getQuery,
            method: .post
        )
        .validate()
        .responseDecodable(of: TokenResponseData.self) { [weak self] response in
            guard let self else { return }
            switch response.result {
            case .success(let tokens):
                if tokenManager.save(token: tokens.accessToken, type: .access) &&
                   tokenManager.save(token: tokens.refreshToken, type: .refresh) {
                    completion(.success(tokens))
                } else {
                    completion(.failure(.errorToSaveTokens()))
                }
            case .failure(let error):
                completion(.failure(.hiddenError(error.localizedDescription)))
            }
        }
    }

    func isUnauthorized(_ statusCode: Int?) -> Bool {
        guard let statusCode else { return false }
        return statusCode == StatusCodes.unauthorized.rawValue
    }
}
