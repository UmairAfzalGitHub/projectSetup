//
//  VTDatePickerView.swift
//  Help Connect
//
//  Created by Umair Afzal on 13/12/2017.
//  Copyright © 2017 Umair Afzal. All rights reserved.
//

import UIKit

protocol VTDatePickerViewDelegate {
    func didTapDoneButton(datePicker: UIDatePicker)
}

class VTDatePickerView: UIView {

    @IBOutlet weak var datePicker: UIDatePicker!
    var delegate: VTDatePickerViewDelegate?

    class func instanceFromNib() -> VTDatePickerView {
        let nib = UINib(nibName: "VTDatePickerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! VTDatePickerView
        nib.frame = CGRect(x: nib.frame.origin.x, y: nib.frame.origin.x, width: nib.frame.width, height: 206)
        return nib
    }

    override func awakeFromNib() {
        self.backgroundColor = #colorLiteral(red: 0.9411881345, green: 0.9411881345, blue: 0.9411881345, alpha: 1)
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.gray.cgColor
        datePicker.layer.borderColor = UIColor.gray.cgColor
        datePicker.layer.borderWidth = 1.0
    }

    override func draw(_ rect: CGRect) {
        self.frame = CGRect(x: 0, y:Utility.getScreenHeight()-270, width: self.frame.width, height: 206)
    }

    @IBAction func doneButtonTapped(_ sender: Any) {
        delegate?.didTapDoneButton(datePicker: datePicker)
    }

}
