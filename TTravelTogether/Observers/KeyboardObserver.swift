import UIKit

final class KeyboardObserver {

    private var onShowHandler: ((_ keyboardFrame: CGRect) -> Void)?
    private var onHideHander: (() -> Void)?

    init(
        onShowHandler: @escaping (_: CGRect) -> Void,
        onHideHander: @escaping () -> Void
    ) {
        self.onShowHandler = onShowHandler
        self.onHideHander = onHideHander
        startObserve()
    }

    func stopObserving() {
        onHideHander = nil
        onShowHandler = nil
        NotificationCenter
            .default
            .removeObserver(self)
    }
}

private extension KeyboardObserver {

    func startObserve() {
        NotificationCenter
            .default
            .addObserver(
                self,
                selector: #selector(handleKeyboardWillShow(notification:)),
                name: UIResponder.keyboardWillShowNotification,
                object: nil
            )
        
        NotificationCenter
            .default
            .addObserver(
                self,
                selector: #selector(handleKeyboardWillHide),
                name: UIResponder.keyboardWillHideNotification,
                object: nil
            )
    }

    @objc func handleKeyboardWillShow(notification: Notification) {
        guard
            let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
        onShowHandler?(keyboardFrame)
    }

    @objc func handleKeyboardWillHide() {
        onHideHander?()
    }
}
