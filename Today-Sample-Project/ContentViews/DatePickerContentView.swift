//
//  DatePickerContentView.swift
//  Today-Sample-Project
//
//  Created by Vanessa Chambers on 5/30/24.
//

import UIKit

class DatePickerContentView: UIView, UIContentView {
    
    struct Configuration: UIContentConfiguration {
        var date = Date.now
        var onChange: (Date) -> Void = { _ in }
        
        func makeContentView() ->  UIView & UIContentView {
             return DatePickerContentView(self)
        }
    }
    let datePicker = UIDatePicker()
    var configuration: UIContentConfiguration
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        
        addPinnedSubview(datePicker)
        #warning("TODO: come back and play with this")
        datePicker.preferredDatePickerStyle = .inline
        datePicker.addTarget(self, action: #selector(didPick(_:)), for: .valueChanged)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else {
            return
        }
        datePicker.date = configuration.date
    }
    
    @objc func didPick(_ sender: UIDatePicker) {
        guard let configuration = configuration as? DatePickerContentView.Configuration else { return }
        configuration.onChange(sender.date)
    }
    
}

extension UICollectionViewListCell {
    func datePickerConfiuguration() -> DatePickerContentView.Configuration {
        DatePickerContentView.Configuration()
    }
}
