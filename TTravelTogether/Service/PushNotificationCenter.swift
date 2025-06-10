import Foundation
import UserNotifications

protocol IPushNotificationCenter {

    @available(iOS 16, *)
    func registerForNotification() async throws -> Bool

    func showNotification(
        for request: UNNotificationRequest,
        completion: @escaping ((Result<Void, CustomError>) -> Void)
    )
    func registerForNotification() -> Bool
}

final class PushNotificationCenter: NSObject, IPushNotificationCenter {

    private let notificationCenter = UNUserNotificationCenter.current()

    override init() {
        super.init()
        notificationCenter.delegate = self
    }

    func showNotification(
        for request: UNNotificationRequest,
        completion: @escaping ((Result<Void, CustomError>) -> Void)
    ) {
        DispatchQueue.main.async {
            self.notificationCenter.getNotificationSettings { settings in
                guard
                    settings.authorizationStatus == .authorized
                else {
                    completion(.failure(.hiddenError(.AppStrings.Notification.notificationDenied)))
                    return
                }
                self.notificationCenter.add(request) { error in
                    if let error = error {
                        completion(
                            .failure(
                                .hiddenError(
                                    .AppStrings.Notification.errorShowingNotification + " \(error.localizedDescription)"
                                )
                            )
                        )
                    }
                }
            }
        }
    }

    @available(iOS 16, *)
    func registerForNotification() async throws -> Bool {
        try await notificationCenter.requestAuthorization(options: [.alert, .badge, .sound])
    }

    func registerForNotification() -> Bool {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
        return true
    }
}

extension PushNotificationCenter: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
}
