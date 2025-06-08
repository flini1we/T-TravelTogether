import UIKit
import SnapKit
import SkeletonView

final class TripDetailView: UIView {
    var onShowTransactionsButtonAction: (() -> Void)?

    private(set) lazy var tripTitle: UILabel = {
        LabelBuilder()
            .font(CustomFonts.bold(FontValues.title.value).font)
            .textColor(.label)
            .text(.AppStrings.AppTitles.tripDetailTitle)
            .makeSkeletonable()
            .skeletonTextLineHeight(.relativeToFont)
            .skeletonLinesCornerRadius(PaddingValues.tiny.value)
            .build()
    }()

    private lazy var tripDateView: TripDateView = {
        let tripDateView = TripDateView()
        tripDateView.setupDateFont(CustomFonts.default(FontValues.default.value).font)
        tripDateView.setupTextColor(.secondaryLabel)
        tripDateView.setupWithData(startsAt: .now, finishAt: .now)
        tripDateView.makeSkeletonable()
        tripDateView.skeletonCornerRadius = Float(PaddingValues.tiny.value)
        return tripDateView
    }()

    private lazy var tripPriceLabel: UILabel = {
        LabelBuilder()
            .textColor(.primaryBlue)
            .font(CustomFonts.bold(FontValues.medium.value).font)
            .text(.AppStrings.AppTitles.tripDetailPrice + " " + Currency.ruble.rawValue)
            .makeSkeletonable()
            .skeletonTextLineHeight(.relativeToFont)
            .skeletonLinesCornerRadius(PaddingValues.tiny.value)
            .build()
    }()

    private lazy var titleDatePriceStackView: UIStackView = {
        var titleDateStack: UIStackView {
            let stack = UIStackView(arrangedSubviews: [
                tripTitle,
                tripDateView
            ])
            stack.axis = .vertical
            stack.spacing = PaddingValues.tiny.value
            stack.alignment = .leading
            stack.makeSkeletonable()
            return stack
        }
        var dataStackView: UIStackView {
            let stack = UIStackView(arrangedSubviews: [
                titleDateStack,
                tripPriceLabel
            ])
            stack.spacing = PaddingValues.default.value
            stack.alignment = .center
            stack.makeSkeletonable()
            return stack
        }
        return dataStackView
    }()

    private lazy var tripMembersTitle: UILabel = {
        LabelBuilder()
            .text(.AppStrings.CreateTrip.tripMembers)
            .font(CustomFonts.bold(FontValues.big.value).font)
            .textColor(.label)
            .build()
    }()

    private(set) lazy var tripMemebersCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.itemSize = UIElementsValues.memberCollectionViewCell.size
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout
        )
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            MemberCollectionViewCell.self,
            forCellWithReuseIdentifier: MemberCollectionViewCell.identifier
        )
        collectionView.makeSkeletonable()
        return collectionView
    }()

    private lazy var tripMembersData: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            tripMembersTitle,
            tripMemebersCollectionView
        ])
        stack.axis = .vertical
        stack.spacing = PaddingValues.small.value
        stack.alignment = .leading
        return stack
    }()

    private lazy var transactionsButton: UIButton = {
        let button = ButtonBuilder()
            .backgroundColor(.primaryYellow)
            .cornerRadius(.default)
            .tintColor(.buttonLabel)
            .title(.AppStrings.CreateTrip.transactionsButton)
            .font(CustomFonts.bold(FontValues.default.value).font)
            .deactivate()
            .build()
        button.addPressAnimation { [weak self] in
            self?.onShowTransactionsButtonAction?()
        }
        return button
    }()

    private lazy var bgImageView: UIImageView = {
        let imageView = UIImageView(image: .tripDetailBGLogo)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeSkeletonable()
        setup()
        showSkeleton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupWithTrip(_ tripDetail: TripDetail) {
        deactivateSkeleton()
        tripTitle.text = tripDetail.title
        tripPriceLabel.text =
        AppFormatter.shared.getValidNumberFromPrice(from: tripDetail.price) + " " + Currency.ruble.rawValue
        tripDateView.setupWithData(startsAt: tripDetail.startsAt, finishAt: tripDetail.finishAt)
    }

    func activateTransactionButton() {
        transactionsButton.alpha = 1
        transactionsButton.isEnabled = true
    }
}

private extension TripDetailView {

    func setup() {
        backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
    }

    func showSkeleton() {
        titleDatePriceStackView.showAnimatedGradientSkeleton(
            usingGradient: .init(baseColor: .skeletonDefault)
        )
    }

    func setupSubviews() {
        addSubview(bgImageView)
        addSubview(titleDatePriceStackView)
        addSubview(tripMembersData)
        addSubview(transactionsButton)
    }

    func setupConstraints() {
        bgImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(snp.bottom)
            make.height.equalTo(UIScreen.main.bounds.height * 0.25)
        }

        titleDatePriceStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(PaddingValues.default.value)
            make.leading.trailing.equalToSuperview().inset(PaddingValues.default.value)
        }

        tripMembersData.snp.makeConstraints { make in
            make.top.equalTo(titleDatePriceStackView.snp.bottom).inset(-PaddingValues.large.value)
            make.leading.trailing.equalToSuperview().inset(PaddingValues.default.value)
        }

        tripMemebersCollectionView.snp.makeConstraints { make in
            make.height.equalTo(UIElementsValues.memberCollectionViewCell.size.height)
            make.trailing.equalTo(tripMembersData.snp.trailing)
            make.leading.equalTo(tripMembersData.snp.leading)
        }

        transactionsButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(PaddingValues.medium.value)
            make.top.equalTo(tripMembersData.snp.bottom).offset(PaddingValues.large.value)
        }
    }

    func deactivateSkeleton() {
        titleDatePriceStackView.hideSkeleton()
    }
}
