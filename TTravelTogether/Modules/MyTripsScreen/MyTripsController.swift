import UIKit
import Combine

final class MyTripsController: UIViewController {
    var onShowingTripDetail: ((UUID) -> Void)?

    private var myTripsView: MyTripsView {
        view as! MyTripsView
    }
    private let viewModel: MyTripsVMProtocol
    private var tableViewDataSource: TripsTableDataSource?
    private var tableViewDelegate: TripsTableDelegate?
    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: MyTripsVMProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        view = MyTripsView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
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
            self?.onShowingTripDetail?(tripId)
        }
        myTripsView.travellingsTableView.delegate = tableViewDelegate
    }
}
