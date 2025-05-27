import Foundation

protocol KeyboardObservable: AnyObject {

    var keyboardObserver: KeyboardObserver? { get set }
    func startKeyboardObservering(
        onShow: @escaping (_ keyboardFrame: CGRect) -> Void,
        onHide: @escaping () -> Void
    )
    func stopKeyboardObservering()
}

extension KeyboardObservable {

    func startKeyboardObservering(
        onShow: @escaping (_ keyboardFrame: CGRect) -> Void,
        onHide: @escaping () -> Void
    ) {
        keyboardObserver = KeyboardObserver(onShowHandler: onShow, onHideHander: onHide)
    }

    func stopKeyboardObservering() {
        keyboardObserver?.stopObserving()
    }
}
