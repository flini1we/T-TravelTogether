import UIKit
import Combine

final class ProfileController: UIViewController {
    weak var coordinat: IMainCoordinator?
    private var profileView: ProfileView {
        view as! ProfileView
    }

    private var viewModel: IProfileViewModel
    private var profileTableViewDataSource: ProfileTableViewDataSource?
    private var profileTableViewDelegate: ProfileTableViewDelegate?
    private var cancellables: Set<AnyCancellable> = []

    override func loadView() {
        super.loadView()
        view = ProfileView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadData()
    }

    init(viewModel: IProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ProfileController {

    func setup() {

        profileView.makeSkeletonable()
        setupDataSource()
        setupBindings()
    }

    func setupDataSource() {

        profileTableViewDataSource = ProfileTableViewDataSource()
        profileTableViewDelegate = ProfileTableViewDelegate { [weak self] in
            self?.present(
                AlertFactory.createLeaveProfileAlert(onConfirm: { [weak self] in
                    self?.coordinat?.leaveProfile()
                }),
                animated: true
            )
        }
        profileView.profileActionsTableView.dataSource = profileTableViewDataSource
        profileView.profileActionsTableView.delegate = profileTableViewDelegate
    }

    func setupBindings() {

        viewModel.isLoadingDataPublisher
            .dropFirst()
            .sink { [weak self] isLoading in
                guard let self else { return }
                _ = isLoading
                ? profileView.showSkeleton()
                : profileView.hideSkeleton()
                profileView.onTableHeightChange(isHidden: isLoading, animated: !isLoading)
            }
            .store(in: &cancellables)

        viewModel.userPublisher
            .sink { [weak self] user in
                guard let user, let self else { return }
                profileView.userProfileView.setupWithUser(user: user)
            }
            .store(in: &cancellables)

        viewModel.onErrorDidAppear = { [weak self] error in
            self?.present(AlertFactory.createErrorAlert(message: error.localizedDescription), animated: true)
        }
    }
}
