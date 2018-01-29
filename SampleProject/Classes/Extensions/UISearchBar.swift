//
//  UISearchBar+VT.swift
//  Labour Choice
//
//  Created by Umair on 18/07/2017.
//  Copyright © 2017 talha. All rights reserved.
//

import Foundation
import UIKit

public extension UISearchBar {

    private func getViewElement<T>(type: T.Type) -> T? {

        let svs = subviews.flatMap { $0.subviews }
        guard let element = (svs.filter { $0 is T }).first as? T else { return nil }
        return element
    }

    func getSearchBarTextField() -> UITextField? {

        return getViewElement(type: UITextField.self)
    }

    func setTextColor(color: UIColor) {

        if let textField = getSearchBarTextField() {
            textField.textColor = color
        }
    }

    public func setPlaceholderTextColor(color: UIColor) {

        if let textField = getSearchBarTextField() {
            textField.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSAttributedStringKey.foregroundColor: color])
        }
    }

    func setSearchImageColor(color: UIColor) {

        if let imageView = getSearchBarTextField()?.leftView as? UIImageView {
            imageView.image = imageView.image?.transform(withNewColor: color)
        }
    }
}
