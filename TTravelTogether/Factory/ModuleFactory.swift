import UIKit

struct ModuleFactory: ModuleFactoryProtocol {

    func makeLoginModule() -> UIViewController {
        getModule(.login)
    }

    func makeRegistrationModule() -> UIViewController {
        getModule(.register)
    }

    func createMainTabBarController(coordinator: CoordinatorProtocol) -> UITabBarController {
        let tabBar = UITabBarController()
        tabBar.tabBar.setupTinkoffStyle()
        let travellingsViewController = getModule(.travelling) as! MyTripsController
        travellingsViewController.coordinator = coordinator
        tabBar.viewControllers = [travellingsViewController, getModule(.createTravel), getModule(.placeholder)]
        return tabBar
    }

    func createTripDetailController(tripId id: UUID) -> UIViewController {
        let tripDetailViewModel: TripDetailVMProtocol = TripDetailViewModel(tripId: id)
        let tripDetailController = TripDetailController(viewModel: tripDetailViewModel)
        tripDetailController.hidesBottomBarWhenPushed = true
        return tripDetailController
    }
}

private extension ModuleFactory {

    func getModule(_ type: ModuleTypes) -> UIViewController {
        switch type {
        case .login:
            let loginViewModel: Loginable = LoginViewModel()
            let loginController = LoginController(viewModel: loginViewModel)
            return loginController
        case .register:
            let rigistrationViewModel = RegistrationViewModel()
            let registrationController = RegistrationController(viewModel: rigistrationViewModel)
            return registrationController
        case .travelling:
            let travellingViewModel: MyTripsVMProtocol = MyTripsViewModel(tripsData: Trip.obtainMock())
            let travellingsViewController = MyTripsController(viewModel: travellingViewModel)
            travellingsViewController.tabBarItem = UITabBarItem(
                title: nil,
                image: SystemImages.travellingTabBarImage.image,
                tag: TabBarScreenTags.travellings.rawValue
            )
            return travellingsViewController
        case .createTravel:
            let createTravelViewController = UIViewController()
            createTravelViewController.tabBarItem = UITabBarItem(
                title: nil,
                image: SystemImages.createTravelTabBarItem.image,
                tag: TabBarScreenTags.createTravel.rawValue
            )
            return createTravelViewController
        case .placeholder:
            let placeholderlViewController = UIViewController()
            placeholderlViewController.tabBarItem = UITabBarItem(
                title: nil,
                image: SystemImages.archiveTabBarItem.image,
                tag: TabBarScreenTags.placeholder.rawValue
            )
            return placeholderlViewController
        }
    }
}
