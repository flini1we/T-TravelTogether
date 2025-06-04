import Foundation

extension Dictionary {

    static func refreshQuery(for token: String) -> [String: String] {
        ["refreshToken": token]
    }

    static func accessQuery(for token: String) -> [String: String] {
        ["Authorization": Network.accessTokenSeq(for: token)]
    }
}
