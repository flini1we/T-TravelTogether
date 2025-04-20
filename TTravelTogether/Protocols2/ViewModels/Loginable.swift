import UIKit
import Combine

protocol Loginable {

    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var isLoading: Bool { get set }

    func login(
        phoneNumber: String,
        password: String,
        completion: @escaping ((Result<String, Error>) -> Void)
    )
}
