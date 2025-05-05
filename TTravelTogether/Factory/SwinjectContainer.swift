import UIKit
import Swinject

final class SwinjectContainer: DependencyContainerProtocol {

    static let shared: SwinjectContainer = SwinjectContainer()

    private let container: Container

    private init() {
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

    func resolveTripDetailViewModel(tripId: UUID) -> ITripDetailViewModel {
        container.resolve(ITripDetailViewModel.self, argument: tripId)!
    }

    func createTripViewModel() -> ICreateTripViewModel {
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

    func resolveTripDetailController(tripId: UUID) -> TripDetailController {
        container.resolve(TripDetailController.self, argument: tripId)!
    }

    func resolveCreateTripController() -> CreateTripController {
        container.resolve(CreateTripController.self)!
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
        container.register(ITripDetailViewModel.self) { (_, tripId: UUID) in
            TripDetailViewModel(tripId: tripId)
        }
        container.register(ICreateTripViewModel.self) { _ in
            CreateTripViewModel()
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
        }
        container.register(TripDetailController.self) { (resolver, tripId: UUID) in
            let tripDetailVM = resolver.resolve(ITripDetailViewModel.self, argument: tripId)!
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
        }
    }

    func registerTabBarController() {
        container.register(UITabBarController.self) { resolver in
            let tabBar = UITabBarController()
            tabBar.tabBar.setupTinkoffStyle()

            let travellingVC = resolver.resolve(MyTripsController.self)!
            let createTripVC = resolver.resolve(CreateTripController.self)!

            tabBar.viewControllers = [
                travellingVC,
                createTripVC,
                UIViewController()
            ]

            return tabBar
        }
    }
}
