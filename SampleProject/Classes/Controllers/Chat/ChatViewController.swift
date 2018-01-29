//
//  ChatViewController.swift
//  Labour Choice
//
//  Created by Umair on 07/07/2017.
//  Copyright © 2017 talha. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import ObjectMapper

class ChatViewController: JSQMessagesViewController {

    // MARK: - Variables & Consrtants

    var messages = [JSQMessage]()

    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()

    var offSet = 0
    var JobId = ""
    var partnerId = ""
    var helperName = ""
    var isPastChat = false
    var shouldAddCloseButton = false
    var isLoadingPreviosChat = false

    // MARK: - Init & Deinit

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "ChatViewController", bundle: Bundle.main)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewControllerUI()
        loadPreviousChat()

        if shouldAddCloseButton {
            setupNavigationBarUI()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        User.shared.isChatingWithId = JobId

        if !shouldAddCloseButton {
//            NotificationCenter.default.addObserver(forName:Notification.Name(rawValue: kVTAppDidBecomeActive), object:nil, queue:nil) { notification in
//                self.loadPreviousChat()
//            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        User.shared.isChatingWithId = ""
        NotificationCenter.default.removeObserver(kVTAppDidBecomeActive)
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

    }

    // MARK: - UIViewController Helper Method

    func setupNavigationBarUI() {
        let saveButton: UIButton = UIButton (type: UIButtonType.custom)
        saveButton.setTitle("Close", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.addTarget(self, action: #selector(self.closeButtontapped(button:)), for: UIControlEvents.touchUpInside)
        saveButton.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        let barButton = UIBarButtonItem(customView: saveButton)

        navigationItem.rightBarButtonItem = barButton
    }

    func setupViewControllerUI() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.delegate = self
        
        title = "Chat"
        self.senderId = User.shared.id
        self.senderDisplayName = "Me"

        //if #available(iOS 11.0, *){ self.collectionView.contentInsetAdjustmentBehavior = .never; self.collectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0) self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset }

        // No avatars
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        self.inputToolbar.contentView.leftBarButtonItem = nil
        self.inputToolbar.contentView.rightBarButtonItem?.setImage(#imageLiteral(resourceName: "message_send_btn"), for: .normal)
        self.inputToolbar.contentView.rightBarButtonItem?.setTitle("", for: .normal)

        if isPastChat {
            self.inputToolbar.isHidden = true
        }
    }

    // MARK: - Selectors

    @objc func closeButtontapped(button : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - JSQMessagesCollectionViewDataSource

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {

        if messages.count != 0 {
            self.collectionView.backgroundView = UIView()
        }

        return messages[indexPath.item]
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAt indexPath: IndexPath!) -> NSAttributedString! {

        if messages[indexPath.row].date == nil {
            return NSAttributedString(string: "    ")
        }

        return NSAttributedString(string: "    " + messages[indexPath.row].date.toString() + "    ")
    }

     override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAt indexPath: IndexPath!) -> CGFloat {
        return 30
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]

        if message.senderId == senderId {
            return outgoingBubbleImageView

        } else {
            return incomingBubbleImageView
        }
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }

    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        sendMessage(message: text)
        self.finishSendingMessage()
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, header headerView: JSQMessagesLoadEarlierHeaderView!, didTapLoadEarlierMessagesButton sender: UIButton!) {

        if messages.count > 9 {
            offSet = messages.count
        }

        loadEarlierMessages()
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item]

        if message.senderId == senderId {
            let formattedName = NSMutableAttributedString()
            formattedName.bold("Me")
            return formattedName

        } else {

            guard let senderDisplayName = message.senderDisplayName else {
                let formattedName = NSMutableAttributedString()
                formattedName.bold("Me")
                return formattedName
            }

            let formattedName = NSMutableAttributedString()
            formattedName.bold(senderDisplayName)
            return formattedName
        }
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 35.0
    }

    // MARK: - Selectors

    func didReceivedNewMessage(_ notification: NSNotification) {

        if let data = Mapper<UserPushNotitfication>().map(JSON: notification.userInfo as! [String : Any]) {

            if data.jobId != JobId {
                return
            }

            addMessage(withId: partnerId, name: helperName, text: data.body)
            self.finishReceivingMessage()
        }
    }

    // MARK: - Private Methods

    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.appThemeColor())
    }

    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.lightGray)
    }

    func addMessage(withId id: String, name: String, text: String) {

        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
           // sendMessage(message: text)
            JSQSystemSoundPlayer.jsq_playMessageSentSound()
        }
    }

    private func loadEarlierMessages() {

        APIClient.shared.getPreviousChat(jobId: JobId, offSet: offSet) { (response, result, error, isCancelld, status) in

            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)

                if error?.localizedDescription == "This conversation has been ended." {
                    self.navigationController?.popViewController(animated: true)
                }

            } else {

                if let data = Mapper<Messages>().map(JSONObject: result) {

                    if data.messages.count == 0  && self.messages.count == 0 {
                        Utility.emptycollectionViewMessageWithImage(message: "You can now chat", collectionView: self.collectionView)

                    } else {
                        self.collectionView.backgroundView = UIView()
                    }

                    let chatDateFormatter = DateFormatter()
                    chatDateFormatter.dateFormat = "dd MMM, hh:mm a"

                    for myMessage in data.messages {

                        if myMessage.senderId ==  User.shared.id {
                            let message = JSQMessage(senderId: self.senderId, senderDisplayName: "Me", date: chatDateFormatter.date(from: myMessage.formattedDate), text: myMessage.body)
                            self.messages.insert(message!, at: 0)

                        } else {chatDateFormatter.date(from: myMessage.formattedDate)
                            let otherMessage = JSQMessage(senderId: self.partnerId, senderDisplayName: self.helperName, date: chatDateFormatter.date(from: myMessage.formattedDate), text: myMessage.body)
                            self.messages.insert(otherMessage!, at: 0)
                        }
                    }

                    if data.messages.count >= kOffSet {
                        self.showLoadEarlierMessagesHeader = true
                        
                    } else {
                        self.showLoadEarlierMessagesHeader = false
                    }
                    
                    self.finishReceivingMessage()
                }
            }
        }

    }

    func loadPreviousChat() {

        if isLoadingPreviosChat {
            return
        }

        isLoadingPreviosChat = true

        Utility.showLoading(viewController: self)
        self.inputToolbar.contentView.textView.isUserInteractionEnabled = false

        APIClient.shared.getPreviousChat(jobId: JobId, offSet: offSet) { (response, result, error, isCancelld, status) in
            Utility.hideLoading(viewController: self)
            self.inputToolbar.contentView.textView.isUserInteractionEnabled = true
            self.isLoadingPreviosChat = false

            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)

                if error?.localizedDescription == "This conversation has been ended." {
                    self.navigationController?.popViewController(animated: true)
                }

            } else {

                if let data = Mapper<Messages>().map(JSONObject: result) {

                    if data.messages.count == 0  && self.messages.count == 0 {
                        Utility.emptycollectionViewMessageWithImage(message: "You can now chat", collectionView: self.collectionView)

                    } else {
                        self.collectionView.backgroundView = UIView()
                    }

                    if data.messages.count == self.messages.count { // do not get data if data is not changed
                        return
                    }

                    self.messages = []
                    User.shared.badgeValue = data.badgeValue
                    data.messages = data.messages.reversed()

                    let chatDateFormatter = DateFormatter()
                    chatDateFormatter.dateFormat = "dd MMM, hh:mm a"

                    for myMessage in data.messages {

                        if myMessage.senderId ==  User.shared.id {
                            let message = JSQMessage(senderId: self.senderId, senderDisplayName: "Me", date: chatDateFormatter.date(from: myMessage.formattedDate), text: myMessage.body)
                            self.messages.insert(message!, at: 0)

                        } else {
                            let otherMessage = JSQMessage(senderId: self.partnerId, senderDisplayName: self.helperName, date: chatDateFormatter.date(from: myMessage.formattedDate), text: myMessage.body)
                            self.messages.insert(otherMessage!, at: 0)
                        }
                    }

                    if data.messages.count >= kOffSet {
                        self.showLoadEarlierMessagesHeader = true

                    } else {
                        self.showLoadEarlierMessagesHeader = false
                    }

                    self.finishReceivingMessage()
                }
            }
        }
    }

    private func sendMessage(message: String) {
        SocketIOManager.sharedInstance.sendMessage(message: message, jobId: JobId)
    }
}

extension ChatViewController: ApplicationMainDelegate {

    // MARk: - ApplicationMainDelegate

    func didReceiveNewMessage(jobId: String, message: String, senderId: String) {

        if jobId != self.JobId {
            return
        }

        if senderId == User.shared.id {
            self.addMessage(withId: self.senderId, name: "Me", text: message)

        } else {
            self.addMessage(withId: partnerId, name: helperName, text:message)
        }

        self.finishReceivingMessage()
    }

    func didReceiveJobCompletionNotification(jobId: String) {

        if jobId == self.JobId {
            dismissChatViewController()
        }
    }

    func didReceiveJobCanceledNotification(jobId: String) {

        if jobId == self.JobId {
            dismissChatViewController()
        }
    }

    func dismissChatViewController() {
        self.dismiss(animated: false, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }

    func applicationDidBecomeActive() {
        self.loadPreviousChat()
    }

}
