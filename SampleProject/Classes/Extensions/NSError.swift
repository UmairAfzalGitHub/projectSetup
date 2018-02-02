//
//  NSError+VT.swift
//  Labour Choice
//
//  Created by talha on 19/06/2017.
//  Copyright © 2017 talha. All rights reserved.
//

import Foundation
import UIKit
import SocketIO

let VTErrorDomain = "com.errordomain.VT"
let VTFormErrorCode = 40001
typealias VTAlertCompletionHandler = (_ retry: Bool, _ cancel: Bool) -> Void

extension NSError {

    func alertControllerWithTitle(_ title: String) -> VTAlertViewController {
        return VTAlertViewController(title: title, message: localizedDescription, style: .alert)
    }

    func showServerErrorInViewController(_ viewController: UIViewController) {
        let alertViewController = alertControllerWithTitle("")

        let okAction = VTAlertAction(title: "OK", style: .default) { (action) in

            if self.localizedDescription == kErrorSessionExpired {
                Utility.setSignViewControllerAsRoot()
            }
        }

        alertViewController.addAction(okAction)
        viewController.present(alertViewController, animated: true, completion: nil)
    }

    class func showNoNetworkErrorInViewController(_ viewController: UIViewController) {
        let alertViewController = VTAlertViewController(title: "An error occured", iconImageName: "active_card", message: "You are not connected to internet", messageFont: UIFont.appThemeFontWithSize(15.0), style: .alert)

        let okAction = VTAlertAction(title: "OK", style: .default) { (action) in
        }

        //alertViewController.addAction(retryAction)
        alertViewController.addAction(okAction)
        let time = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)

        DispatchQueue.main.asyncAfter(deadline: time) {
            viewController.present(alertViewController, animated: true, completion: nil)
        }
    }

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

        if self.localizedDescription == kErrorSessionExpired {
            Utility.setSignViewControllerAsRoot()
        }
    }

    class func showErrorWithMessage(message: String, viewController: UIViewController, type: VTMessageType = .error, topConstraint: CGFloat = 0.0) {
        var viewHeight: CGFloat = 40

        if message.count > 55 && Utility.isiphone5() {
            viewHeight = 60
        }

        let errorView = UIView(frame: CGRect(x: 0, y: topConstraint, width: Utility.getScreenWidth(), height: viewHeight))
        let errorLabel = UILabel(frame: CGRect(x: errorView.frame.origin.x + 10, y: 0.0, width: errorView.frame.width-10, height: errorView.frame.height))

        errorView.backgroundColor = UIColor.errorViewColor().withAlphaComponent(0.8)

        errorLabel.text = message
        errorLabel.textAlignment = .center
        errorLabel.textColor = UIColor.white
        errorLabel.font = UIFont.appThemeFontWithSize(13.0)
        errorLabel.numberOfLines = 0

        if type == .success {
            errorView.backgroundColor = UIColor.appThemeColor()
            errorLabel.font = UIFont.appThemeFontWithSize(14.0)

        } else if type == .info {
            errorView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        }

        errorView.addSubview(errorLabel)
        viewController.view.addSubview(errorView)
        viewController.view.bringSubview(toFront: errorView)

        let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {

            errorView.alpha = 1.0

            UIView.animate(withDuration: 2.0, animations: {
                errorView.alpha = 0.0

            }, completion: { (completed) in
                errorView.removeFromSuperview()
            })
        }
    }

}
