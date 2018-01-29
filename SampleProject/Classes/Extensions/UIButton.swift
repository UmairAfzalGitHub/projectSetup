//
//  UIButton+VT.swift
//  Labour Choice
//
//  Created by Umair on 06/10/2017.
//  Copyright © 2017 talha. All rights reserved.
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
            location = CGPoint(x: self.frame.width - (radius + offset.x+2.0), y: (radius + offset.y+4.0))
            label.frame = CGRect(origin: CGPoint(x: (location?.x)! - 4, y: offset.y+4.0), size: CGSize(width: 12, height: 16))

        case .topLeft:
            location = CGPoint(x: 3.0, y: (radius + offset.y+2.0))
            label.frame = CGRect(origin: CGPoint(x: -3.0, y: 5.0), size: CGSize(width: 12, height: 16))

        case .left:
            location = CGPoint(x: self.frame.width - (radius + offset.x-5.0), y: (radius + offset.y-5.0))
            label.frame = CGRect(origin: CGPoint(x: (location?.x)! - 4, y: offset.y-5.0), size: CGSize(width: 12, height: 16))

        default: // right
            location = CGPoint(x: self.frame.width - (radius + offset.x-5.0), y: (radius + offset.y-5.0))
            label.frame = CGRect(origin: CGPoint(x: (location?.x)! - 4, y: offset.y-5.0), size: CGSize(width: 12, height: 16))
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
}
