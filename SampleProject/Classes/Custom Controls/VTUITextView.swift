//
//  VTUITextView.swift
//  Labour Choice Labour
//
//  Created by Umair on 22/08/2017.
//  Copyright © 2017 vizteck. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable public class VTUITextView: UITextView, UITextViewDelegate {

    @IBInspectable public var placeHolder: String = ""

    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)

        setupPlaceHolder()
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

        setupPlaceHolder()
        self.delegate = self
    }

    @IBInspectable
    public var placeholderTextt: String = "" {
        didSet {
            self.placeHolder = placeholderTextt
            self.setupPlaceHolder()
            self.setNeedsLayout()
        }
    }

    func setupPlaceHolder() {

        if placeHolder != "" {
            self.attributedText = NSAttributedString(string: self.placeHolder, attributes: [NSAttributedStringKey.foregroundColor: UIColor.emailTextFiledPlaceHolderTextColor(), NSAttributedStringKey.font: UIFont.appThemeFontWithSize(15.0)])
            self.setNeedsLayout()
            self.setNeedsDisplay()
        }
    }

    public func textViewDidBeginEditing(_ textView: UITextView) {

    }

    public func textViewDidChange(_ textView: UITextView) {

        if textView.text == "" {
            setupPlaceHolder()
        }
    }

    public override func shouldChangeText(in range: UITextRange, replacementText text: String) -> Bool {
        
        return true
    }
}
