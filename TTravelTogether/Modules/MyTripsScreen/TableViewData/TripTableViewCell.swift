import UIKit

final class TripTableViewCell: UITableViewCell {

    static var identifier: String {
        "\(self)"
    }

    private(set) lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = PaddingValues.medium.value
        view.layer.shadowColor = UIColor.label.cgColor
        view.layer.shadowOpacity = 0.25
        view.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        view.layer.shadowRadius = 3
        makeSkeletonable()
        view.makeSkeletonable()
        view.skeletonCornerRadius = Float(PaddingValues.default.value)
        return view
    }()

    private lazy var travelTitle: UILabel = {
        LabelBuilder()
            .font(CustomFonts.bold(FontValues.medium.value).font)
            .textColor(.label)
            .build()
    }()

    private lazy var titleAndImageStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            travelTitle
        ])
        stack.spacing = PaddingValues.small.value
        stack.alignment = .center
        return stack
    }()

    private lazy var tripDateView: TripDateView = {
        let tripDateView = TripDateView()
        tripDateView.setupDateFont(CustomFonts.default(FontValues.small.value).font)
        tripDateView.setupTextColor(.secondaryLabel)
        return tripDateView
    }()

    private lazy var titleAndTimeIntervalStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleAndImageStackView, tripDateView
        ])
        stack.axis = .vertical
        stack.spacing = PaddingValues.small.value
        stack.alignment = .leading
        return stack
    }()

    private lazy var priceTitle: UILabel = {
        LabelBuilder()
            .font(CustomFonts.default(FontValues.default.value).font)
            .textColor(.primaryBlue)
            .build()
    }()

    private lazy var cellDataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleAndTimeIntervalStackView, priceTitle
        ])
        stack.alignment = .center
        stack.spacing = PaddingValues.default.value
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupWithTravel(_ travel: Trip) {
        travelTitle.text = travel.title
        let validPrice = AppFormatter.shared.getValidNumberFromPrice(from: travel.price)
        priceTitle.text = validPrice + " \(Currency.current().rawValue)"

        tripDateView.setupWithData(startsAt: travel.startsAt, finishAt: travel.finishAt)
    }
}

private extension TripTableViewCell {

    func setup() {
        backgroundColor = .clear
        selectionStyle = .none
        setupSubviews()
        setupConstraints()
    }

    func setupSubviews() {
        contentView.addSubview(bgView)
        bgView.addSubview(cellDataStackView)
    }

    func setupConstraints() {
        bgView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(PaddingValues.small.value)
            make.top.bottom.equalToSuperview().inset(PaddingValues.small.value)
        }

        cellDataStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(PaddingValues.medium.value)
            make.centerY.equalToSuperview()
        }
    }
}
