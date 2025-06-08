import Foundation

enum Network {
    static let BASE_URL = "http://141.105.71.181:8080"

    case register,
         login,
         createTrip,
         refresh,
         myTrips,
         tripDetail(Int),
         updateTrip,
         leaveTrip(Int),
         userProfile,
         getTransactions,
         createTransaction(Int),
         transactionDetail(Int),
         updateTransaction(Int),
         deleteTransaction(Int),
         remideDebtor(Int)

    var getQuery: String {
        switch self {
        case .register:
            "/api/v1/registration"
        case .login:
            "/api/v1/login"
        case .createTrip:
            "/api/v1/travels"
        case .refresh:
            "/api/v1/refresh"
        case .myTrips:
            "/api/v1/travels/active"
        case .tripDetail(let id):
            "/api/v1/travels/\(id)"
        case .updateTrip:
            "/api/v1/travels"
        case .leaveTrip(let id):
            "/api/v1/travels/leave/\(id)"
        case .userProfile:
            "/api/v1/profile"
        case .getTransactions:
            "/api/v1/transactions"
        case .createTransaction(let id):
            "/api/v1/transactions?travelId=\(id)"
        case .transactionDetail(let id):
            "/api/v1/transactions/\(id)"
        case .updateTransaction(let id):
            "/api/v1/transactions/\(id)"
        case .deleteTransaction(let id):
            "/api/v1/transactions/\(id)"
        case .remideDebtor(let transcationId):
            "/api/v1/transactions/remind/\(transcationId)"
        }
    }

    static func accessTokenSeq(for token: String) -> String {
        "Bearer " + token
    }
}
