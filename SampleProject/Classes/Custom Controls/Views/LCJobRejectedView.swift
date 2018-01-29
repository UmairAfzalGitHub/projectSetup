//
//  VTJobRejectedView.swift
//  Labour Choice
//
//  Created by Umair on 19/09/2017.
//  Copyright © 2017 talha. All rights reserved.
//

import UIKit

class VTJobRejectedView: UIView {

    @IBOutlet weak var desciptionLabel: UILabel!
    @IBOutlet weak var labourNameLabel: UILabel!
    @IBOutlet weak var tryAgainButton: UIButton!

    class func instanceFromNib() -> VTJobRejectedView {
        return UINib(nibName: "VTJobRejectedView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! VTJobRejectedView
    }

    @IBAction func tryAgainButtonTapped(_ sender: Any) {

        if tryAgainButton.titleLabel?.text == "Add card info now" {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationOpenPaymentiewController), object: nil, userInfo: nil)
        }

        UIView.animate(withDuration: 1.0) {
            self.frame = CGRect(x: 0, y: (self.superview?.frame.height)! + self.frame.height, width: self.frame.width, height: self.frame.height)
            self.removeFromSuperview()
        }
    }
}
