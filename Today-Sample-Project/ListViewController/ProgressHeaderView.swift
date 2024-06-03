//
//  ProgressHeaderView.swift
//  Today-Sample-Project
//
//  Created by Vanessa Chambers on 6/1/24.
//

import UIKit

#warning("INFO: instead of deleting views when a user scrolls them out of the visible bounds, this class UICollectionReusableView keeps them in the reuse queue -- this is useful for creating supplementary views (separate from teh actual collection view cells) like headers and footers")
class ProgressHeaderView: UICollectionReusableView {
    
    #warning("INFO: we set the frame to 0 because we will add constraints, so we don't need to calculate a specific size or position for a frame")
    var progress: CGFloat = 0 {
        didSet {
            heightConstraint?.constant = progress * bounds.height
            UIView.animate(withDuration: 0.2) { [weak self] in
                /// layoutIfNeeded forces the view to update its layout immediately by animating the changes of the view
                self?.layoutIfNeeded()
            }
        }
    }
    private var upperView = UIView(frame: .zero)
    private var lowerView = UIView(frame: .zero)
    private var containerView = UIView(frame: .zero)
    private var heightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 0.5 * containerView.bounds.width
    }
    private func prepareSubviews() {
        containerView.addSubview(upperView)
        containerView.addSubview(lowerView)
        self.addSubview(containerView)
        
        #warning("INFO: when this property is true, the system atomatically specifies a view's size and position. when we set it false, that lets us define it.")
        upperView.translatesAutoresizingMaskIntoConstraints = false
        lowerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0).isActive = true
        containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1.0).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85).isActive = true
        
        upperView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        upperView.bottomAnchor.constraint(equalTo: lowerView.topAnchor).isActive = true
        lowerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        upperView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        upperView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        lowerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        lowerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        heightConstraint = lowerView.heightAnchor.constraint(equalToConstant: 0)
        heightConstraint?.isActive = true
        
        backgroundColor = .clear
        containerView.backgroundColor = .clear
        upperView.backgroundColor = .yellow
        lowerView.backgroundColor = .orange
    }
}
