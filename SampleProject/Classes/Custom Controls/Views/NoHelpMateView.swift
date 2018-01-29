//
//  NoHelpMateView.swift
//  Help Connect
//
//  Created by Umair Afzal on 21/12/2017.
//  Copyright © 2017 Umair Afzal. All rights reserved.
//

import UIKit

protocol NoHelpMateViewDelegate {
    func didTapRequestToAdminButton()
}

class NoHelpMateView: UIView {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var requestButton: UIButton!

    var delegate: NoHelpMateViewDelegate?

    class func instanceFromNib() -> NoHelpMateView {
        return UINib(nibName: "NoHelpMateView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! NoHelpMateView
    }

    @IBAction func requestButtonTapped(_ sender: Any) {
        delegate?.didTapRequestToAdminButton()
    }
    
}
