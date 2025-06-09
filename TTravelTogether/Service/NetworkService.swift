import UIKit
import Alamofire

//swiftlint:disable:next type_body_length
final class NetworkService: INetworkService {
    private var tokenManager: ITokenManager

    private lazy var jsonDecoder: JSONDecoder = { JSONDecoder() }()
    private lazy var jsonEncoder: JSONEncoder = { JSONEncoder() }()

    init(tokenManager: ITokenManager) { self.tokenManager = tokenManager }

    func register(
        user: UserDTO,
        completion: @escaping (Result<String, CustomError>) -> Void
    ) {
        let parameters: [String: String] = user.convertToRegisterParams()
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
            case .failure(let error):
                completion(.failure(.hiddenError(error.localizedDescription)))
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
        guard let tokens = checkTokens()
        else {
            completion(.failure(.accessTokenIsNil()))
            return
        }
        let params: [String: Any] = tripDetail.convertToParams()
        AF.request(
            Network.BASE_URL + Network.createTrip.getQuery,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: .getAccessHeader(for: tokens.access)
        )
        .validate()
        .response { [weak self] response in
            guard let self else { return }
            switch response.result {
            case .success(_):
                completion(.success(tripDetail))
            case .failure(let error):
                if isUnauthorized(response.response?.statusCode) {
                    refreshTokens(refreshToken: tokens.refresh) { [weak self] response in
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
        guard let tokens = checkTokens()
        else {
            completion(.failure(.accessTokenIsNil()))
            return
        }
        AF.request(
            Network.BASE_URL + Network.myTrips.getQuery,
            method: .get,
            encoding: JSONEncoding.default,
            headers: .getAccessHeader(for: tokens.access)
        )
        .validate()
        .responseDecodable(of: [TripDTO].self) { [weak self] response in
            guard let self else { return }
            switch response.result {
            case .success(let tripsDTO):
                completion(.success(tripsDTO))
            case .failure(let error):
                if isUnauthorized(response.response?.statusCode) {
                    refreshTokens(refreshToken: tokens.refresh) { [weak self] response in
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
        guard let tokens = checkTokens()
        else {
            completion(.failure(.accessTokenIsNil()))
            return
        }
        AF.request(
            Network.BASE_URL + Network.tripDetail(id).getQuery,
            method: .get,
            encoding: JSONEncoding.default,
            headers: .getAccessHeader(for: tokens.access)
        )
        .validate()
        .responseDecodable(of: TripDetailDTO.self) { [weak self] result in
            guard let self else { return }
            switch result.result {
            case .success(let tripDetailDTO):
                completion(.success(tripDetailDTO))
            case .failure(let error):
                if isUnauthorized(result.response?.statusCode) {
                    refreshTokens(refreshToken: tokens.refresh) { [weak self] result in
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
        guard let tokens = checkTokens()
        else {
            completion(.failure(.accessTokenIsNil()))
            return
        }
        let params: [String: Any] = tripDetail.convertToParams()
        AF.request(
            Network.BASE_URL + Network.updateTrip.getQuery,
            method: .put,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: .getAccessHeader(for: tokens.access)
        )
        .validate()
        .responseDecodable(of: EditTripDTO.self) { [weak self] response in
            guard let self else { return }
            switch response.result {
            case .success(let tripDetailDTO):
                completion(.success(tripDetailDTO))
            case .failure(let error):
                if isUnauthorized(response.response?.statusCode) {
                    refreshTokens(refreshToken: tokens.refresh) { [weak self] result in
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
        guard let tokens = checkTokens()
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
            headers: .getAccessHeader(for: tokens.access)
        )
        .validate()
        .response { [weak self] resul in
            guard let self else { return }
            switch resul.result {
            case .success(let data):
                completion(.success(()))
            case .failure(let error):
                if isUnauthorized(resul.response?.statusCode) {
                    refreshTokens(refreshToken: tokens.refresh) { [weak self] result in
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

    func getUserProfile(
        completion: @escaping ((Result<User, CustomError>) -> Void)
    ) {
        guard let tokens = checkTokens()
        else {
            completion(.failure(.accessTokenIsNil()))
            return
        }
        AF.request(
            Network.BASE_URL + Network.userProfile.getQuery,
            method: .get,
            encoding: JSONEncoding.default,
            headers: .getAccessHeader(for: tokens.access)
        )
        .validate()
        .responseDecodable(of: User.self) { [weak self] result in
            guard let self else { return }
            switch result.result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                if isUnauthorized(result.response?.statusCode) {
                    refreshTokens(refreshToken: tokens.refresh) { [weak self] result in
                        switch result {
                        case .success(_):
                            self?.getUserProfile(completion: completion)
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

    func getTransactions(
        tripId: Int,
        completion: @escaping ((Result<[TransactionDTO], CustomError>) -> Void)
    ) {
        guard let tokens = checkTokens()
        else {
            completion(.failure(.accessTokenIsNil()))
            return
        }
        let params: [String: Any] = [
            .AppStrings.Network.tripIdRequestParam: tripId
        ]
        AF.request(
            Network.BASE_URL + Network.getTransactions.getQuery,
            method: .get,
            parameters: params,
            headers: .getAccessHeader(for: tokens.access)
        )
        .validate()
        .responseDecodable(of: [TransactionDTO].self) { [weak self] result in
            guard let self else { return }
            switch result.result {
            case .success(let transactionsDTO):
                completion(.success(transactionsDTO))
            case .failure(let error):
                guard let statusCode = result.response?.statusCode else {
                    completion(.failure(.hiddenError(error.localizedDescription)))
                    return
                }
                if statusCode.isCode(.unauthorized) {
                    refreshTokens(refreshToken: tokens.refresh) { [weak self] result in
                        switch result {
                        case .success(_):
                            self?.getTransactions(tripId: tripId, completion: completion)
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

    func createTransaction(
        travelId: Int,
        createdTransaction: CreatedTransactionDTO,
        completion: @escaping ((Result<Void, CustomError>) -> Void)
    ) {
        guard let tokens = checkTokens()
        else {
            completion(.failure(.accessTokenIsNil()))
            return
        }
        let participantsDicts = createdTransaction.participants
            .map { participant -> [String: Any] in
                [
                    "phoneNumber": participant.phoneNumber,
                    "shareAmount": participant.shareAmount
                ]
            }
        let params: [String: Any] = [
            "category": createdTransaction.category,
            "totalCost": createdTransaction.price,
            "description": createdTransaction.description,
            "createdAt": createdTransaction.createdAt,
            "participant": participantsDicts
        ]
        AF.request(
            Network.BASE_URL + Network.createTransaction(travelId).getQuery,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: .getAccessHeader(for: tokens.access)
        )
        .validate()
        .response { [weak self] result in
            guard let self else { return }
            switch result.result {
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                if isUnauthorized(result.response?.statusCode) {
                    refreshTokens(refreshToken: tokens.refresh) { [weak self] result in
                        switch result {
                        case .success(_):
                            self?.createTransaction(
                                travelId: travelId,
                                createdTransaction: createdTransaction,
                                completion: completion
                            )
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    if let data = result.data {
                        do {
                            let errorDTO = try JSONDecoder().decode(ErrorDTO.self, from: data)
                            print(errorDTO)
                            completion(.failure(.hiddenError(errorDTO.message)))
                        } catch {
                            if let rawResponse = String(data: data, encoding: .utf8) {
                                completion(.failure(.hiddenError(rawResponse)))
                            } else {
                                completion(.failure(.hiddenError(error.localizedDescription)))
                            }
                        }
                    } else {
                        completion(.failure(.hiddenError(error.localizedDescription)))
                    }
                }
            }
        }
    }

    func getTransactionDetail(
        transactionId id: Int,
        completion: @escaping ((Result<TransactionDetailDTO, CustomError>) -> Void)
    ) {
        guard let tokens = checkTokens()
        else {
            completion(.failure(.accessTokenIsNil()))
            return
        }
        AF.request(
            Network.BASE_URL + Network.transactionDetail(id).getQuery,
            method: .get,
            encoding: JSONEncoding.default,
            headers: .getAccessHeader(for: tokens.access)
        )
        .validate()
        .responseDecodable(of: TransactionDetailDTO.self) { [weak self] result in
            guard let self else { return }
            switch result.result {
            case .success(let transactionDetailDTO):
                completion(.success(transactionDetailDTO))
            case .failure(let error):
                if isUnauthorized(result.response?.statusCode) {
                    refreshTokens(refreshToken: tokens.refresh) { [weak self] result in
                        switch result {
                        case .success(_):
                            self?.getTransactionDetail(transactionId: id, completion: completion)
                        case .failure(let error):
                            completion(.failure(.hiddenError(error.localizedDescription)))
                        }
                    }
                } else {
                    completion(.failure(.hiddenError(error.localizedDescription)))
                }
            }
        }
    }

    func updateTransaction(
        transactionDetailDTO: TransactionDetailDTO,
        completion: @escaping ((Result<Void, CustomError>) -> Void)
    ) {
        guard let tokens = checkTokens()
        else {
            completion(.failure(.accessTokenIsNil()))
            return
        }
        let participantsDicts = transactionDetailDTO.participants
            .map { participant -> [String: Any] in
                [
                    "phoneNumber": participant.phoneNumber,
                    "shareAmount": participant.shareAmount
                ]
            }
        let params: [String: Any] = [
            "totalCost": transactionDetailDTO.price,
            "description": transactionDetailDTO.description,
            "category": transactionDetailDTO.category,
            "participant": participantsDicts
        ]
        AF.request(
            Network.BASE_URL + Network.updateTransaction(transactionDetailDTO.id).getQuery,
            method: .put,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: .getAccessHeader(for: tokens.access)
        )
        .validate()
        .response { [weak self] result in
            guard let self else { return }
            switch result.result {
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                if isUnauthorized(result.response?.statusCode) {
                    refreshTokens(refreshToken: tokens.refresh) { [weak self] result in
                        switch result {
                        case .success(_):
                            self?.updateTransaction(
                                transactionDetailDTO: transactionDetailDTO,
                                completion: completion
                            )
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    if let data = result.data {
                        do {
                            let errorDTO = try JSONDecoder().decode(ErrorDTO.self, from: data)
                            completion(.failure(.hiddenError(errorDTO.message)))
                        } catch {
                            if let rawResponse = String(data: data, encoding: .utf8) {
                                completion(.failure(.hiddenError(rawResponse)))
                            } else {
                                completion(.failure(.hiddenError(error.localizedDescription)))
                            }
                        }
                    } else {
                        completion(.failure(.hiddenError(error.localizedDescription)))
                    }
                }
            }
        }
    }

    func deleteTransaction(
        id: Int,
        completion: @escaping ((Result<Void, CustomError>) -> Void)
    ) {
        guard let tokens = checkTokens()
        else {
            completion(.failure(.accessTokenIsNil()))
            return
        }
        AF.request(
            Network.BASE_URL + Network.deleteTransaction(id).getQuery,
            method: .delete,
            headers: .getAccessHeader(for: tokens.access)
        )
        .validate()
        .response { [weak self] result in
            guard let self else { return }
            switch result.result {
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                if isUnauthorized(result.response?.statusCode) {
                    refreshTokens(refreshToken: tokens.refresh) { [weak self] result in
                        switch result {
                        case .success(_):
                            self?.deleteTransaction(id: id, completion: completion)
                        case .failure(let error):
                            completion(.failure(.hiddenError(error.localizedDescription)))
                        }
                    }
                } else {
                    if let data = result.data {
                        do {
                            let errorDTO = try JSONDecoder().decode(ErrorDTO.self, from: data)
                            completion(.failure(.hiddenError(errorDTO.message)))
                        } catch {
                            if let rawResponse = String(data: data, encoding: .utf8) {
                                completion(.failure(.hiddenError(rawResponse)))
                            } else {
                                completion(.failure(.hiddenError(error.localizedDescription)))
                            }
                        }
                    } else {
                        completion(.failure(.hiddenError(error.localizedDescription)))
                    }
                }
            }
        }
    }

    func remindDebtors(
        transactionId: Int,
        completion: @escaping ((Result<Void, CustomError>) -> Void)
    ) {
        guard let tokens = checkTokens()
        else {
            completion(.failure(.accessTokenIsNil()))
            return
        }
        AF.request(
            Network.BASE_URL + Network.remideDebtor(transactionId).getQuery,
            method: .get,
            headers: .getAccessHeader(for: tokens.access)
        )
        .validate()
        .response { [weak self] result in
            guard let self else { return }
            switch result.result {
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                if isUnauthorized(result.response?.statusCode) {
                    refreshTokens(refreshToken: tokens.refresh) { [weak self] result in
                        switch result {
                        case .success(_):
                            self?.remindDebtors(transactionId: transactionId, completion: completion)
                        case .failure(let error):
                            completion(.failure(.hiddenError(error.localizedDescription)))
                        }
                    }
                } else {
                    completion(.failure(.hiddenError(error.localizedDescription)))
                }
            }
        }
    }

    func deleteTrip(
        tripId: Int,
        completion: @escaping ((Result<Void, CustomError>) -> Void)
    ) {
        guard let tokens = checkTokens()
        else {
            completion(.failure(.accessTokenIsNil()))
            return
        }
        AF.request(
            Network.BASE_URL + Network.deleteTrip(tripId).getQuery,
            method: .delete,
            headers: .getAccessHeader(for: tokens.access)
        )
        .validate()
        .response { [weak self] result in
            guard let self else { return }
            switch result.result {
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                if isUnauthorized(result.response?.statusCode) {
                    refreshTokens(refreshToken: tokens.refresh) { [weak self] result in
                        switch result {
                        case .success(_):
                            self?.deleteTrip(tripId: tripId, completion: completion)
                        case .failure(let failure):
                            completion(.failure(failure))
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

    func checkTokens() -> (access: String, refresh: String)? {
        guard
            let accessToken = tokenManager.getToken(type: .access),
            let refreshToken = tokenManager.getToken(type: .refresh)
        else {
            return nil
        }
        return (accessToken, refreshToken)
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
