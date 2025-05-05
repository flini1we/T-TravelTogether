import UIKit
import SkeletonView

final class TripDateView: UIView {

    private lazy var startsAtTitle: UILabel = {
        LabelBuilder()
            .build()
    }()

    private lazy var finishAtTitle: UILabel = {
        LabelBuilder()
            .build()
    }()

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(PaddingValues.small.value)
        }
        return view
    }()

    private lazy var dateStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            startsAtTitle, separatorView, finishAtTitle
        ])
        stack.spacing = PaddingValues.small.value / 2
        stack.alignment = .center
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupDateFont(_ font: UIFont) {
        startsAtTitle.font = font
        finishAtTitle.font = font
    }

    func setupTextColor(_ color: UIColor) {
        startsAtTitle.textColor = color
        finishAtTitle.textColor = color
        separatorView.backgroundColor = color
    }

    func setupWithData(startsAt: Date, finishAt: Date) {
        startsAtTitle.text = AppFormatter.shared.getStringRepresentationOfDate(from: startsAt)
        finishAtTitle.text = AppFormatter.shared.getStringRepresentationOfDate(from: finishAt)
    }
}

private extension TripDateView {

    func setup() {
        isSkeletonable = true
        setupSubviews()
        setupConstraints()
    }

    func setupSubviews() {
        addSubview(dateStackView)
    }

    func setupConstraints() {
        dateStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
