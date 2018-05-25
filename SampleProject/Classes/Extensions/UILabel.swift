//
//  UILabel.swift
//  PamperMoi
//
//  Created by Zeeshan@Vizteck on 24/04/2018.
//  Copyright © 2018 Umair Afzal. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    @IBInspectable var localized : Bool {
        get {
            if self.text == nil && self.attributedText == nil
            {
                return false
            }
            return true
        }
        set{
            
            var range = NSRange()
            self.attributedText?.attributes(at: 0, effectiveRange: &range)
            let isAttribute : Bool = self.text?.length != range.length
            if !isAttribute {
                if let text = self.text {
                    self.text = text.localized
                }
            }
            else {
                if let attributedText = self.attributedText
                {
                    var boldText : String = ""
                    var boldFontApply : UIFont = UIFont.systemFont(ofSize: 14.0)
                    var regularFontApply : UIFont = UIFont.systemFont(ofSize: 14.0)
                    attributedText.enumerateAttribute(.font, in: NSRange(location: 0, length: attributedText.length), options: NSAttributedString.EnumerationOptions.longestEffectiveRangeNotRequired) { (value, range, stop) in
                        
                        let boldFont = UIFont.appThemeBoldFontWithSize(self.font.pointSize)
                        let regularFont = UIFont.appThemeFontWithSize(self.font.pointSize)
                        if  value as? UIFont == boldFont {
                            
                            boldText = "\(attributedText.attributedSubstring(from: range).string) b"
                            boldFontApply = boldFont
                        }
                        if  value as? UIFont == regularFont {
                            regularFontApply = regularFont
                        }
                    }
                    
                    
                    let attributedTitle = NSMutableAttributedString.init(attributedString: attributedText)
                    attributedTitle.mutableString.setString(attributedTitle.string.localized)
                    
                    let range = (attributedTitle.string as NSString).range(of: boldText.localized)
                    
                    attributedTitle.addAttribute(NSAttributedStringKey.font, value: regularFontApply, range: NSRange(location: 0, length: attributedText.string.localized.length))
                    attributedTitle.addAttribute(NSAttributedStringKey.font, value: boldFontApply, range: range)
                    self.attributedText = attributedTitle
                }
            }
        }
    }
}
