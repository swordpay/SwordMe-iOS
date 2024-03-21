//
//  NotificationManager.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 20.04.22.
//

import UIKit
import Combine
import UserNotifications

enum NotificationAuthorizationStatus {
    case authorized
    case unauthorized
    case notDetermined
}

final class NotificationManager: NSObject, NotificationManaging {
    
    private var cancellables: Set<AnyCancellable> = []
    private var pushNotificationHandler: PushNotificationHandling?

    let authorizationStatusPublisher: CurrentValueSubject<NotificationAuthorizationStatus?, Never> = CurrentValueSubject(nil)
    
    override init() {
        super.init()

        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification, object: nil)
            .sink { _ in
                UNUserNotificationCenter.current().getNotificationSettings { [ weak self ] settings in
                    guard let self, self.authorizationStatusPublisher.value != nil else { return }
                    
                    let status: NotificationAuthorizationStatus
                    switch settings.authorizationStatus {
                    case .notDetermined:
                        status = .notDetermined
                    case .denied:
                        status = .unauthorized
                    default:
                        status = .authorized
                    }

                    DispatchQueue.main.async {
                        if status != self.authorizationStatusPublisher.value {
                            self.authorizationStatusPublisher.send(status)
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func checkAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { [ weak self ] settings in
            let status: NotificationAuthorizationStatus
            switch settings.authorizationStatus {
            case .notDetermined:
                status = .notDetermined
            case .denied:
                status = .unauthorized
            default:
                status = .authorized
            }

            DispatchQueue.main.async {
                self?.authorizationStatusPublisher.send(status)
            }
        }
    }

    func registerForPushNotifications() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .notDetermined {
                UNUserNotificationCenter.current()
                  .requestAuthorization(options: [.alert, .sound, .badge]) { [ weak self ] granted, error in
                      print("Permission granted: \(granted)")

                      if error != nil {
                          DispatchQueue.main.async {
                              self?.authorizationStatusPublisher.send(.unauthorized)
                          }

                          return
                      }

                      let status: NotificationAuthorizationStatus = granted ? .authorized : .notDetermined
                      
                      DispatchQueue.main.async {
                          self?.authorizationStatusPublisher.send(status)
                      }

                      DispatchQueue.main.async {
                          if !UIApplication.shared.isRegisteredForRemoteNotifications {
                              UIApplication.shared.registerForRemoteNotifications()
                          }
                      }
                  }
            } else {       
                DispatchQueue.main.async {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }
            }
        }
    }

    // MARK: - Handling Push Notification

    func handlePushNotifications(userInfo: [AnyHashable: Any]? = nil) {
        guard let keyRawValue = userInfo?["key"] as? String,
              let key = PushNotificationKeys(rawValue: keyRawValue) else { return }
        
        let data = userInfo?["data"] as? [AnyHashable: Any]
        pushNotificationHandler = PushNotificationHandlerProvider.handler(for: key, data: data)
        
        pushNotificationHandler?.handle()
    }
}
