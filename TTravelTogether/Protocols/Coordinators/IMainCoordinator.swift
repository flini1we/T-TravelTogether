import UIKit

protocol IMainCoordinator: ICoordinator {

    var dependencies: IDependencyContainer { get }

    func showTripDetail(_ id: Int)
    func showContactList()
    func showEditTripScreen(for tripDetail: TripDetail)
    func leaveProfile()
    func showTransactionsScreen(travelId: Int)
    func showCreateTransactionScreen(travelId: Int)
    func showTransactionDetailScreen(transactionId: Int, travelId: Int)
    func showEditTransactionScreen(transaction: TransactionDetail, travelId: Int)
}
