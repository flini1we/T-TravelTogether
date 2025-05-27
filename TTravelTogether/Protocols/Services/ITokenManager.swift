import Foundation

protocol ITokenManager {

    func save(token: String, type: TokenType) -> Bool
    func getToken(type: TokenType) -> String?
    func deleteToken(type: TokenType) -> Bool
    func clearTokens() -> Bool
}
