//
//  UIWindow+VT.swift
//  Labour Choice
//
//  Created by Umair on 24/08/2017.
//  Copyright © 2017 talha. All rights reserved.
//

import Foundation
import UIKit

extension UIWindow {

    func replaceRootViewControllerWith(_ replacementController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        let snapshotImageView = UIImageView(image: self.snapshot())
        self.addSubview(snapshotImageView)

        let dismissCompletion = { () -> Void in // dismiss all modal view controllers
            self.rootViewController = replacementController
            self.bringSubview(toFront: snapshotImageView)

            if animated {

                UIView.animate(withDuration: 0.4, animations: { () -> Void in
                    snapshotImageView.alpha = 0
                }, completion: { (success) -> Void in
                    snapshotImageView.removeFromSuperview()
                    completion?()
                })

            } else {
                snapshotImageView.removeFromSuperview()
                completion?()
            }
        }

        if self.rootViewController!.presentedViewController != nil {
            self.rootViewController!.dismiss(animated: false, completion: dismissCompletion)

        } else {
            dismissCompletion()
        }
    }

    func topMostViewController() -> UIViewController? {
        return self.window?.rootViewController?.topMostViewController()
    }
}
