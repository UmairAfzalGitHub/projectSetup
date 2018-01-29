//
//  PaymentsViewController.swift
//  Labour Choice
//
//  Created by Umair on 11/07/2017.
//  Copyright © 2017 talha. All rights reserved.
//

import UIKit
import ObjectMapper

class PaymentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PaymentCardTableViewCellDelegate, AddCreditCardDelegate {

    // MARK: - Variables & Constants

    @IBOutlet weak var tableView: UITableView!

    var cards = [CreditCards]()
    var refreshControl = UIRefreshControl()
    var isFirstLoad = true

    // MARK: - Init & Deinit

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "PaymentsViewController", bundle: Bundle.main)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - UIViewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewControllerUI()
        setupNavigationBarUI()
        loadData()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {

//        NotificationCenter.default.addObserver(forName:Notification.Name(rawValue: kVTUpdateBadgeValueNotification), object:nil, queue:nil) { notification in
//            self.navigationItem.leftBarButtonItem?.addBadge(number: VTUser.shared.badgeValue)
//        }

        if User.shared.badgeValue != 0 {
            self.navigationItem.leftBarButtonItem?.addBadge(number: User.shared.badgeValue)

        } else {
            self.navigationItem.leftBarButtonItem?.removeBadge()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    // MARJ: - UIVIewContorller Methods

    func setupViewControllerUI() {
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none

        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)

        title = "Payment"
    }

    func setupNavigationBarUI() {
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "add_card"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.addCard))
        navigationItem.rightBarButtonItem = leftButton
    }

    @objc func addCard() {
        let navigationController = UINavigationController()
        let addCardViewController = AddCreditCardViewController()

        addCardViewController.delegate = self
        navigationController.viewControllers = [addCardViewController]
        navigationController.setupAppThemeNavigationBar()

        self.present(navigationController, animated: true, completion: nil)
    }

    // MARK: - UITableView Data Source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if cards.count == 0 && !isFirstLoad {
            Utility.emptyTableViewMessageWithImage(imageName: "default_card", message: "No credit card information added", viewController: self, tableView: tableView)
            return 0
        }

        tableView.backgroundView = UIView()
        return cards.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PaymentCardTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
        cell.delegate = self

        cell.expDateTextField.text = "\(cards[indexPath.row].expMonth) / \(cards[indexPath.row].expYear)"
        cell.cardNoTextField.text = "**** **** **** \(cards[indexPath.row].lastFour)"
        cell.cvvNoTextField.text = "***"

        if cards[indexPath.row].isDefaultCard == true { // default card
            cell.okButton.setImage(#imageLiteral(resourceName: "active_card"), for: .normal)
            cell.contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
            cell.deleteButton.isHidden = true

        } else {
            cell.okButton.setImage(#imageLiteral(resourceName: "non_active_card"), for: .normal)
            cell.contentView.backgroundColor = UIColor.clear
            cell.deleteButton.isHidden = false
        }

        return cell
    }

    // MARK: - PaymentCardTableViewCell Delegate

    func didTapOkButton(cell: PaymentCardTableViewCell) {
        let selectedIndexPath = self.tableView.indexPath(for: cell)
        changeDefaultCard(cardId: cards[(selectedIndexPath?.row)!].cardId)
    }

    func didTapDeleteButton(cell: PaymentCardTableViewCell) {
        let selectedIndexPath = self.tableView.indexPath(for: cell)
        deleteCard(cardId: cards[(selectedIndexPath?.row)!].cardId)

    }

    // MARK: - AddCreditCardDelegate

    func didFinishAddingCard() {
        loadData()
    }

    // MARK: - Pull to refresh

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        loadData(shouldShowLoader: false)
    }

    // MARK: - Private Methods

    func loadData(shouldShowLoader: Bool = true) {

        if shouldShowLoader {
            Utility.showLoading(viewController: self)
        }

        APIClient.shared.getStripeCustomer { (response, result, error, isCancelled, status) in
            self.refreshControl.endRefreshing()
            Utility.hideLoading(viewController: self)

            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)

            } else {

                if let data = Mapper<StripeCustomer>().map(JSONObject: result) {
                    self.cards = data.cards
                    self.isFirstLoad = false
                    self.tableView.reloadData()

                    if data.cards.count != 0 {
                        UserDefaults.standard.set(true, forKey: kIsCardInfoAdded)
                    }
                }
            }
        }
    }

    func deleteCard(cardId: String) {
        Utility.showLoading(viewController: self)

        APIClient.shared.deleteUserCard(cardId: cardId) { (response, result, error, isCancelled, status) in
            Utility.hideLoading(viewController: self)

            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)

            } else {

                if let data = Mapper<StripeCustomer>().map(JSONObject: result) {
                    self.cards = data.cards
                    self.tableView.reloadData()
                    NSError.showErrorWithMessage(message: "Card deleted successfully", viewController: self, type: .success)
                }
            }
        }
    }

    func changeDefaultCard(cardId: String) {
        Utility.showLoading(viewController: self)

        APIClient.shared.changeDefaultCard(cardId: cardId) { (response, result, error, isCancelled, status) in
            Utility.hideLoading(viewController: self)

            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)

            } else if !isCancelled && status {

                if let data = Mapper<StripeCustomer>().map(JSONObject: result) {
                    self.cards = data.cards
                    self.tableView.reloadData()
                }

            }
        }
    }

}
