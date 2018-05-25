//
//  Date+VT.swift
//  Labour Choice Labour
//
//  Created by Umair on 27/09/2017.
//  Copyright © 2017 vizteck. All rights reserved.
//

import Foundation

extension Date {

    static var calendar: Calendar = {
        return Calendar(identifier: .gregorian)
    }()

    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }

    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }

    var monthMedium: String  { return Formatter.monthMedium.string(from: self) }
    var hour12:  String      { return Formatter.hour12.string(from: self) }
    var minute0x: String     { return Formatter.minute0x.string(from: self) }
    var amPM: String         { return Formatter.amPM.string(from: self) }

    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }

    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }

    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }

    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }

    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }

    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }

    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }

    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }

    /// Returns the date in string formate
    func toString() -> String {
        let chatDateFormatter = DateFormatter()
        chatDateFormatter.dateFormat = "dd MMM, hh:mm a"
        return chatDateFormatter.string(from: self)
    }

    /// Returns true if the given date is a weekEnd e.g Sat, Sun
    func isWeekend() -> Bool {
        return Date.calendar.isDateInWeekend(self)
    }

    static func dayNameFromDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }

    /// Returns name of the month, Month number should start from 0
    static func monthNameFromMonthNumber(monthNumber: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter.monthSymbols[monthNumber]
    }

    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }

    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    
    static func compareDate(date1:Date, date2:Date) -> Bool {
        let order = NSCalendar.current.compare(date1, to: date2, toGranularity: .day)
        switch order {
        case .orderedSame:
            return true
        default:
            return false
        }
    }
}
