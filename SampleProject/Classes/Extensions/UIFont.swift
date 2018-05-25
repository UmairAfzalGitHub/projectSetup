//
//  UIFont+VT.swift
//  Labour Choice
//
//  Created by Umair Afzal on 19/06/2017.
//  Copyright © 2017 Umair Afzal. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {

    class func appThemeFontWithSize(_ fontSize: CGFloat) -> UIFont {

        if let font = UIFont(name: "Helvetica Neue", size: fontSize) {
            return font
        }

        return UIFont.systemFont(ofSize: fontSize)
    }

    class func appThemeBoldFontWithSize(_ fontSize: CGFloat) -> UIFont {

        if let font = UIFont(name: "HelveticaNeue-Bold", size: fontSize) {
            return font
        }

        return UIFont.systemFont(ofSize: fontSize)
    }
    
    class func appThemeMediumFontWithSize(_ fontSize: CGFloat) -> UIFont {
        
        if let font = UIFont(name: "HelveticaNeue-Medium", size: fontSize) {
            return font
        }
        
        return UIFont.systemFont(ofSize: fontSize)
    }

    class func appThemeSemiBoldFontWithSize(_ fontSize: CGFloat) -> UIFont {

        if let font = UIFont(name: "MuseoSans-500", size: fontSize) {
            return font
        }

        return UIFont.systemFont(ofSize: fontSize)
    }

    class func sevenSegmentFontWithSize(_ fontSize: CGFloat) -> UIFont {

        if let font = UIFont(name: "DBVTDTempBlack", size: fontSize) {
            return font
        }

        return UIFont.systemFont(ofSize: fontSize)
    }

}
