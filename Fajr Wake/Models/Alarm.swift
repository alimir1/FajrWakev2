//
//  Alarm.swift
//  Fajr Wake
//
//  Created by Ali Mir on 10/17/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import Foundation

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
    private(set) var adjustMins: Int = 0
    private(set) var selectedPrayer: Prayer = .fajr
    private(set) var praytime = Praytime(setting: PrayTimeSetting(calcMethod: .jafari, latitude: 37.34, longitude: -121.89))
    private(set) var soundPlayer = SoundPlayer(setting: SoundSetting(ringtoneID: "AbatharAlHalawaji", ringtoneExtension: "aiff", isRepeated: true))
    
    // MARK: - Property Observers
    
    private(set) var status: AlarmStatuses = AlarmStatuses.inActive {
        didSet {
            Alarm.Settings.status = status
        }
    }
    
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
        guard status != .inActive else { return "" }
        var retStr = ""
        if adjustMins == 0 {
            retStr = "\(selectedPrayer)"
        } else {
           retStr = "\(abs(adjustMins)) mins \(adjustMins > 0 ? "after" : "before") \(selectedPrayer)"
        }

        return retStr
    }
    
    var fireDate: Date? {
        guard status != .inActive else { return nil }
        var dateToAlarm = Date()
        if dateToAlarm.timeIntervalSinceNow < 0 {
            dateToAlarm = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        }
        let fireDate = praytime.date(for: selectedPrayer, andDate: dateToAlarm)
        return fireDate
    }
    
    // MARK: - Initializers
    
    // 'private' prevent others from using the default '()' initializer
    private init() {
        saveAlarm()
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
        scheduleLocalNotifications()
        timer = Timer.scheduledTimer(timeInterval: fireDate.timeIntervalSinceNow, target: self, selector: #selector(self.fireAlarm), userInfo: nil, repeats: false)
    }
    
    @objc func fireAlarm() {
        status = .activeAndFired
        soundPlayer.playAlarmSound()
    }
    
    private func invalidateTimer() {
        if timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    internal func turnOn() {
        status = .activeAndNotFired
        triggerAlarmWithTimer()
    }
    
    internal func turnOff() {
        status = .inActive
        removeLocalNotifications()
        invalidateTimer()
        soundPlayer.stopAlarmSound()
    }
    
    internal func setAdjustMins(_ mins: Int) {
        turnOff()
        adjustMins = mins
        Alarm.Settings.minsToAdjust = mins
    }
    
    internal func setSelectedPrayer(_ prayer: Prayer) {
        turnOff()
        selectedPrayer = prayer
        Alarm.Settings.selectedPrayer = prayer
    }
    
    internal func setSoundSetting(_ setting: SoundSetting) {
        turnOff()
        soundPlayer.setSetting(setting: setting)
        turnOn()
        Alarm.Settings.soundSetting = setting
    }
    
    internal func setPrayerTimeSetting(_ setting: PrayTimeSetting) {
        turnOff()
        praytime.setting = setting
        Alarm.Settings.prayerTimeSetting = setting
    }
    
    private func saveAlarm() {
        Alarm.Settings.minsToAdjust = adjustMins
        Alarm.Settings.prayerTimeSetting = praytime.setting
        Alarm.Settings.soundSetting = soundPlayer.setting
        Alarm.Settings.selectedPrayer = selectedPrayer
        Alarm.Settings.status = status
    }
}
