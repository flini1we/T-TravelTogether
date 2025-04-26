import Foundation
import Combine

final class LoginViewModel: ObservableObject, Loginable {

    @Published var isLoading: Bool = false

    var isLoadingPublisher: Published<Bool>.Publisher {
        $isLoading
    }

    func login(phoneNumber: String, password: String, completion: @escaping ((Result<String, Error>) -> Void)) {
        guard !phoneNumber.isEmpty, !password.isEmpty else { return }
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion(.success("Красава"))
            self.isLoading = false
        }
    }
}
