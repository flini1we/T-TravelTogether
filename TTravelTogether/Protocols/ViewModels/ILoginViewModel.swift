import UIKit
import Combine

protocol ILoginViewModel: AnyObject {

    var isLoading: Bool { get set }

    var isLoadingPublisher: Published<Bool>.Publisher { get }

    func login(
        phoneNumber: String,
        password: String,
        completion: @escaping ((Result<String, LoginErrors>) -> Void)
    )
}
