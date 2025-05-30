import UIKit
import Contacts
import ContactsUI

final class MainCoordinator: NSObject, IMainCoordinator {
    weak var coordinator: IAppFlowCoordinator?
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

    func showTripDetail(_ id: Int) {
        let detailVC = dependencies.resolveTripDetailController(tripId: id, user: registratedUser)
        detailVC.coordinator = self
        detailVC.onTripDidLeave = { [weak self] in
            guard let self else { return }
            navigationController.popViewController(animated: true)
            guard let tabBarController = navigationController.viewControllers.first as? UITabBarController
            else { return }
            guard let mainController = findViewController(
                type: MyTripsController.self,
                in: tabBarController.viewControllers ?? []
            ) else { return }
            mainController.updateTrips()
        }
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
        guard let tripDetailController = findViewController(
            type: TripDetailController.self,
            in: navigationController.viewControllers
        ) else { return }
        let tripDetailId = tripDetailController.viewModel.tripId
        createTripController.setupEditedTrip(tripDetail, ogId: tripDetailId)
        createSheetViewController(from: createTripController)
        navigationController.present(createTripController, animated: true)
        navigationController.present(AlertFactory.createErrorAlert(message: .AppStrings.Errors.editedIdIsNil), animated: true)
    }

    func leaveProfile() {
        coordinator?.finish()
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
            tabBarController.navigationItem.titleView = nil
            createTripController.onIncorrectPriceAlertDidSet = { incorrectPriceAlert in
                createTripController.present(incorrectPriceAlert, animated: true)
            }
            tabBarController.present(createTripController, animated: true)
            return false
        }
        return true
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let delay = viewController is ProfileController ? 0.15 : 0
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            tabBarController.navigationItem.titleView =
            viewController is ProfileController
            ? UILabel.showTitleLabel(.AppStrings.Profile.screenTitle)
            : nil
        }
    }
}

private extension MainCoordinator {

    func showMainTabBar() {
        let tabBarController = dependencies.resolveMainTabBarController()
        let createTripController = dependencies.resolveCreateTripController(user: registratedUser)
        let myTripsController = dependencies.resolveMyTripsController()
        let profileController = dependencies.resolveProfileController()
        navigationController.navigationItem.title = "Sjl"
        tabBarController.delegate = self
        myTripsController.coordinator = self
        createTripController.coordinator = self
        createTripController.onTripCreating = {
            myTripsController.updateTrips()
        }
        createTripController.onTripEditing = { [weak self] tripDetail in
            guard
                let self,
                let tripDetailController = findViewController(
                    type: TripDetailController.self,
                    in: navigationController.viewControllers
                )
            else { return }
            tripDetailController.tripDetailView.setupWithTrip(tripDetail)
        }
        profileController.coordinat = self
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

    func findViewController<T>(type: T.Type, in controllers: [UIViewController]) -> T? {
        controllers.filter { $0 is T }.first as? T
    }
}
