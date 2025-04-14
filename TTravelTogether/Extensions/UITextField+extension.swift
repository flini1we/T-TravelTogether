import UIKit
import SnapKit
import Combine

extension UITextField {

    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(
            for: UITextField.textDidChangeNotification,
            object: self
        )
        .compactMap { $0.object as? UITextField }
        .map { $0.text ?? "" }
        .debounce(for: 0.5, scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}

extension UITextField {

    func addEyeToggle() {
        guard self.isSecureTextEntry else { return }

        let spacer = UIView()
        let eyeButton = UIButton(type: .custom)
        eyeButton.setImage(SystemImages.slashedEye(true).image, for: .normal)
        eyeButton.tintColor = .placeholder
        eyeButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.isSecureTextEntry.toggle()
            }, completion: nil)
            eyeButton.setImage(SystemImages.slashedEye(isSecureTextEntry).image, for: .normal)
        }, for: .touchUpInside)

        spacer.snp.makeConstraints { make in
            make.width.equalTo(PaddingValues.default.value)
            make.height.equalTo(UIElementsValues.systemButtonHeight.value)
        }
        eyeButton.snp.makeConstraints { make in
            make.width.height.equalTo(UIElementsValues.systemButtonHeight.value)
        }

        let dataStackView = UIStackView(arrangedSubviews: [eyeButton, spacer])
        self.rightView = dataStackView
        self.rightViewMode = .always
    }
}

extension UITextField {

    func setValidationBorder(_ isValid: Bool) {
        layer.borderWidth = CGFloat(Float(1))
        layer.borderColor = isValid ? UIColor.systemGreen.cgColor : UIColor.primaryRed.cgColor
    }
}
