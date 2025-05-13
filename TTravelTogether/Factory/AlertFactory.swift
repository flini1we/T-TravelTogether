import UIKit

final class AlertFactory {

    static func createContactsAccessAlert(
        onSettings: @escaping () -> Void,
        onCancel: @escaping () -> Void
    ) -> UIAlertController {
        let alert = UIAlertController(
            title: .AppStrings.accessToContactsTitle,
            message: .AppStrings.accessToContactsMessage,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: .AppStrings.settings, style: .default) { _ in onSettings() })
        alert.addAction(UIAlertAction(title: .AppStrings.cancel, style: .cancel) { _ in onCancel() })
        return alert
    }

    static func createErrorAlert(
        title: String,
        message: String,
        onDismiss: @escaping () -> Void
    ) -> UIAlertController {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Ок", style: .default) { _ in onDismiss() })
        return alert
    }

    static func createConfirmationAlert(
        title: String,
        message: String,
        confirmTitle: String,
        cancelTitle: String = .AppStrings.cancel,
        onConfirm: @escaping () -> Void,
        onCancel: @escaping () -> Void
    ) -> UIAlertController {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: confirmTitle, style: .default) { _ in onConfirm() })
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel) { _ in onCancel() })
        return alert
    }
}
