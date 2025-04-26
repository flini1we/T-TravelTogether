import UIKit
import Combine

protocol Loginable: AnyObject {

    var isLoading: Bool { get set }

    var isLoadingPublisher: Published<Bool>.Publisher { get }

    func login(
        phoneNumber: String,
        password: String,
        completion: @escaping ((Result<String, Error>) -> Void)
    )
}
