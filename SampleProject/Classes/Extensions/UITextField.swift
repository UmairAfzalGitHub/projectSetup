//
//  UITextField+VT.swift
//  Labour Choice
//
//  Created by talha on 20/06/2017.
//  Copyright © 2017 talha. All rights reserved.
//

import Foundation
import UIKit

private var __maxLengths = [UITextField: Int]()

extension UITextField {

    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }

    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }

    func useUnderline(with color:UIColor) {

        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width: self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
