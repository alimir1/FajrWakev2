//
//  Date+Helpers.swift
//  FajrWake
//
//  Created by Ali Mir on 9/11/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import Foundation

extension DateFormatter { 
    static var splitDateFormatter: (time: DateFormatter, ampm: DateFormatter) = {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm"
        let ampmFormatter = DateFormatter()
        ampmFormatter.dateFormat = "a"
        return (time: timeFormatter, ampm: ampmFormatter)
    }()
}

extension Date {
    
    var timeString: String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        return timeFormatter.string(from: self)
    }
    
    /// Returns `Date` for user-defined `hour` and `minute` components from another date.
    ///
    /// - note: The components from `date` parameter are used to return `Date` object. Exceptoions: `hour`, `minute`, and `second`.
    /// - parameter hour: Hour to use.
    /// - parameter minute: Minute to use.
    /// - parameter date: The `Date` to use.
    /// - returns: The `Date` of the specified parameters.
    static func date(hour: Int, minute: Int, from date: Date) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let cmpts: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        var components = calendar.dateComponents(cmpts, from: date)
        components.hour = hour
        components.minute = minute
        components.second = 0
        return calendar.date(from: components) ?? Date()
    }
}

