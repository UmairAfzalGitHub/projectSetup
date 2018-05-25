//
//  Error+VT.swift
//  Labour Choice
//
//  Created by Umair on 13/07/2017.
//  Copyright © 2017 Umair Afzal. All rights reserved.
//

import Foundation
import UIKit

extension Error {

    func showErrorBelowNavigation(viewController: UIViewController) {
        let errorView = UIView(frame: CGRect(x: 0, y: 0, width: Utility.getScreenWidth(), height: 40))
        let errorLabel = UILabel(frame: CGRect(x: errorView.frame.origin.x + 10, y: 0.0, width: errorView.frame.width-10, height: errorView.frame.height))

        errorView.backgroundColor = UIColor.errorViewColor().withAlphaComponent(0.8)
        errorLabel.text = localizedDescription
        errorLabel.textAlignment = .center
        errorLabel.textColor = UIColor.white
        errorLabel.font = UIFont.appThemeFontWithSize(13.0)
        errorLabel.numberOfLines = 0

        errorView.addSubview(errorLabel)
        viewController.view.addSubview(errorView)
        viewController.view.bringSubview(toFront: errorView)

        let when = DispatchTime.now() + 1.5 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {

            errorView.alpha = 1.0

            UIView.animate(withDuration: 1.0, animations: {
                errorView.alpha = 0.0

            }, completion: { (completed) in
                errorView.removeFromSuperview()
            })
        }
    }
}
