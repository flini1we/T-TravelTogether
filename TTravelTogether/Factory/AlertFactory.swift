import UIKit

final class AlertFactory {

    static func createContactsAccessAlert(
        onSettings: @escaping () -> Void,
        onCancel: @escaping () -> Void
    ) -> UIAlertController {
        let alert = UIAlertController(
            title: .AppStrings.Alert.accessToContactsTitle,
            message: .AppStrings.Alert.accessToContactsMessage,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: .AppStrings.Alert.settings, style: .default) { _ in onSettings() })
        alert.addAction(UIAlertAction(title: .AppStrings.Alert.cancel, style: .cancel) { _ in onCancel() })
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
        alert.addAction(UIAlertAction(title: .AppStrings.Alert.ok, style: .default) { _ in onDismiss() })
        return alert
    }

    static func createConfirmationAlert(
        title: String,
        message: String,
        confirmTitle: String,
        cancelTitle: String = .AppStrings.Alert.cancel,
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

    static func createLeaveTripAlert(
        isAdmin: Bool,
        onConfirm: @escaping () -> Void = {},
        onCancel: @escaping () -> Void = {}
    ) -> UIAlertController {
        let title: String = isAdmin
            ? .AppStrings.Alert.leaveTripAdminTitle
            : .AppStrings.Alert.leaveTripTitle
        let message: String? = isAdmin
            ? nil
            : .AppStrings.Alert.leaveTripMessage
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        if !isAdmin {
            alert.addAction(UIAlertAction(
                title: .AppStrings.Alert.confirm,
                style: .default,
                handler: { _ in onConfirm() }
            ))
        }
        alert.addAction(UIAlertAction(
            title: .AppStrings.Alert.cancel,
            style: .cancel,
            handler: { _ in onCancel() }
        ))
        return alert
    }

    static func createEditTripAlert(
        onCancel: @escaping () -> Void = {}
    ) -> UIAlertController {
        let alert = UIAlertController(
            title: .AppStrings.Alert.editTripTitle,
            message: nil,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: .AppStrings.Alert.cancel, style: .cancel) { _ in onCancel() })
        return alert
    }
}
