import Foundation

final class RegistrationViewModel {

    private let passwordSecureRule = true

    func register(
        data: (name: String, password: String, passwordComfirm: String),
        completion: @escaping ((Result<String, Error>) -> Void)
    ) {
        // TODO: regular expression for fields
        guard data.password == data.passwordComfirm && passwordSecureRule else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion(.success("Good"))
        }
    }
}
