//
//  UIView+VT.swift
//  Labour Choice
//
//  Created by Umair on 03/07/2017.
//  Copyright © 2017 Umair Afzal. All rights reserved.
//

import Foundation
import UIKit

enum VerticalLocation: String {
    case bottom
    case top
}

enum UIViewCorners: String {
    case bottomLeft
    case topLeft
    case topRight
    case bottomRight
}

@IBDesignable
class DesignableView: UIView {
}

@IBDesignable
class DesignableButton: UIButton {
}

@IBDesignable
class DesignableLabel: UILabel {
}

extension UIView {

    @IBInspectable
    var isCirculer: Bool {

        get {
            return layer.cornerRadius == min(self.frame.width, self.frame.height) / CGFloat(2.0) ? true : false
        }

        set {

            if newValue {
                layer.cornerRadius = self.frame.height/2
                self.clipsToBounds = true

            } else {
                layer.cornerRadius = 0.0
                self.clipsToBounds = false
            }
        }
    }

    @IBInspectable
    var cornerRadius: CGFloat {

        get {
            return layer.cornerRadius
        }

        set {
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        
        get {
            return layer.borderWidth
        }

        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable
    var borderColor: UIColor? {

        get {

            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }

        set {

            if let color = newValue {
                layer.borderColor = color.cgColor

            } else {
                layer.borderColor = nil
            }
        }
    }

    @IBInspectable
    var shadowRadius: CGFloat {

        get {
            return layer.shadowRadius
        }

        set {
            layer.shadowRadius = newValue
        }
    }

    @IBInspectable
    var shadowOpacity: Float {

        get {
            return layer.shadowOpacity
        }

        set {
            layer.shadowOpacity = newValue
        }
    }

    @IBInspectable
    var shadowOffset: CGSize {

        get {
            return layer.shadowOffset
        }

        set {
            layer.shadowOffset = newValue
        }
    }

    @IBInspectable
    var shadowColor: UIColor? {

        get {

            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }

        set {

            if let color = newValue {
                layer.shadowColor = color.cgColor

            } else {
                layer.shadowColor = nil
            }
        }
    }

    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }

    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }

    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }

    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }

    func addShadow(location: VerticalLocation, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {

        switch location {

        case .bottom:
            addShadow(offset: CGSize(width: 0, height: 10), color: color, opacity: opacity, radius: radius)

        case .top:
            addShadow(offset: CGSize(width: 0, height: -1.5), color: color, opacity: opacity, radius: radius)
        }
    }

    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }

    func snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }

    func roundCorner(uiViewCorner: UIViewCorners, radius: CGFloat = 5.0) {

        switch uiViewCorner {

        case .topLeft:
            let maskPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners:[.topLeft], cornerRadii: CGSize.init(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = maskPath.cgPath
            self.layer.mask = maskLayer

        case .topRight:
            let maskPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners:[.topRight], cornerRadii: CGSize.init(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = maskPath.cgPath
            self.layer.mask = maskLayer

        case .bottomLeft:
            let maskPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners:[.bottomLeft], cornerRadii: CGSize.init(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = maskPath.cgPath
            self.layer.mask = maskLayer

        case .bottomRight:
            let maskPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners:[.bottomRight], cornerRadii: CGSize.init(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = maskPath.cgPath
            self.layer.mask = maskLayer
        }
    }

    func roundCorners(uiViewCorners: VerticalLocation, radius: CGFloat = 5.0) {

        switch uiViewCorners {

        case .top:
            let maskPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners:[.topLeft, .topRight], cornerRadii: CGSize.init(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = maskPath.cgPath
            self.layer.mask = maskLayer
            self.layoutIfNeeded()

        case .bottom:
            let maskPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners:[.bottomLeft, .bottomRight], cornerRadii: CGSize.init(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = maskPath.cgPath
            self.layer.mask = maskLayer
            self.layoutIfNeeded()
        }
    }
    
    func addRoundCorners(cornerRadius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
}
