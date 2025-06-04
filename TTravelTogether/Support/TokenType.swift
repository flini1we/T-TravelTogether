import Foundation

enum TokenType {

    case access, refresh

    var getKey: String {
        switch self {
        case .access:
            return .AppStrings.KeyChain.accessId
        case .refresh:
            return .AppStrings.KeyChain.refreshId
        }
    }
}
