import UIKit
import Combine

final class MyTripsController: UIViewController {
    weak var coordinator: IMainCoordinator?

    private var myTripsView: MyTripsView {
        view as! MyTripsView
    }
    private let viewModel: IMyTripsViewModel
    private var tableViewDataSource: TripsTableDataSource?
    private var tableViewDelegate: TripsTableDelegate?
    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: IMyTripsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        super.loadView()

        view = MyTripsView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MyTripsController {

    func setup() {
        setupDataSource()
        setupDelegate()
    }

    func setupDataSource() {

        tableViewDataSource = TripsTableDataSource(viewModel: viewModel)
        tableViewDataSource?.setupDataSource(
            with: myTripsView.travellingsTableView
        )
    }

    func setupDelegate() {
        tableViewDelegate = TripsTableDelegate(viewModel: viewModel) { [weak self] tripId in
            self?.coordinator?.showTripDetail(tripId)
        }
        myTripsView.travellingsTableView.delegate = tableViewDelegate
    }
}
