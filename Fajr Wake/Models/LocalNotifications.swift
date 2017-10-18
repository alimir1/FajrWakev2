//
//  LocalNotifications.swift
//  FajrWake
//
//  Created by Ali Mir on 9/6/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import Foundation
import UserNotifications

internal enum LocalNotificationCreationError: Error {
    case permissionDeined
    case fireDate
}

extension Alarm {
    struct LocalNotifications {
        static func createNotifications(for alarm: Alarm, numOfNotificationsToCreate count: Int, _ completion: @escaping (_ errors: [Error]?) -> Void) throws {
            guard let fireDate = alarm.fireDate else { throw LocalNotificationCreationError.fireDate }
            guard let permGranted = Alarm.Settings.isGrantedPermissionForLocalNotification, permGranted else { throw LocalNotificationCreationError.permissionDeined }
            let content = notificationContentFromAlarm(alarm)
            let triggers = notificationTriggersFromDate(fireDate: fireDate, numOfTriggersToGenerate: count)
            guard triggers.count > 0 else { throw LocalNotificationCreationError.fireDate }
            let requests = triggers.map {notificationRequest(content: content, trigger: $0)}
            addNotifications(requests: requests) {
                errors in
                completion(errors)
            }
        }
        
        static func notificationTriggersFromDate(fireDate date: Date, numOfTriggersToGenerate count: Int) -> [UNNotificationTrigger] {
            var triggers: [UNNotificationTrigger] = []
            var timeInterval = date.timeIntervalSinceNow
            if timeInterval > 0 {
                triggers.append(UNTimeIntervalNotificationTrigger(timeInterval: timeInterval , repeats: false))
            }
            for _ in 0..<count-1 {
                timeInterval += 30
                if timeInterval > 0 {
                    triggers.append(UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false))
                }
            }
            return triggers
        }
        
        static func notificationRequest(content: UNNotificationContent, trigger: UNNotificationTrigger) -> UNNotificationRequest {
            return UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        }
        
        static func notificationContentFromAlarm(_ alarm: Alarm) -> UNNotificationContent {
            let content = UNMutableNotificationContent()
            let alarmSoundName = alarm.soundPlayer.setting.ringtoneID + "." + alarm.soundPlayer.setting.ringtoneExtension
            content.title = "Alarm"
            content.subtitle = "It's \(alarm.description)!"
            content.body = "Open app to stop."
            content.sound = UNNotificationSound(named: alarmSoundName)
            return content
        }
        
        static func addNotifications(requests: [UNNotificationRequest], _ completion: @escaping (_ errors: [Error]?) -> Void) {
            var errors: [Error]? = nil
            for (index, request) in requests.enumerated() {
                UNUserNotificationCenter.current().add(request) {
                    error in
                    if let error = error {
                        errors?.append(error)
                    }
                    if index == requests.count - 1 {
                        completion(errors)
                    }
                }
            }
        }
        
        static func removeDeliveredNotifications() {
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        }
        
        static func removePendingNotifications() {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
        
        static func initNotificationSetupCheck() {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])
            { (success, error) in
                Alarm.Settings.isGrantedPermissionForLocalNotification = success
                if success {
                    print("Local Notification Permission Granted")
                } else {
                    print("Local Notification Permission Not Granted")
                }
            }
        }
    }
}

