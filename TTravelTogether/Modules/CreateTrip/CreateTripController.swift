import UIKit
import Combine

final class CreateTripController: UIViewController {
    weak var coordinator: IMainCoordinator?

    private var viewModel: ICreateTripViewModel

    private var createTripView: ICreateTripView {
        view as! ICreateTripView
    }
    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: ICreateTripViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        super.loadView()

        view = CreateTripView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CreateTripController {

    func setup() {
        setupFields()
        setupBindings()
    }

    func setupFields() {
        createTripView.onShowingContacts = { [weak self] in
            self?.coordinator?.showContactList()
        }
    }

    func setupBindings() {
        setupViewModelBindings()
        setupViewBindings()
    }

    func setupViewModelBindings() {

        viewModel.isCreateButtonEnablePublisher
            .assign(to: \.isEnabled, on: createTripView.createButton)
            .store(in: &cancellables)

        viewModel.isCreateButtonEnablePublisher
            .sink { [weak self] isValid in
                self?.createTripView.createButton.alpha = isValid ? 1 : 0.5
            }
            .store(in: &cancellables)
    }

    func setupViewBindings() {

        createTripView.tripTitleField.textPublisher
            .assign(to: \.tripTitleText, on: viewModel)
            .store(in: &cancellables)

        createTripView.tripPriceField.textPublisher
            .assign(to: \.tripDescriptionText, on: viewModel)
            .store(in: &cancellables)
    }
}
