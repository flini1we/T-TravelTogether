import Foundation

enum KeychainError: Error {

    case duplicateEntry
    case unknown(OSStatus)
    case updateTokensError
    case itemNotFound
    case invalidData
    case encodingFailed

    var localizedDescription: String {
        switch self {
        case .duplicateEntry:
            return "The item already exists in the Keychain."
        case .unknown(let status):
            return "Unknown Keychain error (OSStatus: \(status))"
        case .updateTokensError:
            return "Failed to update tokens in Keychain."
        case .itemNotFound:
            return "The specified item could not be found in Keychain."
        case .invalidData:
            return "Invalid token data format."
        case .encodingFailed:
            return "Failed to encode data for Keychain storage."
        }
    }
}
