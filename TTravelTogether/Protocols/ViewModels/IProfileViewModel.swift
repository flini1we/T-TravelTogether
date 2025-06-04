import Foundation

protocol IProfileViewModel {
    var onErrorDidAppear: ((CustomError) -> Void)? { get set }

    var isLoadingData: Bool { get }
    var isLoadingDataPublisher: Published<Bool>.Publisher { get }

    var user: User? { get }
    var userPublisher: Published<User?>.Publisher { get }

    func loadData()
}
