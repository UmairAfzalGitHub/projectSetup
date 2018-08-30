//
//  Utility.swift
//  passManager
//
//  Created by Umair on 6/19/17.
//  Copyright © 2017 Umair. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import BRYXBanner
import SocketIO
import ObjectMapper
import UserNotifications
import NVActivityIndicatorView

class Utility : NSObject {

    class func deviceUUID() -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }

    class func saveStringToUserDefaults(_ value: String?, Key: String) {

        if value != nil {
            UserDefaults.standard.set(value, forKey: Key)
            UserDefaults.standard.synchronize()
        }
    }

    class func presentAlertOnViewController(_ title:String, message:String, viewController:UIViewController){

        let alertViewController = VTAlertViewController(title: title, message: message, style: .alert)
        let okAction = VTAlertAction(title: "Ok", style: .default) { (action) in
        }

        alertViewController.addAction(okAction)

        viewController.present(alertViewController, animated: true, completion: nil)
    }

    class func emptyTableViewMessage(message:String, viewController: UIViewController, tableView:UITableView) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: viewController.view.bounds.size.width, height: viewController.view.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.appThemeFontWithSize(15.0)
        messageLabel.sizeToFit()

        tableView.backgroundView = messageLabel
        tableView.separatorStyle = .none
    }

    class func emptyTableViewMessageWithImage(image: UIImage, message: String, viewBackgroundColor: UIColor = UIColor.white, viewController: UIViewController, tableView: UITableView) {
        let noJobsView = NoJobsViews.instanceFromNib()
        noJobsView.imageView.image = image
        noJobsView.messageLabel.text = message
        noJobsView.messageLabel.font = UIFont.appThemeFontWithSize(15.0)
        noJobsView.backgroundColor = viewBackgroundColor

        tableView.backgroundView = noJobsView
        tableView.separatorStyle = .none
    }

    class func emptyTableViewMessageWithButton(message:String, viewController: UIViewController, tableView: UITableView) {
        let noJobsView = NoHelpMateView.instanceFromNib()
        noJobsView.delegate = (viewController as! NoHelpMateViewDelegate)
        noJobsView.requestButton.layer.cornerRadius = noJobsView.requestButton.frame.height/2
//        noJobsView.messageLabel.font = UIFont.appThemeFontWithSize(15.0)

        tableView.backgroundView = noJobsView
        tableView.separatorStyle = .none
    }

    /**
     A method that displays in app notifications like push notifications.
     - parameter title: The title for the notification
     - parameter message: The message for the notification
     - parameter identifier: An identifier to uniquely indentify the notification in AppDelegate
     - parameter userInfo: A dictionary containing the payload of notification

     */

    class func showInAppNotification(title: String, message: String, identifier: String, userInfo: [AnyHashable: Any] = [:]) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = UNNotificationSound.default()
        content.userInfo = userInfo
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: notificationTrigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    class func emptycollectionViewMessageWithImage(message:String, collectionView: UICollectionView) {
        let noJobsView = NoJobsViews.instanceFromNib()
        noJobsView.imageView.image = #imageLiteral(resourceName: "no_msg")
        noJobsView.messageLabel.text = message
        noJobsView.messageLabel.font = UIFont.appThemeFontWithSize(15.0)

        collectionView.backgroundView = noJobsView
    }

    class func getScreenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }

    class func getScreenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }

    class func isiphone5() -> Bool {

        if self.getScreenHeight() == 568 { // Iphone 5

            return true
        }
        return false
    }

    class func isiphone6() -> Bool {

        if self.getScreenHeight() == 667 { // Iphone 6/7
            return true
        }
        return false
    }

    class func isiphone6Plus() -> Bool {

        if self.getScreenHeight() == 736 { // Iphone 6+/ 7+
            return true
        }
        
        return false
    }

    class func saveCookies(response: DataResponse<Any>) {

        if let headerFields = response.response?.allHeaderFields as? [String: String] {
            let url = response.response?.url
            let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url!)
            var cookieArray = [[HTTPCookiePropertyKey: Any]]()
            for cookie in cookies {
                cookieArray.append(cookie.properties!)
            }
            UserDefaults.standard.set(cookieArray, forKey: kSavedCookies)
            UserDefaults.standard.synchronize()
        }
    }

    class func loadCookies() {
        guard let cookieArray = UserDefaults.standard.array(forKey: kSavedCookies) as? [[HTTPCookiePropertyKey: Any]] else { return }
        for cookieProperties in cookieArray {
            if let cookie = HTTPCookie(properties: cookieProperties) {
                HTTPCookieStorage.shared.setCookie(cookie)
            }
        }
    }

    class func removedCookies() {
        UserDefaults.standard.removeObject(forKey: kSavedCookies)
        UserDefaults.standard.synchronize()
    }

    class func openDialerWith(number phoneNumber: String) {

        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {

            if #available(iOS 10, *) {
                UIApplication.shared.open(url)

            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

    class func saveUserDataInDefaults(user: SignIn) {
        User.shared.firstName = user.firstName
        User.shared.lastName = user.lastName
        User.shared.email = user.email
        User.shared.mobileNumber = user.mobileNumber
        User.shared.id = user.id
        User.shared.profileImageURL = user.imageURL
        UserDefaults.standard.set(user.firstName, forKey: kUserFirstName)
        UserDefaults.standard.set(user.lastName, forKey: kUserLastName)
        UserDefaults.standard.set(user.email, forKey: kUserEmail)
        UserDefaults.standard.set(user.mobileNumber, forKey: kUserMobile)
        UserDefaults.standard.set(user.id, forKey: kUserId)
        UserDefaults.standard.set(user.imageURL, forKey: kUserProfileImageUrl)
    }

    class func getUserDataFromDefaults() {

        if let name = UserDefaults.standard.value(forKey: kUserFirstName) as? String {
            User.shared.firstName = name
        }

        if let name = UserDefaults.standard.value(forKey: kUserLastName) as? String {
            User.shared.lastName = name
        }

        if let email = UserDefaults.standard.value(forKey: kUserEmail) as? String {
            User.shared.email = email
        }

        if let mobileNumber = UserDefaults.standard.value(forKey: kUserMobile) as? String {
            User.shared.mobileNumber = mobileNumber
        }

        if let id = UserDefaults.standard.value(forKey: kUserId) as? String {
            User.shared.id = id
        }

        if let imageUrl = UserDefaults.standard.value(forKey: kUserProfileImageUrl) as? String {
            User.shared.profileImageURL = imageUrl
        }
    }

    class func saveRejectedJobData(data: UserPushNotitfication) {
        UserDefaults.standard.set(data.description, forKey: kDescription)
        UserDefaults.standard.set(data.duration, forKey: kDuration)
        UserDefaults.standard.set(data.long, forKey: KLong)
        UserDefaults.standard.set(data.lat, forKey: kLat)
        UserDefaults.standard.set(data.startTime, forKey: kStartTime)
        UserDefaults.standard.set(data.address, forKey: kJobAddress)
        UserDefaults.standard.set(true, forKey: kShouldLoadRejectJobData)
    }

    class func displayMessageInDeviceConsole(message: String) {
        NSLog(message)
    }

    class func formattedDateForMessage() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, hh:mm a"
        return dateFormatter.string(from: Date())
    }

    class func showBanner(titile: String = "", message: String) {
        let banner = Banner(title: titile, subtitle: message, image: nil, backgroundColor: UIColor.notificationBackgroundColor())
        banner.dismissesOnTap = true
        banner.show(duration: 3.0)
    }

    class func showLoading(viewController: UIViewController) {
        let superView = UIView(frame: CGRect(x: self.getScreenWidth()/2 - 35, y: self.getScreenHeight()/2 - 50, width: 70, height: 70))
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: superView.frame.width/2 - 20, y: superView.frame.height/2 - 20, width: 40, height: 40))

        // superView.center = viewController.view.center
        superView.backgroundColor = UIColor.darkGray
        superView.layer.cornerRadius = 10
        superView.tag = 9000

        activityIndicator.type = .ballTrianglePath
        activityIndicator.color = UIColor.appThemeColor()
        activityIndicator.startAnimating()

        superView.addSubview(activityIndicator)
        superView.bringSubview(toFront: activityIndicator)

        viewController.view.addSubview(superView)
        viewController.view.bringSubview(toFront: superView)
        viewController.view.isUserInteractionEnabled = false
        viewController.view.setNeedsLayout()
        viewController.view.setNeedsDisplay()
    }

    class func getVisibleViewController(_ rootViewController: UIViewController?) -> UIViewController? {

        var rootVC = rootViewController
        if rootVC == nil {
            rootVC = UIApplication.shared.keyWindow?.rootViewController
        }

        if rootVC?.presentedViewController == nil {
            return rootVC
        }

        if let presented = rootVC?.presentedViewController {
            if presented.isKind(of: UINavigationController.self) {
                let navigationController = presented as! UINavigationController
                return navigationController.viewControllers.last!
            }

            if presented.isKind(of: UITabBarController.self) {
                let tabBarController = presented as! UITabBarController
                return tabBarController.selectedViewController!
            }

            return getVisibleViewController(presented)
        }
        return nil
    }

    class func clearUser() {
        //User.shared.categories = Mapper<VTCategories>().map(JSONObject: [:])!
        User.shared.email = ""
        User.shared.id = ""
        User.shared.isChatingWithId = ""
        User.shared.mobileNumber = ""
        User.shared.firstName = ""
        User.shared.lastName = ""
        User.shared.profileImageURL = ""

        UserDefaults.standard.removeObject(forKey: kShouldLoadRejectJobData)
        UserDefaults.standard.removeObject(forKey: kShouldLoadRejectJobData)
        UserDefaults.standard.removeObject(forKey: kIsUserLoggedIn)
        UserDefaults.standard.removeObject(forKey: kIsCardInfoAdded)
        UserDefaults.standard.removeObject(forKey: kUserId)
        UserDefaults.standard.removeObject(forKey: kUserId)
        UserDefaults.standard.removeObject(forKey: kUserId)
        UserDefaults.standard.removeObject(forKey: kUserId)
        UserDefaults.standard.removeObject(forKey: kUserId)
        UserDefaults.standard.removeObject(forKey: kUserId)
        UserDefaults.standard.removeObject(forKey: kUserId)
        UserDefaults.standard.removeObject(forKey: kUserId)
        UserDefaults.standard.removeObject(forKey: kUserId)
    }

    class func setSignViewControllerAsRoot() {
        Utility.removedCookies()
        Utility.clearUser()

        SocketIOManager.sharedInstance.socket?.disconnect()
        SocketIOManager.sharedInstance.socket = nil
        SocketIOManager.sharedInstance.socketManager = SocketManager(socketURL: URL(string: kStagingSocketUrl)!, config: [.log(true), .compress])

        let signInNavigationController = UINavigationController()
        let signinViewController = SignInViewController()

        signInNavigationController.viewControllers = [signinViewController]
        signInNavigationController.transparentNavigationBar()
        signInNavigationController.setupAppThemeNavigationBar()
        UserDefaults.standard.set(false, forKey: kIsUserLoggedIn)
        UserDefaults.standard.removeObject(forKey: kIsCardInfoAdded)

        let when = DispatchTime.now() + 2 // change 2 to desired number of seconds

        DispatchQueue.main.asyncAfter(deadline: when) {
            UIApplication.shared.keyWindow!.replaceRootViewControllerWith(signInNavigationController, animated: true, completion: nil)
        }
    }

    class func hideLoading(viewController: UIViewController) {

        if let activityView = viewController.view.viewWithTag(9000) {
            viewController.view.isUserInteractionEnabled = true
            activityView.removeFromSuperview()
        }
    }

    class func showSuccess(viewController: UIViewController, labelText: String, completion: @escaping () -> ()) {
        let superView = UIView(frame: CGRect(x: viewController.view.frame.width/2 , y: viewController.view.frame.height/2 , width: 180, height: 150))
        let imageView = UIImageView(frame: CGRect(x: superView.frame.width/2 - 35, y: superView.frame.height/2 - 35 , width: 70, height: 70))

        let label = UILabel(frame: CGRect(x: 0, y: imageView.frame.height + 35 , width: 180, height: 45))

        label.text = labelText
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 2
        imageView.image = UIImage(named:"circle_tick")

        superView.center = CGPoint(x: viewController.view.bounds.width/2 , y: viewController.view.bounds.height/2)
        superView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        superView.layer.cornerRadius = 10
        superView.tag = 8000

        superView.addSubview(imageView)
        superView.bringSubview(toFront: imageView)

        superView.addSubview(label)
        superView.bringSubview(toFront: label)

        viewController.view.addSubview(superView)
        viewController.view.bringSubview(toFront: superView)

        // remove from super view after durations
        let delay = DispatchTime.now() + Double(Int64(3.0 * Float(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delay) {

            if let activityView = viewController.view.viewWithTag(8000) {
                activityView.removeFromSuperview()
                completion()
            }
        }
    }
}
