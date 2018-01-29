//
//  VTButton.swift
//  Help Connect
//
//  Created by Umair Afzal on 13/12/2017.
//  Copyright © 2017 Umair Afzal. All rights reserved.
//

import Foundation
import UIKit

class VTButton: UIButton {

    init() {
        super.init(frame: CGRect.zero)

        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    func setup() {
        titleLabel?.font = UIFont.appThemeFontWithSize(20.0)
        backgroundColor = #colorLiteral(red: 0.9552288651, green: 0.4561077356, blue: 0.2077901065, alpha: 1)
        contentHorizontalAlignment = .center
        layer.cornerRadius = frame.height / 2.0
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.0
        setTitleColor(UIColor.white, for: UIControlState())
    }
}
