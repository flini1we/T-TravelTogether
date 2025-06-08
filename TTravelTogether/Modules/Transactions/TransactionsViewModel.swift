import Foundation
import Combine

final class TransactionsViewModel: ITransactionsViewModel {

    private var networkService: INetworkService
    var travelId: Int!
    var onErrorDidAppear: ((CustomError) -> Void)?

    @Published var isLoadingData: Bool = false
    var isLoadingDataPublisher: Published<Bool>.Publisher {
        $isLoadingData
    }

    @Published var transactions: [Transaction] = []
    var transactionsPublisher: Published<[Transaction]>.Publisher {
        $transactions
    }

    init(networkService: INetworkService) {
        self.networkService = networkService
    }

    func loadData() {
        isLoadingData = true
        networkService.getTransactions(tripId: travelId) { [weak self] result in
            switch result {
            case .success(let transactionsDTO):
                self?.transactions = TransactionDTO.unwrap(transactionsDTO)
                self?.isLoadingData = false
            case .failure(let error):
                self?.onErrorDidAppear?(error)
            }
        }
    }

    func getTransactionId(at index: IndexPath) -> Int {
        transactions[index.row].id
    }
}
