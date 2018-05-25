//
//  CAShapeLayer+VT.swift
//  Labour Choice
//
//  Created by Umair on 06/10/2017.
//  Copyright © 2017 Umair Afzal. All rights reserved.
//

import Foundation
import UIKit

extension CAShapeLayer {

    func drawCircleAtLocation(location: CGPoint, withRadius radius: CGFloat, andColor color: UIColor, filled: Bool) {
        fillColor = filled ? color.cgColor : UIColor.white.cgColor
        strokeColor = color.cgColor
        let origin = CGPoint(x: location.x - radius, y: location.y - radius)
        path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2))).cgPath
    }
}
