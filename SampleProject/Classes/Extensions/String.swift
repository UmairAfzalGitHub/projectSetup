//
//  String+VT.swift
//  Labour Choice
//
//  Created by talha on 19/06/2017.
//  Copyright © 2017 talha. All rights reserved.
//

import UIKit
import Foundation

extension String
{
    var length: Int {
        return self.count
    }

    func fromBase64() -> String
    {
        let data = Data(base64Encoded: self, options: NSData.Base64DecodingOptions(rawValue: 0))
        return String(data: data!, encoding: String.Encoding.utf8)!
    }

    func toBase64() -> String
    {
        let data = self.data(using: String.Encoding.utf8)
        return data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    }

    func isValidEmail() -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)

        let result =  emailPredicate.evaluate(with: self)

        return result

    }

    func isValidPassword() -> Bool {
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789")

        if rangeOfCharacter(from: characterset.inverted) != nil && length >= 8 {
            return true

        } else {
            return false
        }
    }

    static func makeTextUnderLineAndCenter(preText: String, underLineText: String, postText: String) -> NSAttributedString {

        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center

        let underlineAttrs = [NSAttributedStringKey.font: UIFont.appThemeFontWithSize(16.0) as AnyObject, NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue as AnyObject, NSAttributedStringKey.paragraphStyle: style as AnyObject]
        let attributedString = NSMutableAttributedString(string:underLineText, attributes:underlineAttrs as [NSAttributedStringKey:AnyObject])

        let lightAttr = [NSAttributedStringKey.font: UIFont.appThemeFontWithSize(16.0) as AnyObject, NSAttributedStringKey.paragraphStyle: style as AnyObject]
        let finalAttributedText = NSMutableAttributedString(string:preText, attributes:lightAttr as [NSAttributedStringKey:AnyObject])

        let postText = NSMutableAttributedString(string:postText, attributes:lightAttr as [NSAttributedStringKey:AnyObject])

        finalAttributedText.append(attributedString)
        finalAttributedText.append(postText)

        return finalAttributedText
    }

    static func makeTextBold(_ preBoldText:String, boldText:String, postBoldText:String, fontSzie:CGFloat) -> NSAttributedString {

        let boldAttrs = [NSAttributedStringKey.font: UIFont.appThemeBoldFontWithSize(fontSzie) as AnyObject]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:boldAttrs as [NSAttributedStringKey:AnyObject])

        let lightAttr = [NSAttributedStringKey.font: UIFont.appThemeFontWithSize(fontSzie) as AnyObject]
        let finalAttributedText = NSMutableAttributedString(string:preBoldText, attributes:lightAttr as [NSAttributedStringKey:AnyObject])

        let postText = NSMutableAttributedString(string:postBoldText, attributes:lightAttr as [NSAttributedStringKey:AnyObject])

        finalAttributedText.append(attributedString)
        finalAttributedText.append(postText)

        return finalAttributedText
    }

    static func makeTextSemiBold(_ preBoldText:String, boldText:String, postBoldText:String, fontSzie:CGFloat) -> NSAttributedString {

        let boldAttrs = [NSAttributedStringKey.font : UIFont.appThemeSemiBoldFontWithSize(fontSzie) as AnyObject]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:boldAttrs as [NSAttributedStringKey:AnyObject])

        let lightAttr = [NSAttributedStringKey.font : UIFont.appThemeFontWithSize(fontSzie) as AnyObject]
        let finalAttributedText = NSMutableAttributedString(string:preBoldText, attributes:lightAttr as [NSAttributedStringKey:AnyObject])

        let postText = NSMutableAttributedString(string:postBoldText, attributes:lightAttr as [NSAttributedStringKey:AnyObject])

        finalAttributedText.append(attributedString)
        finalAttributedText.append(postText)

        return finalAttributedText
    }

    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) { return self }
        return String( Array(self).prefix(upTo: n) )
    }

    func grouping(every groupSize: String.IndexDistance, with separator: Character) -> String {
        let cleanedUpCopy = replacingOccurrences(of: String(separator), with: "")
        return String(cleanedUpCopy.enumerated().map() {
            $0.offset % groupSize == 0 ? [separator, $0.element] : [$0.element]
            }.joined().dropFirst())
    }
}
