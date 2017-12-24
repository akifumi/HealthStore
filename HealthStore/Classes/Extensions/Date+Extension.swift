//
//  Date+Extension.swift
//
//
//  Created by Akifumi on 2017/12/17.
//

import Foundation

extension Date {
    public static var current: Date {
        return Date()
    }
    public static func startOfToday(calendar: Calendar = Calendar.current) -> Date {
        return calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date.current)!
    }
}
