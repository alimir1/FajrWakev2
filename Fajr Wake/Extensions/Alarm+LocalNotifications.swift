//
//  LocalNotifications.swift
//  FajrWake
//
//  Created by Ali Mir on 9/6/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import Foundation
import UserNotifications

// MARK: - enum LocalNotificationCreationError

internal enum LocalNotificationCreationError: Error, LocalizedError {
    case permissionDeined
    
    var errorDescription: String? {
        switch self {
        case .permissionDeined:
            return NSLocalizedString("Permission Denied", comment: "")
        }
    }
    
    var failureReason: String? {
        switch self {
        case .permissionDeined:
            return NSLocalizedString("Cannot turn on alarm when permission", comment: "")
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .permissionDeined:
            return NSLocalizedString("Open Settings->Notifications and allow this app to send local notifications.", comment: "")
        }
    }
}

// MARK: - extension Alarm

extension Alarm {
    
    internal class func scheduleLocalNotifications(withFireDate fireDate: Date, message: String, completion: ((_ error: Error?)->Void)?) {
        Alarm.LocalNotifications.removeAllNotifications()
        LocalNotifications.createNotifications(fireDate: fireDate, message: message, numOfNotificationsToCreate: 58) {
            error in
            completion?(error)
        }
    }
    
    // MARK: - Convenience Methods
    
    struct LocalNotifications {
        
        static func createNotifications(fireDate: Date, message: String, numOfNotificationsToCreate count: Int, _ completion: @escaping (_ error: Error?) -> Void) {
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {
                (isPermissionGranted, error) in
                
                guard isPermissionGranted else {
                    if let error = error {
                        DispatchQueue.main.async {
                            completion(error)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(LocalNotificationCreationError.permissionDeined)
                        }
                    }
                    return
                }
                let content = notificationContent(withMessage: message)
                let triggers = notificationTriggersFromDate(fireDate: fireDate, numOfTriggersToGenerate: count)
                let requests = triggers.map {notificationRequest(content: content, trigger: $0)}
                addNotifications(requests: requests) {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        }
        
        static private func notificationTriggersFromDate(fireDate date: Date, numOfTriggersToGenerate count: Int) -> [UNNotificationTrigger] {
            var triggers: [UNNotificationTrigger] = []
            var timeInterval = date.timeIntervalSinceNow
            if timeInterval > 0 {
                triggers.append(UNTimeIntervalNotificationTrigger(timeInterval: timeInterval , repeats: false))
            }
            for _ in 0..<count-1 {
                timeInterval += 3
                if timeInterval > 0 {
                    triggers.append(UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false))
                }
            }
            return triggers
        }
        
        static private func notificationRequest(content: UNNotificationContent, trigger: UNNotificationTrigger) -> UNNotificationRequest {
            return UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        }
        
        static private func notificationContent(withMessage: String) -> UNNotificationContent {
            let content = UNMutableNotificationContent()
            let alarmSoundName = "roosterSound.wav"
            content.title = "Alarm"
            content.subtitle = "It's \(withMessage)!"
            content.body = "Open app to stop."
            content.sound = UNNotificationSound(named: alarmSoundName)
            return content
        }
        
        static private func addNotifications(requests: [UNNotificationRequest], _ completionHandler: (() -> Void)?) {
            for (index, request) in requests.enumerated() {
                UNUserNotificationCenter.current().add(request) {
                    _ in
                    if index == requests.count - 1 {
                        completionHandler?()
                    }
                }
            }
        }
        
        static func removeAllNotifications() {
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
    }
}

