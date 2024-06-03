//
//  TextFieldContentView.swift
//  Today-Sample-Project
//
//  Created by Vanessa Chambers on 5/29/24.
//

import UIKit

#warning("INFO: conforming to teh content view protocol signals that the view renders the content and styling provided in the configuration")
class TextFieldContentView: UIView, UIContentView{
    
    #warning("INFO: content configurations keep the UI in sync with the app's state. We should update the UI whenever the configuration property changes")
    struct Configuration: UIContentConfiguration {
        var text: String? = ""
        var onChange: (String) -> Void = { _ in }
        func makeContentView() -> UIView & UIContentView {
            return TextFieldContentView(self)
        }
    }
    let textField = UITextField()
    var configuration: UIContentConfiguration {
        /// whenever config changse, call the configure method
        didSet {
            configure(configuration: configuration)
        }
    }
    
    #warning("INFO: setting this property allows us to use a preferred size rather than the intrinsic content side, which in this case is based on the size of the text the label displays")
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 44)
    }
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        /// we want to initialize the view with no size and then control the final layout with constraints
        super.init(frame: .zero)
        addPinnedSubview(textField, insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        /// displays a clear text button on the trailing side when it has contents
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(didChange(_:)), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else {
            return
        }
        textField.text = configuration.text
        
    }
    
    #warning("INFO: @objc attribute makes a property or method available to Objective-C code. This is necessary because many UIKit components, like gesture recognizers and buttons rely on Obj-C runtime to perform actiona nd callbacks")
    @objc func didChange(_ sender: UITextField) {
        guard let configuration = configuration as? TextFieldContentView.Configuration else { return }
        configuration.onChange(textField.text ?? "")
    }
}

extension UICollectionViewListCell {
    func textFieldConfiguration() -> TextFieldContentView.Configuration {
        TextFieldContentView.Configuration()
    }
}
