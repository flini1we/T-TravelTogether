import UIKit

final class ThemeManager {

    static var current: AppTheme = .light {
        didSet {
            applyTheme()
            NotificationCenter.default.post(
                name: NSNotification.Name(.AppStrings.Notification.changeTheme),
                object: nil,
                userInfo: [String.AppStrings.Notification.updatedThemeKey: current]
            )
        }
    }

    private static func applyTheme() {
        let style: UIUserInterfaceStyle = current == .light ? .light : .dark

        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .forEach { $0.overrideUserInterfaceStyle = style }
    }
}
