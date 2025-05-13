import UIKit

final class UserService {

    static let shared = UserService()
    private init() { }

    private let userDefaults = UserDefaults.standard
    private let userKey: String = .AppStrings.UserDefaults.originUserKey
    private lazy var jsonDecoder: JSONDecoder = { JSONDecoder() }()
    private lazy var jsonEncoder: JSONEncoder = { JSONEncoder() }()

    var currentUser: User? {
        get {
            guard let data = userDefaults.data(forKey: .AppStrings.UserDefaults.originUserKey) else { return nil }
            return try? jsonDecoder.decode(User.self, from: data)
        }
        set {
            if let user = newValue, let data = try? jsonEncoder.encode(user) {
                userDefaults.set(data, forKey: .AppStrings.UserDefaults.originUserKey)
            } else {
                userDefaults.removeObject(forKey: userKey)
            }
        }
    }

    var isAuthenticated: Bool {
        currentUser != nil
    }

    func login(_ user: User) {
        currentUser = user
    }

    func logout() {
        currentUser = nil
    }
}
