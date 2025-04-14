import Foundation
import Combine

final class LoginViewModel {

    @Published var isLoading: Bool = false

    func login(phoneNumber: String, password: String, completion: @escaping (() -> Void)) {
        guard !phoneNumber.isEmpty, !password.isEmpty else { return }
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion()
            self.isLoading = false
        }
    }
}
