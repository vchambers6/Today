//
//  ReminderViewController+Section.swift
//  Today-Sample-Project
//
//  Created by Vanessa Chambers on 5/28/24.
//

import Foundation

extension ReminderViewController {
    // implicitly stores raw int values
    enum Section: Int, Hashable {
        case view
        case title
        case date
        case notes
        
        var name: String {
            switch self {
            case .view: return ""
            case .title:
                return NSLocalizedString("Title", comment: "Title section name")
            case .date:
                return NSLocalizedString("Date", comment: "Date section name")
            case .notes:
                return NSLocalizedString("Notes", comment: "Notes section name")
            }
        }
        
        
    }
}
