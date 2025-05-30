import UIKit
import SnapKit

final class ProfileView: UIView {
    private var tableViewHeightConstraint: Constraint?

    private(set) lazy var userProfileView: UserProfileView = {
        let view = UserProfileView()
        view.makeSkeletonable()
        return view
    }()

    private(set) lazy var profileActionsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func onTableHeightChange(isHidden: Bool, animated: Bool = true) {
        let newHeight = isHidden
        ? 0
        : Int(UIElementsValues.profileCellsHeight.value) * ProfileScreenCellTypes.allCases.count
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.tableViewHeightConstraint?.update(offset: newHeight)
                self.layoutIfNeeded()
            }
        } else {
            tableViewHeightConstraint?.update(offset: newHeight)
        }
    }
}

private extension ProfileView {

    func setup() {
        makeSkeletonable()
        setupSubviews()
        setupConstraints()
    }

    func setupSubviews() {
        addSubview(userProfileView)
        addSubview(profileActionsTableView)
    }

    func setupConstraints() {

        userProfileView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(PaddingValues.default.value)
            make.leading.trailing.equalToSuperview().inset(PaddingValues.small.value)
        }

        profileActionsTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(PaddingValues.tiny.value)
            make.top.equalTo(userProfileView.snp.bottom).offset(PaddingValues.semiBig.value)
            self.tableViewHeightConstraint = make.height.equalTo(
                Int(UIElementsValues.profileCellsHeight.value) * ProfileScreenCellTypes.allCases.count
            ).constraint
        }
    }
}
