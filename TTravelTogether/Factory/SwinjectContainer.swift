import UIKit
import Swinject
import Contacts
import ContactsUI

final class SwinjectContainer: IDependencyContainer {

    private let container: Container

    init() {
        container = Container()
        setupDependencies()
    }

    func resolveLoginViewModel() -> ILoginViewModel {
        container.resolve(ILoginViewModel.self)!
    }

    func resolveRegistrationViewModel() -> IRegistrationViewModel {
        container.resolve(IRegistrationViewModel.self)!
    }

    func resolveMyTripsViewModel() -> IMyTripsViewModel {
        container.resolve(IMyTripsViewModel.self)!
    }

    func resolveTripDetailViewModel(tripId: UUID, user: User) -> ITripDetailViewModel {
        container.resolve(ITripDetailViewModel.self, arguments: tripId, user)!
    }

    func resolveTripViewModel() -> ICreateTripViewModel {
        container.resolve(ICreateTripViewModel.self)!
    }

    func resolveLoginController() -> LoginController {
        container.resolve(LoginController.self)!
    }

    func resolveRegistrationController() -> RegistrationController {
        container.resolve(RegistrationController.self)!
    }

    func resolveMyTripsController() -> MyTripsController {
        container.resolve(MyTripsController.self)!
    }

    func resolveTripDetailController(tripId: UUID, user: User) -> TripDetailController {
        container.resolve(TripDetailController.self, arguments: tripId, user)!
    }

    func resolveCreateTripController() -> CreateTripController {
        container.resolve(CreateTripController.self)!
    }

    func resolveContactsController(selectedContacts: [Contact]) -> ContactsController {
        container.resolve(ContactsController.self, argument: selectedContacts)!
    }

    func resolveMainTabBarController() -> UITabBarController {
        container.resolve(UITabBarController.self)!
    }
}

private extension SwinjectContainer {

    func setupDependencies() {

        registerViewModels()
        registerControllers()
        registerTabBarController()
    }

    func registerViewModels() {
        container.register(ILoginViewModel.self) { _ in
            LoginViewModel()
        }

        container.register(IRegistrationViewModel.self) { _ in
            RegistrationViewModel()
        }

        container.register(IMyTripsViewModel.self) { _ in
            MyTripsViewModel()
        }

        container.register(ITripDetailViewModel.self) { (_, tripId: UUID, user: User) in
            TripDetailViewModel(tripId: tripId, user: user)
        }

        container.register(ICreateTripViewModel.self) { _ in
            CreateTripViewModel()
        }

        container.register(IContactsViewModel.self) { (_, selectedContacts) in
            ContactsViewModel(selectedContacts: selectedContacts)
        }
    }

    func registerControllers() {

        container.register(LoginController.self) { resolver in
            let loginVM = resolver.resolve(ILoginViewModel.self)!
            return LoginController(viewModel: loginVM)
        }

        container.register(RegistrationController.self) { resolver in
            let registrationVM = resolver.resolve(IRegistrationViewModel.self)!
            return RegistrationController(viewModel: registrationVM)
        }

        container.register(MyTripsController.self) { resolver in
            let myTripsVM = resolver.resolve(IMyTripsViewModel.self)!
            let myTipsController = MyTripsController(viewModel: myTripsVM)
            myTipsController.tabBarItem = UITabBarItem(
                title: nil,
                image: SystemImages.travellingTabBarImage.image,
                tag: TabBarScreenTags.travellings.rawValue
            )
            return myTipsController
        }.inObjectScope(.container)

        container.register(TripDetailController.self) { (resolver, tripId: UUID, user: User) in
            let tripDetailVM = resolver.resolve(ITripDetailViewModel.self, arguments: tripId, user)!
            let controller = TripDetailController(viewModel: tripDetailVM)
            controller.hidesBottomBarWhenPushed = true
            return controller
        }

        container.register(CreateTripController.self) { resolver in
            let viewModel = resolver.resolve(ICreateTripViewModel.self)!
            let createTripController = CreateTripController(viewModel: viewModel)
            createTripController.tabBarItem = UITabBarItem(
                title: nil,
                image: SystemImages.createTravelTabBarItem.image,
                tag: TabBarScreenTags.createTravel.rawValue
            )
            return createTripController
        }.inObjectScope(.container)

        container.register(ContactsController.self) { (resolver, selectedUsers: [Contact]) in
            let viewModel = resolver.resolve(IContactsViewModel.self, argument: selectedUsers)!
            return ContactsController(viewModel: viewModel)
        }.inObjectScope(.container)
    }

    func registerTabBarController() {
        container.register(UITabBarController.self) { resolver in
            let tabBar = UITabBarController()
            tabBar.tabBar.setupTinkoffStyle()

            let travellingVC = resolver.resolve(MyTripsController.self)!
            let sampleVC = EmptyController()
            sampleVC.tabBarItem = UITabBarItem(
                title: nil,
                image: SystemImages.createTravelTabBarItem.image,
                tag: TabBarScreenTags.createTravel.rawValue
            )

            tabBar.viewControllers = [
                travellingVC,
                sampleVC,
                UIViewController()
            ]

            return tabBar
        }
    }
}
