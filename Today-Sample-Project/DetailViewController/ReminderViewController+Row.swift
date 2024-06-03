//
//  ReminderViewController+Row.swift
//  Today-Sample-Project
//
//  Created by Vanessa Chambers on 5/27/24.
//

import UIKit

extension ReminderViewController {
    #warning("INFO: diffabel data sources that supply data for UIKit lists require that items conform to ahshable -- it uses hash values to determine which elements changed between snapshots")
    enum Row: Hashable {
        case header(String)
        case date
        case notes
        case time
        case title
        case editableDate(Date)
        case editableText(String?)
        
        var imageName: String? {
            switch self {
            case.date: return "calendar.circle"
            case .notes: return "square.and.pencil"
            case .time: return "clock"
            default: return nil
            }
        }
        
        #warning("INFO: you can use synbol configuration object to style SF symbol images")
        var image: UIImage? {
            guard let imageName = imageName else { return nil }
            let configuration = UIImage.SymbolConfiguration(textStyle: .headline)
            return UIImage(systemName: imageName, withConfiguration: configuration)
        }
        
        var textStyle: UIFont.TextStyle {
            switch self {
            case .title: return .headline
            default: return .subheadline
            }
        }
    }
}
