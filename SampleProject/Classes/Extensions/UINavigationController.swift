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
        self.view.backgroundColor = .clear
    }

    func setAttributedTitle() {
        let attributes = [NSAttributedStringKey.font: UIFont.appThemeFontWithSize(19.0), NSAttributedStringKey.foregroundColor: UIColor.white] //change size as per your need here.
        self.navigationBar.titleTextAttributes = attributes
    }

    func setupAppThemeNavigationBar() {
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = .appThemeColor()
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.appThemeFontWithSize(20.0)]
    }
}
