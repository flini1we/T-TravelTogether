import Foundation

protocol ITransactionsViewModel {
    var travelId: Int! { get set }
    var onErrorDidAppear: ((CustomError) -> Void)? { get set }

    var transactions: [Transaction] { get set }
    var transactionsPublisher: Published<[Transaction]>.Publisher { get }

    var isLoadingData: Bool { get set }
    var isLoadingDataPublisher: Published<Bool>.Publisher { get }

    func loadData()
    func getTransactionId(at index: IndexPath) -> Int
}
