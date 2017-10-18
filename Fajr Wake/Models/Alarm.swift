//
//  Alarm.swift
//  Fajr Wake
//
//  Created by Ali Mir on 10/17/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import Foundation

// MARK: - Alarm Setting

internal struct AlarmSetting {
    var ringtoneID: String
    var ringtoneExtension: String
    var adjustMins: Int
    var prayer: Prayer
    var prayerSetting: PrayTimeSetting
}

// MARK: - Alarm Statuses

internal enum AlarmStatuses: String {
    case activeAndFired
    case activeAndNotFired
    case inActive
}

// MARK: - Alarm

internal class Alarm {
    
    // MARK: - Singleton
    
    static let shared = Alarm()
    
    // MARK: - Stored Properties
    
    private var timer: Timer?
    private(set) var status: AlarmStatuses = AlarmStatuses.inActive
    private(set) var settings: AlarmSetting = AlarmSetting(ringtoneID: "", ringtoneExtension: "", adjustMins: 0, prayer: .fajr, prayerSetting: PrayTimeSetting(calcMethod: .jafari, latitude: 0.0, longitude: 0.0))
    
    // MARK: - Computed Properties
    
    var statusMessage: String {
        switch status {
        case .activeAndNotFired:
            guard let fireDate = self.fireDate else { return "Internal Error!" }
            let seconds = Int(fireDate.timeIntervalSinceNow)%60
            let minutes = ((Int(fireDate.timeIntervalSinceNow))/60)%60
            let hours = Int((fireDate.timeIntervalSinceNow/60)/60)
            return "\(hours) hrs \(minutes) min and \(seconds) sec left"
        case .inActive:
            return "Alarm is not set!"
        case .activeAndFired:
            return "Wake up, it's \(alarmDescription)!"
        }
    }
    
    var alarmDescription: String {
        var retStr = ""
        if settings.adjustMins == 0 {
            retStr = "\(settings.prayer)"
        } else {
           retStr = "\(abs(settings.adjustMins)) mins \(settings.adjustMins > 0 ? "after" : "before") \(settings.prayer)"
        }

        return retStr
    }
    
    var fireDate: Date? {
        let dateOfAlarm = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        let fireDate = Praytime.prayerDate(for: settings.prayerSetting, for: settings.prayer, andDate: dateOfAlarm)
        return fireDate
    }
    
    // MARK: - Methods
    
    private func removeLocalNotifications() {
        LocalNotifications.removePendingNotifications()
        LocalNotifications.removeDeliveredNotifications()
    }
    
    private func scheduleLocalNotifications() {
        removeLocalNotifications()
        do {
            try LocalNotifications.createNotifications(for: self, numOfNotificationsToCreate: 58) {
                errors in
                if let errors = errors {
                    print("Errors:\n \(errors.map {$0.localizedDescription}.joined(separator: "\n"))")
                } else {
                    print("All set!")
                }
            }
        } catch LocalNotificationCreationError.permissionDeined {
            print("Local Notification permission denied!")
        } catch LocalNotificationCreationError.fireDate {
            print("Fire date error!")
        } catch {
            print("Unknown Error!")
        }
    }
    
    private func triggerAlarmWithTimer() {
        guard let fireDate = fireDate, fireDate.timeIntervalSinceNow > 0 else {
            print("Alarm fireAlarmWithTimer(): invalid FireDate!")
            return
        }
        timer = Timer.scheduledTimer(timeInterval: fireDate.timeIntervalSinceNow, target: self, selector: #selector(self.fireAlarm), userInfo: nil, repeats: false)
    }
    
    @objc func fireAlarm() {
        status = .activeAndFired
//        playAlarmSound(ringtoneID: settings.ringtoneID, withExtension: settings.ringtoneExtension, isRepeated: true)
    }
    
    private func invalidateTimer() {
        if timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    internal func turnOn() {
        status = .activeAndNotFired
        scheduleLocalNotifications()
        triggerAlarmWithTimer()
    }
    
    internal func turnOff() {
        status = .inActive
        removeLocalNotifications()
        invalidateTimer()
        // stopSound()
    }
    
}
