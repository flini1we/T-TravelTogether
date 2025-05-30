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

    func resolveTripDetailController(tripId: Int, user: User) -> TripDetailController {
        container.resolve(TripDetailController.self, arguments: tripId, user)!
    }

    func resolveCreateTripController(user: User) -> CreateTripController {
        container.resolve(CreateTripController.self, argument: user)!
    }

    func resolveContactsController(selectedContacts: [Contact]) -> ContactsController {
        container.resolve(ContactsController.self, argument: selectedContacts)!
    }

    func resolveProfileController() -> ProfileController {
        container.resolve(ProfileController.self)!
    }

    func resolveMainTabBarController() -> UITabBarController {
        container.resolve(UITabBarController.self)!
    }

    func resolveNetworkService() -> INetworkService {
        container.resolve(INetworkService.self)!
    }
}

private extension SwinjectContainer {

    func setupDependencies() {

        registerViewModels()
        registerControllers()
        registerTabBarController()
        registerServices()
    }

    func registerViewModels() {
        container.register(ILoginViewModel.self) { resolver in
            let networkService = resolver.resolve(INetworkService.self)!
            return LoginViewModel(networkService: networkService)
        }

        container.register(IRegistrationViewModel.self) { resolver in
            let networkService = resolver.resolve(INetworkService.self)!
            return RegistrationViewModel(networkService: networkService)
        }

        container.register(IMyTripsViewModel.self) { resolver in
            let networkService = resolver.resolve(INetworkService.self)!
            return MyTripsViewModel(networkService: networkService)
        }

        container.register(ITripDetailViewModel.self) { (resolver, tripId: Int, user: User) in
            let networkService = resolver.resolve(INetworkService.self)!
            return TripDetailViewModel(tripId: tripId, user: user, networkService: networkService)
        }

        container.register(ICreateTripViewModel.self) { (resolver, user: User) in
            let networkService = resolver.resolve(INetworkService.self)!
            return CreateTripViewModel(user, networkService: networkService)
        }

        container.register(IContactsViewModel.self) { (_, selectedContacts) in
            ContactsViewModel(selectedContacts: selectedContacts)
        }

        container.register(IProfileViewModel.self) { resolver in
            let networkService = resolver.resolve(INetworkService.self)!
            return ProfileViewModel(networkService: networkService)
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

        container.register(TripDetailController.self) { (resolver, tripId: Int, user: User) in
            let tripDetailVM = resolver.resolve(ITripDetailViewModel.self, arguments: tripId, user)!
            let controller = TripDetailController(viewModel: tripDetailVM)
            controller.hidesBottomBarWhenPushed = true
            return controller
        }

        container.register(CreateTripController.self) { (resolver, user: User) in
            let viewModel = resolver.resolve(ICreateTripViewModel.self, argument: user)!
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

        container.register(ProfileController.self) { resolver in
            let viewModel = resolver.resolve(IProfileViewModel.self)!
            let controller = ProfileController(viewModel: viewModel)
            return controller
        }
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
            let profileController = resolver.resolve(ProfileController.self)!
            profileController.tabBarItem = UITabBarItem(
                title: nil,
                image: SystemImages.profileTabBarItem.image,
                tag: TabBarScreenTags.profile.rawValue
            )

            tabBar.viewControllers = [
                travellingVC,
                sampleVC,
                profileController
            ]

            return tabBar
        }
    }

    func registerServices() {
        container.register(ITokenManager.self) { _ in
            TokenManager()
        }

        container.register(INetworkService.self) { resolver in
            let tokenManager = resolver.resolve(ITokenManager.self)!
            return NetworkService(tokenManager: tokenManager)
        }
        .inObjectScope(.container)
    }
}
