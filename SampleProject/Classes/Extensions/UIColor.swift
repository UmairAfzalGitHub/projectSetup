//
//  UIColor+VT.swift
//  passManager
//
//  Created by Umair on 6/19/17.
//  Copyright © 2017 Umair. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    class func CustomColorFromHexaWithAlpha (_ hex:String, alpha:CGFloat) -> UIColor {
        var cString:String = hex.trimmingCharacters(in:(CharacterSet.whitespacesAndNewlines as CharacterSet) as CharacterSet).uppercased()

        if cString.hasPrefix("#") {
            cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 1))
        }

        if cString.count != 6 {
            return UIColor.gray
        }

        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }

    func convertImage() -> UIImage {
        let rect : CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context : CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(self.cgColor)
        context.fill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return image
    }

    class func appThemeBlackColor(_ alpha: CGFloat = 1.0) -> UIColor {
        let hex = "2d3939"
        return UIColor.CustomColorFromHexaWithAlpha(hex, alpha: alpha)
    }

    class func createAccountButtonBackGroundColorWithAlpha(_ alpha: CGFloat) -> UIColor {
        let hex = "00A9BB"
        return UIColor.CustomColorFromHexaWithAlpha(hex, alpha: alpha)
    }

    class func emailTextFieldBorderColor() -> UIColor {
        let hex = "bdbdbd"
        return UIColor.CustomColorFromHexaWithAlpha(hex, alpha: 1.0)
    }

    class func PasswordTextFieldBorderColor() -> UIColor {
        let hex = "e0e0df"
        return UIColor.CustomColorFromHexaWithAlpha(hex, alpha: 1.0)
    }

    class func appThemeButtonColor() -> UIColor {
        let hex = "ee5e29"
        return UIColor.CustomColorFromHexaWithAlpha(hex, alpha: 1.0)
    }

    class func appThemeColor() -> UIColor {
        let hex = "8E5B9D"
        return UIColor.CustomColorFromHexaWithAlpha(hex, alpha: 1.0)
    }

    class func emailTextFiledPlaceHolderTextColor() -> UIColor {
        let hex = "b8b8b8"
        return UIColor.CustomColorFromHexaWithAlpha(hex, alpha: 1.0)
    }

    class func textFieldTextColor() -> UIColor {
        let hex = "6f6f70"
        return UIColor.CustomColorFromHexaWithAlpha(hex, alpha: 1.0)
    }

    class func textFieldPlaceHolderColor() -> UIColor {
        let hex = "9a9999"
        return UIColor.CustomColorFromHexaWithAlpha(hex, alpha: 1.0)
    }

    class func errorViewColor() -> UIColor {
        let hex = "f75543"
        return UIColor.CustomColorFromHexaWithAlpha(hex, alpha: 1.0)
    }
}
