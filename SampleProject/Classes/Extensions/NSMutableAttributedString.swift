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

    @discardableResult func normal(_ text:String)->NSMutableAttributedString {
        let normal =  NSAttributedString(string: text)
        self.append(normal)
        return self
    }
}
