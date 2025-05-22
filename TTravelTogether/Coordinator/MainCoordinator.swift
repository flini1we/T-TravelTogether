import UIKit
import Contacts
import ContactsUI

final class MainCoordinator: NSObject, IMainCoordinator {
    private var registratedUser: User

    var childCoordinators: [ICoordinator] = []
    var navigationController: UINavigationController
    var dependencies: IDependencyContainer

    init(navigationController: UINavigationController, dependencieProvider: IDependencyContainer, user: User) {
        self.navigationController = navigationController
        self.dependencies = dependencieProvider
        self.registratedUser = user
    }

    func start() {
        showMainTabBar()
    }

    func showTripDetail(_ id: UUID) {
        let detailVC = dependencies.resolveTripDetailController(tripId: id, user: registratedUser)
        detailVC.coordinator = self
        navigationController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(detailVC, animated: true)
    }

    func showContactList() {
        let createTripController = dependencies.resolveCreateTripController(user: registratedUser)
        let contactsController = dependencies.resolveContactsController(
            selectedContacts: createTripController.obtainContacts()
        )
        contactsController.onMembersUpdate = { users in
            createTripController.updateMembersAfterSelection(users)
        }
        createTripController.onDisappear = {
            contactsController.onClearData()
        }
        let navController = UINavigationController(rootViewController: contactsController)
        createTripController.present(navController, animated: true)
    }

    func showEditTripScreen(for tripDetail: TripDetail) {
        let createTripController = dependencies.resolveCreateTripController(user: registratedUser)
        createTripController.setupEditedTrip(tripDetail)
        createSheetViewController(from: createTripController)
        navigationController.present(createTripController, animated: true)
    }
}

extension MainCoordinator: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is EmptyController {
            let createTripController = dependencies.resolveCreateTripController(user: registratedUser)
            if let sheetController = createTripController.sheetPresentationController {
                if #available(iOS 16.0, *) {
                    let customDetent = UISheetPresentationController.Detent.custom { context in
                        return context.maximumDetentValue * 0.75
                    }
                    sheetController.detents = [customDetent]
                } else {
                    sheetController.detents = [.large()]
                }
            }
            createTripController.onIncorrectPriceAlertDidSet = { incorrectPriceAlert in
                createTripController.present(incorrectPriceAlert, animated: true)
            }
            tabBarController.present(createTripController, animated: true)
            return false
        }
        return true
    }
}

private extension MainCoordinator {

    func showMainTabBar() {
        let tabBarController = dependencies.resolveMainTabBarController()
        let createTripController = dependencies.resolveCreateTripController(user: registratedUser)
        let myTripsController = dependencies.resolveMyTripsController()

        tabBarController.delegate = self
        myTripsController.coordinator = self
        createTripController.coordinator = self
        createTripController.onTripCreating = {
            myTripsController.updateTrips()
        }
        navigationController.setViewControllers([tabBarController], animated: true)
    }

    func createSheetViewController(from vc: UIViewController) {
        if let sheetController = vc.sheetPresentationController {
            if #available(iOS 16.0, *) {
                let customDetent = UISheetPresentationController.Detent.custom { context in
                    return context.maximumDetentValue * 0.75
                }
                sheetController.detents = [customDetent]
            } else {
                sheetController.detents = [.large()]
            }
            sheetController.prefersGrabberVisible = true
        }
    }
}
