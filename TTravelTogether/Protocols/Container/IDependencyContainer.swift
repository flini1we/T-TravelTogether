import UIKit
import Swinject

protocol IDependencyContainer {

    func resolveLoginViewModel() -> ILoginViewModel
    func resolveRegistrationViewModel() -> IRegistrationViewModel
    func resolveMyTripsViewModel() -> IMyTripsViewModel
    func resolveTripViewModel() -> ICreateTripViewModel

    func resolveLoginController() -> LoginController
    func resolveRegistrationController() -> RegistrationController
    func resolveMyTripsController() -> MyTripsController
    func resolveTripDetailController(tripId: Int, user: User) -> TripDetailController
    func resolveCreateTripController(user: User) -> CreateTripController
    func resolveContactsController(selectedContacts: [Contact]) -> ContactsController
    func resolveProfileController() -> ProfileController
    func resolveTransactionsController() -> TransactionsController
    func resolveCreateTransactionController(travelId: Int) -> CreateTransactionController
    func resolveTransactionDetailController(transactionId: Int, travelId: Int, user: User) -> TransactionDetailController

    func resolveNetworkService() -> INetworkService

    func resolveMainTabBarController() -> UITabBarController
}
