//
//  UIButton+VT.swift
//  Labour Choice
//
//  Created by Umair on 06/10/2017.
//  Copyright © 2017 Umair Afzal. All rights reserved.
//

import Foundation
import UIKit

private var handle: UInt8 = 0

extension UIButton {

    private var badgeLayer: CAShapeLayer? {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as? CAShapeLayer
        } else {
            return nil
        }
    }

    func addBadge(number: Int, withOffset offset: CGPoint = CGPoint.zero, andColor color: UIColor = UIColor.red, andFilled filled: Bool = true, position: BadgePosition = .topRight) {
        //guard let view = self.value(forKey: "view") as? UIView else { return }

        badgeLayer?.removeFromSuperlayer()

        // Initialize Badge
        let badge = CAShapeLayer()
        let radius = CGFloat(10)
        let label = CATextLayer()

        var location: CGPoint?

        switch position {

        case .topRight:
            location = CGPoint(x: self.frame.width + 3.0, y: radius)
            label.frame = CGRect(origin: CGPoint(x: self.frame.width - 3.0, y: radius/2 - 2), size: CGSize(width: 12, height: 16))

        case .topLeft:
            location = CGPoint(x: 3.0, y: radius)
            label.frame = CGRect(origin: CGPoint(x: -3.0, y: radius/2 - 2), size: CGSize(width: 12, height: 16))

        case .left:
            location = CGPoint(x: 3.0, y: (radius + offset.y+2.0))
            label.frame = CGRect(origin: CGPoint(x: -3.0, y: radius/2 - 2), size: CGSize(width: 12, height: 16))

        case .right:
            location = CGPoint(x: 3.0, y: (radius + offset.y+2.0))
            label.frame = CGRect(origin: CGPoint(x: -3.0, y: radius/2 - 2), size: CGSize(width: 12, height: 16))

        case .bottomLeft:
            location = CGPoint(x: 3.0, y: self.frame.height - 5)
            label.frame = CGRect(origin: CGPoint(x: -3.0, y: self.frame.height-12), size: CGSize(width: 12, height: 16))

        case .bottomRight:
            location = CGPoint(x: self.frame.width + 3.0, y: self.frame.height - 5)
            label.frame = CGRect(origin: CGPoint(x: self.frame.width - 3.0, y: self.frame.height-12), size: CGSize(width: 12, height: 16))

        case .top:
            location = CGPoint(x: 3.0, y: (radius + offset.y+2.0))
            label.frame = CGRect(origin: CGPoint(x: -3.0, y: radius/2 - 2), size: CGSize(width: 12, height: 16))

        default: // Bottom
            location = CGPoint(x: 3.0, y: (radius + offset.y+2.0))
            label.frame = CGRect(origin: CGPoint(x: -3.0, y: radius/2 - 2), size: CGSize(width: 12, height: 16))
        }

        badge.drawCircleAtLocation(location: location!, withRadius: radius, andColor: color, filled: filled)
        self.layer.addSublayer(badge)

        // Initialiaze Badge's label
        label.string = "\(number)"
        label.alignmentMode = kCAAlignmentCenter
        label.fontSize = 11
        label.foregroundColor = filled ? UIColor.white.cgColor : color.cgColor
        label.backgroundColor = UIColor.clear.cgColor
        label.contentsScale = UIScreen.main.scale
        badge.addSublayer(label)

        // Save Badge as UIBarButtonItem property
        objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    func updateBadge(number: Int) {
        if let text = badgeLayer?.sublayers?.filter({ $0 is CATextLayer }).first as? CATextLayer {
            text.string = "\(number)"
        }
    }

    func removeBadge() {
        badgeLayer?.removeFromSuperlayer()
    }
    
    @IBInspectable var localized : Bool {
        get {
            guard let _ = self.titleLabel else { return false }
            return true
        }
        set{
            
            guard let titleLabel = self.titleLabel else { return }
            var range = NSRange()
            titleLabel.attributedText?.attributes(at: 0, effectiveRange: &range)
            let isAttribute : Bool = titleLabel.text?.length != range.length
            if !isAttribute
            {
                if let text = self.titleLabel?.text
                {
                    setTitle(text.localized, for: self.state)
                }
            }
            else
            {
                if let attributedText = titleLabel.attributedText, attributedText.string.isEmpty == false
                {
                    let attributedTitle = NSMutableAttributedString.init(attributedString: attributedText)
                    attributedTitle.mutableString.setString(attributedTitle.string.localized)
                    setAttributedTitle(attributedTitle, for: self.state)
                }
            }
        }
    }
}
