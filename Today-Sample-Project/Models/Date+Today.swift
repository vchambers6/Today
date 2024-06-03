//
//  Date+Today.swift
//  Today-Sample-Project
//
//  Created by Vanessa Chambers on 5/19/24.
//

import Foundation

extension Date {
    
    #warning("This is a computed property")
    var dayAndTimeText: String {
        let timeText = formatted(date: .omitted, time: .shortened)
        
        if Locale.current.calendar.isDateInToday(self) {
            let timeFormat = NSLocalizedString("Today at %@", comment: "Today at time formatted string")
            return String(format: timeFormat, timeText)
        } else {
            let dateText = formatted(.dateTime.month(.abbreviated).day())
            
            #warning("this is how you can format a string -- create the NSLocalized string format, using %@ for passed in arguments, and then use the String(format: ..., [args]) initializer")
            let dateAndTimeFormat = NSLocalizedString("%@ at %@", comment: "Date and time format string")
            return String(format: dateAndTimeFormat, dateText, timeText)
        }
    }
    
    var dayText: String {
        if Locale.current.calendar.isDateInToday(self) {
            return NSLocalizedString("Today", comment: "Today due date description")
        } else {
            return formatted(.dateTime.month().day().weekday(.wide))
        }
    }
}


