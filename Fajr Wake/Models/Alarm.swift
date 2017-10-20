//
//  Alarm.swift
//  Fajr Wake
//
//  Created by Ali Mir on 10/17/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import Foundation

// MARK: - enum AlarmStatuses

internal enum AlarmStatuses: String {
    case activeAndFired
    case activeAndNotFired
    case inActive
}

// MARK: - class Alarm

internal class Alarm: CustomStringConvertible {
    
    // MARK: - Singleton
    
    static let shared = Alarm()
    
    // MARK: - Stored Properties
    
    private var timer: Timer?
    private(set) var adjustMins: Int
    private(set) var selectedPrayer: Prayer
    private(set) var praytime: Praytime
    private(set) var soundPlayer: SoundPlayer
    private(set) var placeName: String
    
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
            return "Wake up, it's \(description)!"
        }
    }
    
    var description: String {
        if adjustMins == 0 {
            return "\(selectedPrayer)"
        } else {
            return "\(abs(adjustMins)) mins \(adjustMins > 0 ? "after" : "before") \(selectedPrayer)"
        }
    }
    
    private(set) var fireDate: Date? {
        get {
            guard status != .inActive else { return nil }
            return alarmDateForCurrentSetting
        }
        set {
            Alarm.Settings.fireDate = newValue
        }
    }

    var alarmDateForCurrentSetting: Date {
        var alarmDate = praytime.date(for: selectedPrayer, andDate: Date(), minsAdjustment: adjustMins)
        if alarmDate.timeIntervalSinceNow < 0 {
            alarmDate = praytime.date(for: selectedPrayer, andDate: Date().addingTimeInterval(24*60*60), minsAdjustment: adjustMins)
        }
        
        return alarmDate
    }
    
    // MARK: - Initializers
    
    // 'private' prevent others from using the default '()' initializer
    private init() {
        self.adjustMins = Alarm.Settings.minsToAdjust ?? 0
        let prayerSetting = Alarm.Settings.prayerTimeSetting ?? PrayTimeSetting(calcMethod: .jafari, latitude: 37.34, longitude: -121.89)
        self.praytime = Praytime(setting: prayerSetting)
        let soundSetting = Alarm.Settings.soundSetting ?? SoundSetting(ringtoneID: "AbatharAlHalawaji", ringtoneExtension: "aiff", isRepeated: true)
        self.soundPlayer = SoundPlayer(setting: soundSetting)
        self.selectedPrayer = Alarm.Settings.selectedPrayer ?? .fajr
        self.status = Alarm.Settings.status ?? .inActive
        self.placeName = Alarm.Settings.placeName ?? "37.33, -121.88"
    }
    
    // MARK: - Local Notifications
    
    private func removeLocalNotifications() {
        LocalNotifications.removePendingNotifications()
        LocalNotifications.removeDeliveredNotifications()
    }
    
    private func scheduleLocalNotifications(completion: ((_ error: Error)->Void)?) {
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
            // FIXME: - Create errors and notify the user!
            print("Local Notification permission denied!")
            completion?(LocalNotificationCreationError.permissionDeined)
        } catch LocalNotificationCreationError.fireDate {
            print("Fire date error!")
            completion?(LocalNotificationCreationError.fireDate)
        } catch let error {
            print("Other Error!")
            completion?(error)
        }
    }
    
    // MARK: - Triggers
    
    private func triggerAlarmWithTimer() {
        guard let fireDate = fireDate, fireDate.timeIntervalSinceNow > 0 else {
            print("Alarm fireAlarmWithTimer(): invalid FireDate!")
            return
        }
        timer = Timer.scheduledTimer(timeInterval: fireDate.timeIntervalSinceNow, target: self, selector: #selector(self.fireAlarm), userInfo: nil, repeats: false)
    }
    
    @objc internal func fireAlarm() {
        status = .activeAndFired
        soundPlayer.play()
        presentFiredAlarmViewController()
    }
    
    private func presentFiredAlarmViewController() {
        let fireAlarmVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "firedAlarmVC")
        if let topVC = UIViewController.topViewController {
            if topVC.isModal {
                UIViewController.topViewController?.dismiss(animated: false, completion: {
                    UIApplication.shared.keyWindow?.rootViewController?.present(fireAlarmVC, animated: false, completion: nil)
                })
            } else {
                UIApplication.shared.keyWindow?.rootViewController?.present(fireAlarmVC, animated: true, completion: nil)
            }
        }
    }

    private func invalidateTimer() {
        if timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    private func saveAlarm() {
        Alarm.Settings.minsToAdjust = adjustMins
        Alarm.Settings.prayerTimeSetting = praytime.setting
        Alarm.Settings.soundSetting = soundPlayer.setting
        Alarm.Settings.selectedPrayer = selectedPrayer
        Alarm.Settings.status = status
    }
    
    // MARK: - On, Off, Reset
    
    internal func resetActiveAlarm(completion: ((_ error: Error)->Void)?) {
        if status == .activeAndNotFired {
            turnOff()
            turnOn(completion: completion)
        }
    }
    
    internal func turnOn(completion: ((_ error: Error)->Void)?) {
        status = .activeAndNotFired
        fireDate = alarmDateForCurrentSetting
        triggerAlarmWithTimer()
        scheduleLocalNotifications(completion: completion)
    }
    
    internal func turnOff() {
        status = .inActive
        fireDate = nil
        removeLocalNotifications()
        invalidateTimer()
        soundPlayer.stop()
    }
    
    // MARK: - Setters
    
    internal func setAdjustMins(_ mins: Int) {
        adjustMins = mins
        Alarm.Settings.minsToAdjust = mins
    }
    
    internal func setSelectedPrayer(_ prayer: Prayer) {
        selectedPrayer = prayer
        Alarm.Settings.selectedPrayer = prayer
    }
    
    internal func setSoundSetting(_ setting: SoundSetting) {
        soundPlayer.setSetting(setting: setting)
        Alarm.Settings.soundSetting = setting
    }
    
    internal func setCalcMethod(_ method: CalculationMethod) {
        praytime.setting.calcMethod = method
        Alarm.Settings.prayerTimeSetting = praytime.setting
    }
    
    internal func setCoordinate(coordinate: Coordinate) {
        praytime.setting.latitude = coordinate.latitude
        praytime.setting.longitude = coordinate.longitude
        Alarm.Settings.prayerTimeSetting = praytime.setting
    }
    
    internal func setPlaceName(_ name: String) {
        placeName = name
        Alarm.Settings.placeName = name
    }
    
}
