//
//  Prayer.swift
//  Fajr Wake
//
//  Created by Ali Mir on 10/17/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import Foundation

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

internal enum CalculationMethod: Int, CustomStringConvertible {
    case jafari, karachi, isna, mwl, makkah, egypt, tehran = 7
    
    var description: String {
        switch self {
        case .jafari:
            return "Ithna Ashari"
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

internal struct PrayTimeSetting {
    var calcMethod: CalculationMethod
    var latitude: Double
    var longitude: Double
}

internal class Praytime {
    private class func praytimes(for setting: PrayTimeSetting, date: Date) -> [String] {
        let praytime = PrayTime()
        praytime.setTimeFormat(Int32(PrayTime().time12))
        praytime.setCalcMethod(Int32(setting.calcMethod.rawValue))
        let dateComponents = Calendar(identifier: .gregorian).dateComponents(in: .current, from: date)
        let ptimes = praytime.getPrayerTimes(dateComponents, andLatitude: setting.latitude, andLongitude: setting.longitude, andtimeZone: PrayTime().getZone()) as Any as? [String] ?? []
        return ptimes
    }
    
    class func praytimeString(for setting: PrayTimeSetting, prayer: Prayer, date: Date) -> String {
        let ptimes = Praytime.praytimes(for: setting, date: date)
        let ptime = ptimes[prayer.rawValue]
        return ptime
    }
    
    class func prayerDate(for setting: PrayTimeSetting, for prayer: Prayer, andDate date: Date) -> Date {
        let ptimes = Praytime.praytimes(for: setting, date: date)
        let ptime = ptimes[prayer.rawValue]
        let time = timeComponents(from: ptime)
        return Date.date(hour: time.hour, minute: time.minute, from: date)
    }
    
    private class func timeComponents(from string: String) -> (hour: Int, minute: Int) {
        let time = string.characters.split {$0 == ":"}.map { String($0) }
        let hour = Int(time[0])!
        let minute = Int((time[1].characters.split {$0 == " "}.map { String($0) })[0])!
        return (hour: hour, minute: minute)
    }
    
}
