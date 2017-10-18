//
//  Settings.swift
//  FajrWake
//
//  Created by Ali Mir on 9/5/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import Foundation

// Custom Types

extension UserDefaults {
    subscript(key: DefaultsKey<AlarmStatuses?>) -> AlarmStatuses? {
        get { return unarchive(key) }
        set { archive(key, newValue) }
    }
    
    subscript(key: DefaultsKey<Prayer?>) -> Prayer? {
        get { return unarchive(key) }
        set { archive(key, newValue) }
    }
    
    subscript(key: DefaultsKey<CalculationMethod?>) -> CalculationMethod? {
        get { return unarchive(key) }
        set { archive(key, newValue) }
    }
}

// Static Keys
extension DefaultsKeys {
    static let status = DefaultsKey<AlarmStatuses?>("FW-STATUS")
    static let prayer = DefaultsKey<Prayer?>("FW-PRAYERTIME")
    static let ringtoneID = DefaultsKey<String?>("FW-RINGTONEID")
    static let ringtoneExtension = DefaultsKey<String?>("FW-RINGTONEEXTENSION")
    static let minsToAdjust = DefaultsKey<Int?>("FW-MINSTOADJUST")
    static let fireDate = DefaultsKey<Date?>("FW-FIREDATE")
    static let userExitDate = DefaultsKey<Date?>("FW-PROGRAMEXITDATE")
    static let isLocalNotificationPermissionGranted = DefaultsKey<Bool>("FW-LOCALPERMNOTIF")
    static let prayertimeDate = DefaultsKey<Date?>("FW-PRAYERTIMEDATE")
    static let calcMethod = DefaultsKey<CalculationMethod?>("FW-CALCULATIONMETHOD")
    static let latitude = DefaultsKey<Double?>("FW-PRAYERLATITUDE")
    static let longitude = DefaultsKey<Double?>("FW-PRAYERLONGITUDE")
}

extension Alarm {
    
    struct Settings {
        static var isLocalNotificationPermissionGranted: Bool {
            return Defaults[.isLocalNotificationPermissionGranted]
        }
        
        static var previousFireDate: Date? {
            return Defaults[.fireDate]
        }
        
        static var previousPrayertimeDate: Date? {
            return Defaults[.prayertimeDate]
        }
        
        static var alarmStatus: AlarmStatuses? {
            return Defaults[.status]
        }
        
        static var userExitDate: Date? {
            return Defaults[.userExitDate]
        }
        
        static func fajrAlarmSetting() -> AlarmSetting? {
            guard let prayer = Defaults[.prayer], let ringtoneID = Defaults[.ringtoneID], let ringtoneExtension = Defaults[.ringtoneExtension], let minsToAdjust = Defaults[.minsToAdjust], let latitude = Defaults[.latitude], let longitude = Defaults[.longitude], let calcMethod = Defaults[.calcMethod]  else {
                return nil
            }
            let prayerSetting = PrayTimeSetting(calcMethod: calcMethod, latitude: latitude, longitude: longitude)
            return AlarmSetting(ringtoneID: ringtoneID, ringtoneExtension: ringtoneExtension, adjustMins: minsToAdjust, prayer: prayer, prayerSetting: prayerSetting)
        }
        
        static func saveUserPreference(fireDate: Date?, alarmStatus: AlarmStatuses, alarmSetting: AlarmSetting) {
            saveFireDate(fireDate)
            saveUserExitDate(Date())
            saveAlarmSetting(alarmSetting)
            saveAlarmStatus(alarmStatus)
        }
        
        static func saveFireDate(_ date: Date?) {
            Defaults[.fireDate] = date
        }
        
        static func savePrayertimeDate(_ date: Date?) {
            Defaults[.prayertimeDate] = date
        }
        
        static func saveUserExitDate(_ date: Date) {
            Defaults[.userExitDate] = date
        }
        
        static func saveAlarmSetting(_ setting: AlarmSetting) {
            Defaults[.prayer] = setting.prayer
            Defaults[.ringtoneID] = setting.ringtoneID
            Defaults[.ringtoneExtension] = setting.ringtoneExtension
            Defaults[.minsToAdjust] = setting.adjustMins
            Defaults[.latitude] = setting.prayerSetting.latitude
            Defaults[.longitude] = setting.prayerSetting.longitude
            Defaults[.calcMethod] = setting.prayerSetting.calcMethod
        }
        
        static func saveLocalNotificationPermission(_ isGranted: Bool) {
            Defaults[.isLocalNotificationPermissionGranted] = isGranted
        }
        
        static func saveAlarmStatus(_ status: AlarmStatuses) {
            Defaults[.status] = status
        }
    }
}

