//
//  Prayer.swift
//  Fajr Wake
//
//  Created by Ali Mir on 10/17/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import Foundation

enum Prayer: Int, CustomStringConvertible {
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
