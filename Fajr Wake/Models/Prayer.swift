//
//  Prayer.swift
//  Fajr Wake
//
//  Created by Ali Mir on 10/17/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import Foundation

// MARK: - enum Prayer

internal enum Prayer: Int, CustomStringConvertible {
    case fajr, sunrise, dhuhr, asr, sunset, maghrib, isha
    
    var description: String {
        switch self {
        case .fajr:
            return "Fajr"
        case .sunrise:
            return "sunrise"
        case .dhuhr:
            return "Dhuhr"
        case .asr:
            return "A'sr"
        case .sunset:
            return "sunset"
        case .maghrib:
            return "Maghrib"
        case .isha:
            return "I'sha"
        }
    }
}

// MARK: - enum CalculationMethod

internal enum CalculationMethod: Int, CustomStringConvertible {
    case jafari, karachi, isna, mwl, makkah, egypt, tehran = 7
    
    var description: String {
        switch self {
        case .jafari:
            return "Ithna Ashari (Shia)"
        case .karachi:
            return "University of Islamic Sciences, Karachi"
        case .isna:
            return "Islamic Society of North America (ISNA)"
        case .mwl:
            return "Muslim World League (MWL)"
        case .makkah:
            return "Umm al-Qura, Makkah"
        case .egypt:
            return "Egyptian General Authority of Survey"
        case .tehran:
            return "Institute of Geophysics, University of Tehran"
        }
    }
    
}

// MARK: - struct PrayTimeSetting

internal struct PrayTimeSetting {
    var calcMethod: CalculationMethod
    var latitude: Double
    var longitude: Double
}

// MARK: - class Praytime

internal class Praytime {
    
    // MARK: - Properties
    
    internal var setting: PrayTimeSetting
    
    // MARK: - Initializers
    
    init(setting: PrayTimeSetting) {
        self.setting = setting
    }
    
    // MARK: - Convenience Methods
    
    private func praytimes(for date: Date) -> [String] {
        let praytime = PrayTime()
        praytime.setTimeFormat(Int32(PrayTime().time12))
        praytime.setCalcMethod(Int32(setting.calcMethod.rawValue))
        let dateComponents = Calendar(identifier: .gregorian).dateComponents(in: .current, from: date)
        let ptimes = praytime.getPrayerTimes(dateComponents, andLatitude: setting.latitude, andLongitude: setting.longitude, andtimeZone: PrayTime().getZone()) as Any as? [String] ?? []
        return ptimes
    }
    
    func praytimeString(prayer: Prayer, date: Date) -> String {
        let ptimes = praytimes(for: date)
        let ptime = ptimes[prayer.rawValue]
        return ptime
    }
    
    func date(for prayer: Prayer, andDate date: Date, minsAdjustment: Int) -> Date {
        let ptimes = praytimes(for: date)
        let ptime =  ptimes[prayer.rawValue]
        let time = Praytime.timeComponents(from: ptime)
        let adjustedMins = time.minute + minsAdjustment
        return Date.date(hour: time.hour, minute: adjustedMins, from: date)
    }
    
    private class func timeComponents(from string: String) -> (hour: Int, minute: Int) {
        let time = string.characters.split {$0 == ":"}.map { String($0) }
        let hour = Int(time[0]) ?? 0
        let minute = Int((time[1].characters.split {$0 == " "}.map { String($0) })[0]) ?? 0
        return (hour: hour, minute: minute)
    }
    
}
