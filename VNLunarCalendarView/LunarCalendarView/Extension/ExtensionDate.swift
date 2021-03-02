//
//  ExtensionDate.swift
//  VNLunarCalendarView
//
//  Created by Hoàng Tuấn on 02/03/2021.
//

import Foundation

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    var day: Int {
        let components = self.get(.day, .month, .year)
        if let day = components.day {
            return day
        } else {
            return 0
        }
    }
    
    var month: Int {
        let components = self.get(.day, .month, .year)
        if let month = components.month {
            return month
        } else {
            return 0
        }
    }
    
    var year: Int {
        let components = self.get(.day, .month, .year)
        if let year = components.year {
            return year
        } else {
            return 0
        }
    }
}
