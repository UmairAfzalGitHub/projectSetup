//
//  UIPanGestureRecognizer.swift
//  TT-Driver
//
//  Created by Umair Afzal on 17/07/2018.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import Foundation
import UIKit

public enum PanDirection: Int {
    case up,
    down,
    left,
    right

    public var isX: Bool {
        return self == .left || self == .right
    }

    public var isY: Bool {
        return !isX
    }
}

extension UIPanGestureRecognizer {
    var direction: PanDirection? {
        let velocity = self.velocity(in: view)
        let vertical = fabs(velocity.y) > fabs(velocity.x)
        switch (vertical, velocity.x, velocity.y) {
        case (true, _, let y):
            return y < 0 ? .up : .down

        case (false, let x, _):
            return x > 0 ? .right : .left
        }
    }
}
