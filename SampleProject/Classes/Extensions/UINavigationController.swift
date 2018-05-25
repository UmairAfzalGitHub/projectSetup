//
//  UINavigationController+VT.swift
//  Labour Choice
//
//  Created by Umair on 6/19/17.
//  Copyright © 2017 Umair. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {

    func transparentNavigationBar() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.navigationBar.barTintColor = UIColor.clear
        self.navigationBar.backgroundColor = .clear
    }

    func setAttributedTitle() {
        let attributes = [NSAttributedStringKey.font: UIFont.appThemeFontWithSize(19.0), NSAttributedStringKey.foregroundColor: UIColor.white] //change size as per your need here.
        self.navigationBar.titleTextAttributes = attributes
    }

    func setupAppThemeNavigationBar() {
        navigationBar.setBackgroundImage(nil, for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.barTintColor = #colorLiteral(red: 0.1450980392, green: 0.0862745098, blue: 0.1803921569, alpha: 1)
        navigationBar.isTranslucent = false
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.appThemeFontWithSize(20.0)]
    }
}
