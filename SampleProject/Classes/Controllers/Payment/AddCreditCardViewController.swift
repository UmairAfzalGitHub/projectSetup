//
//  AddCreditCardViewController.swift
//  Labour Choice
//
//  Created by Umair on 17/07/2017.
//  Copyright © 2017 talha. All rights reserved.
//

import UIKit
import Stripe

protocol AddCreditCardDelegate {
    func didFinishAddingCard()
}

class AddCreditCardViewController: UIViewController {

    // MARK: Variables & Constants

    @IBOutlet weak var cardNoTextField: VTUITextField!
    @IBOutlet weak var expiryDateTextField: VTUITextField!
    @IBOutlet weak var CvvTextField: VTUITextField!

    var delegate: AddCreditCardDelegate?

    // MARK: - Init & De-Init

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "AddCreditCardViewController", bundle: Bundle.main)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: UIViewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewControllerUI()
        setupNavigationBarUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UIViewController helper Methods

    func setupViewControllerUI() {
        cardNoTextField.isCreditCardTextField = true
        expiryDateTextField.isExpirayDateTextField = true
        CvvTextField.isCvvField = true
    }

    func setupNavigationBarUI() {
        title = "Add new credit card"

        let rightButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_done"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.doneButtonTapped))
        navigationItem.rightBarButtonItem = rightButton

        let leftButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cancel"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.cancelButtonTapped))
        navigationItem.leftBarButtonItem = leftButton
    }

    // MARK: - IBActions

    @objc func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @objc func doneButtonTapped() {

        if cardNoTextField.text == "" {
            cardNoTextField.lineColor = UIColor.red
            cardNoTextField.text = ""
            NSError.showErrorWithMessage(message: "Enter Credit card no.", viewController: self)

        } else if expiryDateTextField.text == "" {
            cardNoTextField.lineColor = UIColor.red
            cardNoTextField.text = ""
            NSError.showErrorWithMessage(message: "Enter expiry date", viewController: self)

        } else if CvvTextField.text == "" {
            CvvTextField.lineColor = UIColor.red
            CvvTextField.text = ""
            NSError.showErrorWithMessage(message: "Enter CVV no.", viewController: self)

        } else {
            validateCard()
        }
    }

    func validateCard() {
        Utility.showLoading(viewController: self)

        let stripCardParams = STPCardParams()

        // Split the expiration date to extract Month & Year
        let expirationDate = self.expiryDateTextField.text?.components(separatedBy: "/")
        let expMonth = Int((expirationDate?[0])!)
        let expYear = Int((expirationDate?[1])!)

        // Send the card info to Strip to get the token
        stripCardParams.number = self.cardNoTextField.text
        stripCardParams.cvc = self.CvvTextField.text
        stripCardParams.expMonth = UInt(expMonth!)
        stripCardParams.expYear = UInt(expYear!)

        if STPCardValidator.validationState(forCard: stripCardParams) == .valid {

            STPAPIClient.shared().createToken(withCard: stripCardParams, completion: { (token, error) -> Void in

                if error != nil {
                    error?.showErrorBelowNavigation(viewController: self)
                    Utility.hideLoading(viewController: self)

                    return
                }

                self.sendTokenToServer(token: (token?.tokenId)!)
            })

        } else {
            Utility.hideLoading(viewController: self)
            NSError.showErrorWithMessage(message: "Invalid card info", viewController: self, type: .error)
        }
    }

    func sendTokenToServer(token: String) {

        APIClient.shared.sendStripeToken(token: token) { (result, error) in
            Utility.hideLoading(viewController: self)

            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)

            } else {
                self.dismiss(animated: true, completion: nil)
                self.delegate?.didFinishAddingCard()
            }
        }
    }
}
