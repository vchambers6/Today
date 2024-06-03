//
//  ReminderListStyle.swift
//  Today-Sample-Project
//
//  Created by Vanessa Chambers on 5/31/24.
//

import Foundation

enum ReminderListStyle: Int {
    case today
    case future
    case all
    
    func shouldInclude(date: Date) -> Bool {
        let isInToday = Locale.current.calendar.isDateInToday(date)
        
        switch self {
        case .today:
            return isInToday
        case .future:
            return (date > Date.now) && !isInToday
        case .all:
            return true
        }
    }
    
    var name: String {
        switch self {
        case .today:
            return NSLocalizedString("Today", comment: "Today style")
        case .future:
            return NSLocalizedString("Future", comment: "Future style")
        case .all:
            return NSLocalizedString("All", comment: "All style")
        }
    }
}
