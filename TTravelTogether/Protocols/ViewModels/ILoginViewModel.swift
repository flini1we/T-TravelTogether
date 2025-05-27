import UIKit
import Combine

protocol ILoginViewModel: AnyObject {

    var isLoading: Bool { get set }

    var isLoadingPublisher: Published<Bool>.Publisher { get }

    func login(
        userData: LoginUserDataType,
        completion: @escaping ((Result<LoginUserDataType, CustomError>) -> Void)
    )
}
