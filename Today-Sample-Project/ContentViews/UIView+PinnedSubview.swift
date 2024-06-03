//
//  UIView+PinnedSubview.swift
//  Today-Sample-Project
//
//  Created by Vanessa Chambers on 5/29/24.
//

import UIKit

extension UIView {
    
    /// add a subview that is pinned to its superview with optional padding
    func addPinnedSubview(_ subview: UIView, height: CGFloat? = nil, insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        addSubview(subview)
        
        #warning("INFO: we do this to prevent the system from creating automatic constraints for this view")
        subview.translatesAutoresizingMaskIntoConstraints = false
        #warning("INFO: assigning true to isActive for a constraint adds the constraint to the common ancestor in the view hierarchy and activates it")
        subview.topAnchor.constraint(equalTo: topAnchor, constant: insets.top).isActive = true
        subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left).isActive = true
        subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: insets.right).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: insets.bottom).isActive = true
        /// want to constrain the height if we got it
        if let height {
            subview.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
    }
}
