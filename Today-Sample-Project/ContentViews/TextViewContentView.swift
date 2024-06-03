//
//  TextViewContentView.swift
//  Today-Sample-Project
//
//  Created by Vanessa Chambers on 5/29/24.
//

import UIKit

class TextViewContentView: UIView, UIContentView {
    
    struct Configuration: UIContentConfiguration {
        var text: String? = ""
        var onChange: (String) -> Void = {_ in}
        
        func makeContentView() -> UIView & UIContentView {
                return TextViewContentView(self)
            }
    }
    let textView = UITextView()
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuraiton: configuration)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 44)
    }
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        
        addPinnedSubview(textView, height: 200)
        textView.backgroundColor = nil
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        #warning("INFO: we need a delegate to intervene when the text view detects a user interaction")
        textView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(configuraiton: UIContentConfiguration) {
        guard let configuration = configuraiton as? Configuration else { return }
        textView.text = configuration.text
    }
    
}

extension UICollectionViewListCell {
    func textViewConfiguration() -> TextViewContentView.Configuration {
        TextViewContentView.Configuration()
    }
}

extension TextViewContentView: UITextViewDelegate {
    /// The delegate calls this method whenever it detects a user interaction
    func textViewDidChange(_ textView: UITextView) {
        guard let configuration = configuration as? TextViewContentView.Configuration else { return }
        configuration.onChange(textView.text)
    }
}
