import UIKit

final class LoginController: UIViewController {

    private var loginView: LoginView {
        view as! LoginView
    }

    override func loadView() {
        super.loadView()

        view = LoginView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
}
