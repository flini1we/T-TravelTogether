import Foundation

enum Network {
    static let BASE_URL = "http://141.105.71.181:8080"

    case register, login

    var getQuery: String {
        switch self {
        case .register:
            "/api/v1/registration"
        case .login:
            "/api/v1/login"
        }
    }
}
