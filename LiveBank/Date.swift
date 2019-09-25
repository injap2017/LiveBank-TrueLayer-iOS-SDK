//
//  UpdatedTimestamp.swift
//  LiveBank
//
//  Created by Edgar Sia on 10/18/17.
//  Copyright © 2017 TrueLayer. All rights reserved.
//

import Foundation

extension Date {
    // Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    // Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    // Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    // Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    // Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    // Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    // Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    // Returns the a custom time interval description from another date
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
    // Store into UserDefaults
    func archive(_ key:String, into:UserDefaults) {

        into.setValue(self, forKey: key)
        into.synchronize()
    }
    // Fetch from UserDefaults
    static func unarchive(_ key:String, into:UserDefaults) -> Date {

        let object = into.value(forKey: key) as! Date
        
        return object
    }
    // Text last updated from Date
    static func lastUpdatedFrom(date: Date) -> String {
        let current = Date()
        
        let minutes = current.minutes(from: date)
        let hours = current.hours(from: date)
        let days = current.days(from: date)
        let months = current.months(from: date)
        
        var text:String = ""
        if months > 0 {
            text = String.init(format: "Updated %d months ago", months)
        } else {
            if days > 0 {
                text = String.init(format: "Updated %d days ago", days)
            } else {
                if hours > 0 {
                    text = String.init(format: "Updated %d hours ago", hours)
                } else {
                    if minutes > 0 {
                        text = String.init(format: "Updated %d mintues ago", minutes)
                    } else {
                        text = "Updated now."
                    }
                }
            }
        }
        
        return text
        
    }
    
}
