//
//  NSMutableAttributedString+VT.swift
//  Help Connect
//
//  Created by Umair Afzal on 18/01/2018.
//  Copyright © 2018 Umair Afzal. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {

    @discardableResult func bold(_ text:String, color: UIColor = .black) -> NSMutableAttributedString {
        let attrs:[NSAttributedStringKey:AnyObject] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): UIFont.appThemeBoldFontWithSize(15.0), NSAttributedStringKey.foregroundColor: color]
        let boldString = NSMutableAttributedString(string: text, attributes:attrs)
        self.append(boldString)
        return self
    }
    
    @discardableResult func attributedString(withText text:String, color: UIColor = .black, alignment : NSTextAlignment, fontSize : CGFloat , fontTypeface : FontTypeface = FontTypeface.bold, isUnderLine: Bool = false, boldString : String? = nil) -> NSMutableAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment
        var attrs:[NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: color, .paragraphStyle: paragraph]
        if isUnderLine
        {
            attrs[.underlineStyle] = NSUnderlineStyle.styleSingle.rawValue
        }
        switch fontTypeface {
        case .bold:
            attrs[NSAttributedStringKey.font] =  UIFont.appThemeBoldFontWithSize(fontSize)
        case .semiBold:
            attrs[NSAttributedStringKey.font] =  UIFont.appThemeSemiBoldFontWithSize(fontSize)
        case .medium:
            attrs[NSAttributedStringKey.font] =  UIFont.appThemeMediumFontWithSize(fontSize)
        case .seventSegment:
            attrs[NSAttributedStringKey.font] =  UIFont.sevenSegmentFontWithSize(fontSize)
        case .regular :
            attrs[NSAttributedStringKey.font] =  UIFont.appThemeFontWithSize(fontSize)
        default:
            attrs[NSAttributedStringKey.font] =  UIFont.systemFont(ofSize: fontSize)
        }
        let attributedString = NSMutableAttributedString(string: text, attributes:attrs)
        
        if let boldString = boldString
        {
            let range = (text as NSString).range(of: boldString)
            attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.appThemeBoldFontWithSize(fontSize), range: range)
        }
        
        self.append(attributedString)
        return self
    }
    
    func attributedString(withText text:String, color: UIColor = .black, alignment : NSTextAlignment, font : UIFont, underlineString: String? = nil, boldString : String? = nil, blodFont : UIFont? = nil) -> NSMutableAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment
        let attrs:[NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: color, .paragraphStyle: paragraph, .font : font]
        
        let attributedString = NSMutableAttributedString(string: text, attributes:attrs)
        
        if let boldString = boldString
        {
            let range = (text as NSString).range(of: boldString)
            attributedString.addAttribute(NSAttributedStringKey.font, value: blodFont ?? UIFont.systemFont(ofSize: font.pointSize + 4.0), range: range)
        }
        
        if let underlineString = underlineString
        {
            let range = (text as NSString).range(of: underlineString)
            attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: range)
        }
        
        self.append(attributedString)
        return self
    }

    @discardableResult func normal(_ text:String)->NSMutableAttributedString {
        let normal =  NSAttributedString(string: text)
        self.append(normal)
        return self
    }
}
