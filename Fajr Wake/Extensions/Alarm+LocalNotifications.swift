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
    case nilFireDate
    
    var errorDescription: String? {
        switch self {
        case .permissionDeined:
            return NSLocalizedString("Permission Denied", comment: "")
        case .nilFireDate:
            return NSLocalizedString("Internal Error", comment: "")
        }
    }
    
    var failureReason: String? {
        switch self {
        case .permissionDeined:
            return NSLocalizedString("Cannot turn on alarm when permission", comment: "")
        case .nilFireDate:
            return NSLocalizedString("Error setting local notification.", comment: "")
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .permissionDeined:
            return NSLocalizedString("Open Settings->Notifications and allow this app to send local notifications.", comment: "")
        case .nilFireDate:
            return NSLocalizedString("Please contact the admin and notify this error immediately.", comment: "")
        }
    }
}

// MARK: - extension Alarm

extension Alarm {
    
    // MARK: - Convenience Methods
    
    struct LocalNotifications {
        
        static func createNotifications(for alarm: Alarm, numOfNotificationsToCreate count: Int, _ completion: @escaping (_ error: Error?) -> Void) {
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {
                (isPermissionGranted, error) in
                
                guard isPermissionGranted else {
                    if let error = error {
                        completion(error)
                    } else {
                        completion(LocalNotificationCreationError.permissionDeined)
                    }
                    return
                }
                guard let fireDate = alarm.fireDate else {
                    completion(LocalNotificationCreationError.nilFireDate)
                    print("ERROR: LocalNotifications - nil firedate")
                    return
                }
                let content = notificationContentFromAlarm(alarm)
                let triggers = notificationTriggersFromDate(fireDate: fireDate, numOfTriggersToGenerate: count)
                let requests = triggers.map {notificationRequest(content: content, trigger: $0)}
                addNotifications(requests: requests) {
                    completion(nil)
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
        
        static private func notificationContentFromAlarm(_ alarm: Alarm) -> UNNotificationContent {
            let content = UNMutableNotificationContent()
            let alarmSoundName = "roosterSound.wav"
            content.title = "Alarm"
            content.subtitle = "It's \(alarm.description)!"
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

