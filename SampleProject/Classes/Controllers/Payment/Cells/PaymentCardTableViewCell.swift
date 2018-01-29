//
//  VTPaymentCardTableViewCell.swift
//  Labour Choice
//
//  Created by Umair on 11/07/2017.
//  Copyright © 2017 talha. All rights reserved.
//

import UIKit

protocol PaymentCardTableViewCellDelegate {
    func didTapOkButton(cell: PaymentCardTableViewCell)
    func didTapDeleteButton(cell: PaymentCardTableViewCell)
}

class PaymentCardTableViewCell: UITableViewCell {

    @IBOutlet weak var cvvNoTextField: VTUITextField!
    @IBOutlet weak var expDateTextField: VTUITextField!
    @IBOutlet weak var cardNoTextField: VTUITextField!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!

    var delegate: PaymentCardTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func deleteButtonTapped(_ sender: Any) {
        delegate?.didTapDeleteButton(cell: self)
    }

    @IBAction func okButtonTapped(_ sender: Any) {
        delegate?.didTapOkButton(cell: self)
    }

    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> PaymentCardTableViewCell {
        let kPaymentCardTableViewCellIdentifier = "kPaymentCardTableViewCellIdentifier"
        tableView.register(UINib(nibName: "PaymentCardTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kPaymentCardTableViewCellIdentifier)

        let cell = tableView.dequeueReusableCell(withIdentifier: kPaymentCardTableViewCellIdentifier, for: indexPath) as! PaymentCardTableViewCell

        return cell
    }
}
