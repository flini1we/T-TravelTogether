import Foundation

final class TokenManager: ITokenManager {

    private let service: String

    init(service: String = Bundle.main.bundleIdentifier ?? .AppStrings.KeyChain.storage) {
        self.service = service
    }

    func save(token: String, type: TokenType) -> Bool {
        guard let data = token.data(using: .utf8) else { return false }
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: type.getKey,
            kSecValueData: data,
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked
        ]

        SecItemDelete(query as CFDictionary)
        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }

    func getToken(type: TokenType) -> String? {
        let query: [CFString: Any] = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: service,
                kSecAttrAccount: type.getKey,
                kSecReturnData: kCFBooleanTrue!,
                kSecMatchLimit: kSecMatchLimitOne
            ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    func deleteToken(type: TokenType) -> Bool {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: type.getKey
        ]

        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }

    func clearTokens() -> Bool {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service
        ]

        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}
