//
//  SampleViewController.swift
//  SampleProject
//
//  Created by Umair Afzal on 1/27/18.
//  Copyright © 2018 Umair Afzal. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class SampleViewController: UIViewController {

    // Always devide variables and constants logically
    // Try to write methods in the same sequence in which they are called
    // Always write Marks
    // Always write extension if you are using tableView of collectionView OR any delegation having more than 2 functions
    // Variable name should always be meaningful and written in camel case
    // Functions name should always be meaningful ad written in camel casing
    // Always give a line space before starting a functional body like if, switch, func, class, closure etc
    //

    // MARK: - Variables & Constants

    var id = ""

    // MARK: - UIViewController Methods

    override func viewDidLoad() {
        super.viewDidLoad() // Always call parent method when overriding any method

        setupViewControllerUI()
        setupNavigationBarUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    // MARK: - UIViewController Helper Methods

    func setupViewControllerUI() {
        // write the code here which you normally write in viewDidLoad
    }

    func setupNavigationBarUI() {
        // create and add navigation bar buttons
    }

    // MARK: - Delegate Methods

    // Write the delegate methods if they are less the 2. Otherwise write an extension and move the mark and methods there.

    // MARK: - Selectors

    // selector methods for notifications and Navigation bar buttons

    // MARK: - IBActions

    // IBActions for the buttons

    // MARK: - Private Methods

    func loadData() {
        // use this method to call the Api on viewDidLoad OR getting data for viewController on viewWillAppear etc

        APIClient.shared.loginAsUser(mobileNumber: "") { (response, result, error, isCancleed, status) in

            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)

            } else {

                if let data = Mapper<StripeCustomer>().map(JSONObject: result) {
                    print(data.customerId)
                }
            }
        }
    }
}

extension SampleViewController: UITableViewDataSource, UITableViewDelegate {

    // MARK: - UITableView Data Source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    // MARK: - UITableView Delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Do some stuff
    }
}
