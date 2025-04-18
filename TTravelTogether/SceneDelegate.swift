import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var authCoordinator: AuthFlowCoordinatorProtocol?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        let navigationController = UINavigationController()
        let moduleFactory: ModuleFactoryProtocol = ModuleFactory()
        authCoordinator = AuthCoordinator(navigationController: navigationController, moduleFactory: moduleFactory)

        window?.rootViewController = navigationController
        authCoordinator?.start()
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }
}
