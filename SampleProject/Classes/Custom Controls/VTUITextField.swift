//
//  VTUITextField.swift
//  Labour Choice
//
//  Created by Umair on 21/06/2017.
//  Copyright © 2017 talha. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField

class VTUITextField: SkyFloatingLabelTextField, UITextFieldDelegate {

    var isCreditCardTextField = false
    var isExpirayDateTextField =  false
    var isCvvField = false
    var isMobileNumberField = false
    var isVerificationCodeTextField = false

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupPlaceHolder()
        setupPadding()
        self.delegate = self
    }

    required override init(frame: CGRect) {
        super.init(frame: frame)
        setupPlaceHolder()
        setupPadding()
        self.delegate = self
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        _ = super.textRect(forBounds: bounds)
        let rect = CGRect(
            x: 0, // 10
            y: titleHeight(),
            width: bounds.size.width,  //- 25,
            height: bounds.size.height - titleHeight() - selectedLineHeight
        )
        return rect
    }

    override func titleLabelRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {

        if editing {
            return CGRect(x: 0, y: 0, width: bounds.size.width-10, height: titleHeight())
        }

        return CGRect(x: 0, y: titleHeight(), width: bounds.size.width-10, height: titleHeight())
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = CGRect(
            x: 0, // 10
            y: titleHeight(),
            width: bounds.size.width,  //-25,
            height: bounds.size.height - titleHeight() - selectedLineHeight + 5
        )
        return rect
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let rect = CGRect(
            x: 0, //10
            y: titleHeight(),
            width: bounds.size.width,
            height: bounds.size.height - titleHeight() - selectedLineHeight
        )
        return rect
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= 00 // 10
        return textRect
    }

    func setupPlaceHolder(){
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedStringKey.foregroundColor: UIColor.emailTextFiledPlaceHolderTextColor(), NSAttributedStringKey.font: UIFont.appThemeFontWithSize(15.0)])
        self.title = self.placeholder

        self.lineColor = UIColor.PasswordTextFieldBorderColor()
        self.selectedLineColor = UIColor.emailTextFieldBorderColor()
        //self.selectedTitleColor = UIColor.textFieldTitleColor()

        self.titleFormatter = { (text: String) -> String in // to avoid Upper casing of title
            return text
        }

        self.font = UIFont.appThemeFontWithSize(17.0)
        self.titleLabel.font = UIFont.appThemeFontWithSize(14.0)
        self.titleLabel.isUserInteractionEnabled = false
        self.textColor = UIColor.appThemeBlackColor()
        self.placeholderColor = UIColor.textFieldPlaceHolderColor()
        //self.autocapitalizationType = .sentences
        self.borderStyle = .none

        if isVerificationCodeTextField {
            self.font = UIFont.appThemeFontWithSize(25.0)
            self.textAlignment = .center
        }
    }

    func setupPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10.0, height: self.frame.size.height))
        rightView = paddingView
        leftView = paddingView
        leftViewMode = .always
        rightViewMode = .always
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {

        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }


    // MARK: - UITextField Delegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        return false
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.errorMessage = ""
        self.titleColor = UIColor.appThemeColor()
        self.selectedLineColor = UIColor.appThemeColor()
        self.lineColor = UIColor.appThemeColor()

        if isCreditCardTextField {
            guard let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }
            let currentLength: Int = currentText.count

            if currentLength == 20 {
                textField.resignFirstResponder()
                return false
            }

            textField.text = currentText.grouping(every: 4, with: " ")
            return false

        } else if isExpirayDateTextField {
            guard let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }
            let currentLength: Int = currentText.count

            if currentLength == 6 {
                textField.resignFirstResponder()
                return false
            }

            textField.text = currentText.grouping(every: 2, with: "/")
            return false

        } else if isCvvField {
            guard let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }
            let currentLength: Int = currentText.count

            if currentLength == 4 {
                textField.resignFirstResponder()
                return false
            }
        }

        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.titleColor = UIColor.appThemeColor()
        self.selectedTitleColor = UIColor.appThemeColor()
        self.selectedLineColor = UIColor.appThemeColor()
        self.lineColor = UIColor.appThemeColor()

        if isMobileNumberField && textField.text == "" {
            textField.text = "+1"
        }

        if isVerificationCodeTextField {
            textField.font = UIFont.appThemeFontWithSize(25.0)
            textField.textAlignment = .center
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.titleColor = UIColor.lightGray
        self.selectedTitleColor = UIColor.lightGray
        self.selectedLineColor = UIColor.lightGray
        self.lineColor = UIColor.lightGray
    }
}
