//
//  VTAlertViewController.swift
//  VT
//
//  Created by iMac Limited on 22/05/16.
//  Copyright © 2016 Tech-Spiders. All rights reserved.
//
import UIKit

enum VTAlertActionStyle {
    case cancel
    case `default`
}

enum VTAlertStyle {
    case alert
    case actionSheet
}

class VTAlertAction: NSObject, NSCopying {

    // MARK: - VTAlertAction Properties

    var title: String
    var style: VTAlertActionStyle

    var handler: (VTAlertAction) -> Void

    // MARK: - VTAlertAction init - & copy

    required init(title: String, style: VTAlertActionStyle, handler: @escaping (VTAlertAction) -> Void) {
        self.title = title
        self.style = style
        self.handler = handler
    }

    func copy(with zone: NSZone?) -> Any {
        let copy = type(of: self).init(title: title, style: style, handler: handler)

        return copy
    }

}

class VTAlertPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    let kPresentationDuration = 0.5

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return kPresentationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let alertViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)! as! VTAlertViewController

        alertViewController.view.backgroundColor = UIColor.clear
        alertViewController.overlayView.alpha = 0.0

        let alertViewFrame = transitionContext.finalFrame(for: alertViewController)
        let containerView = transitionContext.containerView

        alertViewController.view.frame = alertViewFrame
        alertViewController.view.frame = alertViewFrame.offsetBy(dx: 0, dy: 0)
        containerView.addSubview(alertViewController.view)

        if alertViewController.alertStyle == .actionSheet {
            let transform = CGAffineTransform(translationX: 0.0, y: alertViewController.view.frame.size.height)
            alertViewController.actionSheetContainerView.transform = transform
        } else {
            let transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            alertViewController.alertContainerView.transform = transform
        }

        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: .curveLinear, animations: {
            alertViewController.overlayView.alpha = 1.0

            if alertViewController.alertStyle == .actionSheet {
                alertViewController.actionSheetContainerView.transform = CGAffineTransform.identity

            } else {
                alertViewController.alertContainerView.transform = CGAffineTransform.identity
            }

        }) { (finished) in
            transitionContext.completeTransition(true)
        }
    }

}

class VTAlertDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    let kDismissalDuration = 0.15

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return kDismissalDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let alertViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)! as! VTAlertViewController
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let containerView = transitionContext.containerView

        containerView.addSubview(toViewController.view)
        containerView.sendSubview(toBack: toViewController.view)

        UIView.animate(withDuration: kDismissalDuration , delay: 0.0, options: .curveLinear, animations: {

            if alertViewController.alertStyle == .actionSheet {
                let transform = CGAffineTransform(translationX: 0.0, y: alertViewController.view.frame.size.height)
                alertViewController.actionSheetContainerView.transform = transform

            } else {
                alertViewController.alertContainerView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }
            alertViewController.overlayView.alpha = 0.0

        }) { (finished) in
            let canceled: Bool = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(true)

            if !canceled {
                UIApplication.shared.keyWindow?.addSubview(toViewController.view)
            }
        }
    }

}

class VTAlertViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Properties

    var textFields: [UITextField]

    fileprivate let kAlertContainerViewWidth: CGFloat = 270.0 // Will be constant for every device
    fileprivate let kTextFieldsHeight: CGFloat = 40.0
    fileprivate let kButtonsHeight: CGFloat = 40.0
    fileprivate var kXMargin: CGFloat = 10.0
    fileprivate let kYmargin: CGFloat = 10.0
    fileprivate let kButtonXmargin: CGFloat = 30.0

    // OverlayView

    fileprivate var overlayView = UIView()
    fileprivate var overlayViewBackgroundColor = UIColor(white: 0.0, alpha: 0.4)

    // alertContainerView

    fileprivate var alertContainerView = UIView()

    // ActionSheetContainerView

    fileprivate var actionSheetContainerView = UIView()

    // title Label

    fileprivate var titleLabel = UILabel()
    fileprivate var alertTitle = ""

    // message Label

    fileprivate var messageLabel = UILabel()
    fileprivate var alertMessage = ""
    fileprivate var messageFont = UIFont.appThemeFontWithSize(15.0)

    // icon imageView

    fileprivate var iconImageView = UIImageView ()
    fileprivate var iconImageName: String?

    // UIButtons Container View

    fileprivate var buttonsContainerView = UIView()

    // UITextFields ContainerView

    fileprivate var textFieldsContainerView = UIView()
    fileprivate var activeTextFild: UITextField?

    fileprivate var alertStyle: VTAlertStyle
    fileprivate var actions: [VTAlertAction]
    fileprivate var buttons: [UIButton] = []

    fileprivate var alertContainerViewVerticalConstraint: NSLayoutConstraint?

    // MARK:- init & deinit

    init() {
        alertTitle = ""
        alertMessage = ""
        alertStyle = .alert
        actions = []
        textFields = []

        super.init(nibName: nil, bundle: nil)

        transitioningDelegate = self
        modalPresentationStyle = .custom

        registerNotifications()
    }

    convenience init(title: String, iconImageName: String? = nil, message: String, messageFont: UIFont = UIFont.appThemeFontWithSize(15.0), style: VTAlertStyle) {
        self.init()

        alertTitle = title

        alertMessage = message
        self.iconImageName = iconImageName

        self.messageFont = messageFont

        alertStyle = style
        actions = []

        transitioningDelegate = self
        modalPresentationStyle = .custom
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        unRegisterNotifications()
    }

    // MARK: - UIViewController methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewController()
    }

    override var prefersStatusBarHidden : Bool {
        return false
    }

    // MARK: - UIViewController Helper methods

    func setupViewController() {

        // setup overlayView
        overlayView.frame = view.frame
        overlayView.backgroundColor = overlayViewBackgroundColor
        view.addSubview(overlayView)

        // setup alertContainerView
        alertContainerView.backgroundColor = UIColor.white
        alertContainerView.clipsToBounds = true
        alertContainerView.layer.cornerRadius = kCornerRadius * 4.0

        if alertStyle == .alert {
            view.addSubview(alertContainerView)
            alertContainerView.translatesAutoresizingMaskIntoConstraints = false

            let widthConstraint = NSLayoutConstraint(item: alertContainerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: kAlertContainerViewWidth)

            let alertContainerViewHorizontalConstraint = NSLayoutConstraint(item: alertContainerView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
            alertContainerViewVerticalConstraint = NSLayoutConstraint(item: alertContainerView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0.0)

            view.addConstraints([widthConstraint, alertContainerViewHorizontalConstraint, alertContainerViewVerticalConstraint!])

        } else {
            actionSheetContainerView.backgroundColor = UIColor.clear
            view.addSubview(actionSheetContainerView)

            actionSheetContainerView.translatesAutoresizingMaskIntoConstraints = false

            let actionSheetOffset: CGFloat = 5.0

            let leading = NSLayoutConstraint(item: actionSheetContainerView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: actionSheetOffset)
            let bottom = NSLayoutConstraint(item: actionSheetContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
            let trailing = NSLayoutConstraint(item: actionSheetContainerView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: -actionSheetOffset)
            let top = NSLayoutConstraint(item: actionSheetContainerView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0.0)

            view.addConstraints([leading, trailing, bottom, top])

            actionSheetContainerView.addSubview(alertContainerView)

            alertContainerView.translatesAutoresizingMaskIntoConstraints = false

            let alertleading = NSLayoutConstraint(item: alertContainerView, attribute: .leading, relatedBy: .equal, toItem: actionSheetContainerView, attribute: .leading, multiplier: 1.0, constant: actionSheetOffset)
            //            let alertTop = NSLayoutConstraint(item: alertContainerView, attribute: .Top, relatedBy: .Equal, toItem: actionSheetContainerView, attribute: .Top, multiplier: 1.0, constant: 0.0)
            let alerttrailing = NSLayoutConstraint(item: alertContainerView, attribute: .trailing, relatedBy: .equal, toItem: actionSheetContainerView, attribute: .trailing, multiplier: 1.0, constant: -actionSheetOffset)

            actionSheetContainerView.addConstraints([alertleading, alerttrailing])
        }

        // setup titleLabel
        titleLabel.text = alertTitle
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.appThemeBoldFontWithSize(18.0)
        alertContainerView.addSubview(titleLabel)

        // setup messageLabel
        messageLabel.text = alertMessage
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.textAlignment = .center
        messageLabel.font = messageFont
        // alertContainerView.addSubview(messageLabel)

        if iconImageName != nil {
            iconImageView.image = UIImage(named: iconImageName!)
        }

        iconImageView.isHidden = iconImageName == nil

        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 5.0
        // add width height constraint

        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(messageLabel)
        alertContainerView.addSubview(stackView)

        // setup textFieldsContainerView
        textFieldsContainerView.backgroundColor = UIColor.clear
        alertContainerView.addSubview(textFieldsContainerView)

        // setup buttonsContainerView
        buttonsContainerView.backgroundColor = UIColor.clear
        alertContainerView.addSubview(buttonsContainerView)

        // titleLabel Constraints

        var yOffset: CGFloat = kYmargin

        if alertTitle.count == 0 {
            yOffset = 0.0
        }

        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let titleLeading = NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: alertContainerView, attribute: .leading, multiplier: 1.0, constant: kXMargin)
        let titleTop = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: alertContainerView, attribute: .top, multiplier: 1.0, constant: yOffset)
        let titleTrailing = NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: alertContainerView, attribute: .trailing, multiplier: 1.0, constant: -kXMargin)
        let titleBottom = NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: stackView, attribute: .top, multiplier: 1.0, constant: -kYmargin)
        alertContainerView.addConstraints([titleLeading, titleTop, titleTrailing, titleBottom])

        // messageLabel Constraints

        if alertMessage.count > 0 || !iconImageView.isHidden {
            yOffset = kYmargin

        } else {
            yOffset = 0.0
        }

        stackView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        let messageTop = NSLayoutConstraint(item: messageLabel, attribute: .top, relatedBy: .equal, toItem: stackView, attribute: .top, multiplier: 1.0, constant: 0.0)
        let messageBottom = NSLayoutConstraint(item: messageLabel, attribute: .bottom, relatedBy: .equal, toItem: stackView, attribute: .bottom, multiplier: 1.0, constant: 0.0)

        let iconImageViewWidth = NSLayoutConstraint(item: iconImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50.0)
        let iconImageViewHeight = NSLayoutConstraint(item: iconImageView, attribute: .height, relatedBy: .equal, toItem: iconImageView, attribute: .width, multiplier: 1.0, constant: 0.0)
        let iconImageViewTop = NSLayoutConstraint(item: iconImageView, attribute: .top, relatedBy: .equal, toItem: stackView, attribute: .top, multiplier: 1.0, constant: 0.0)
        let iconImageViewLeading = NSLayoutConstraint(item: iconImageView, attribute: .leading, relatedBy: .equal, toItem: stackView, attribute: .leading, multiplier: 1.0, constant: 0.0)

        iconImageViewWidth.priority = UILayoutPriority(rawValue: 999)
        iconImageViewHeight.priority = UILayoutPriority(rawValue: 999)

        iconImageView.addConstraints([iconImageViewWidth, iconImageViewHeight])
        stackView.addConstraints([iconImageViewTop, iconImageViewLeading, messageTop, messageBottom])

        let stackViewLeading = NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: alertContainerView, attribute: .leading, multiplier: 1.0, constant: kXMargin)
        let stackViewTrailing = NSLayoutConstraint(item: stackView, attribute: .trailing, relatedBy: .equal, toItem: alertContainerView, attribute: .trailing, multiplier: 1.0, constant: -kXMargin)
        let stackViewBottom = NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: textFieldsContainerView, attribute: .top, multiplier: 1.0, constant: -yOffset)
        alertContainerView.addConstraints([stackViewLeading, stackViewTrailing, stackViewBottom])

        // TextFieldsContainerView Constraints

        if textFields.count == 0 {
            yOffset = 0.0

        } else {
            yOffset = kYmargin
        }

        textFieldsContainerView.translatesAutoresizingMaskIntoConstraints = false

        let textFieldsContainerLeading = NSLayoutConstraint(item: textFieldsContainerView, attribute: .leading, relatedBy: .equal, toItem: alertContainerView, attribute: .leading, multiplier: 1.0, constant: kXMargin)
        let textFieldsContainerTrailing = NSLayoutConstraint(item: textFieldsContainerView, attribute: .trailing, relatedBy: .equal, toItem: alertContainerView, attribute: .trailing, multiplier: 1.0, constant: -kXMargin)
        let textFieldsContainerBottom = NSLayoutConstraint(item: textFieldsContainerView, attribute: .bottom, relatedBy: .equal, toItem: buttonsContainerView, attribute: .top, multiplier: 1.0, constant: -yOffset)
        alertContainerView.addConstraints([textFieldsContainerLeading, textFieldsContainerTrailing, textFieldsContainerBottom])

        // buttonsContainerView Constraints
        buttonsContainerView.translatesAutoresizingMaskIntoConstraints = false

        var buttonsContainerViewMargin = kXMargin

        if alertStyle == .actionSheet {
            buttonsContainerViewMargin = 0.0
        }

        let buttonsContainerLeading = NSLayoutConstraint(item: buttonsContainerView, attribute: .leading, relatedBy: .equal, toItem: alertContainerView, attribute: .leading, multiplier: 1.0, constant: buttonsContainerViewMargin)
        let buttonsContainerTrailing = NSLayoutConstraint(item: buttonsContainerView, attribute: .trailing, relatedBy: .equal, toItem: alertContainerView, attribute: .trailing, multiplier: 1.0, constant: -buttonsContainerViewMargin)
        let buttonsContainerBottom = NSLayoutConstraint(item: buttonsContainerView, attribute: .bottom, relatedBy: .equal, toItem: alertContainerView, attribute: .bottom, multiplier: 1.0, constant: -kYmargin)
        alertContainerView.addConstraints([buttonsContainerTrailing, buttonsContainerLeading, buttonsContainerBottom])

        if (buttons.count != 2 && buttons.count > 0) || alertStyle == .actionSheet {
            var separatorColor = UIColor.clear

            if alertStyle == .actionSheet {
                separatorColor = UIColor.lightGray
            }

            for count in 1 ..< buttons.count {
                let button = buttons[count]
                buttonsContainerView.addSubview(button)

                button.translatesAutoresizingMaskIntoConstraints = false

                let buttonLeading = NSLayoutConstraint(item: button, attribute: .leading, relatedBy: .equal, toItem: buttonsContainerView, attribute: .leading, multiplier: 1.0, constant: 0.0)

                let buttonTrailing = NSLayoutConstraint(item: button, attribute: .trailing, relatedBy: .equal, toItem: buttonsContainerView, attribute: .trailing, multiplier: 1.0, constant: 0.0)

                let buttonHeight = NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: kButtonsHeight)

                var allConstraints = [buttonLeading, buttonTrailing, buttonHeight]

                if count == 1 {
                    let buttonTop = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: buttonsContainerView, attribute: .top, multiplier: 1.0, constant: 0.0)
                    allConstraints.append(buttonTop)

                } else {
                    let topButton = buttons[count - 1]
                    let buttonTop = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: topButton, attribute: .bottom, multiplier: 1.0, constant: 5.0)

                    allConstraints.append(buttonTop)

                    let separatorView = UIView()
                    separatorView.backgroundColor = separatorColor
                    buttonsContainerView.addSubview(separatorView)

                    separatorView.translatesAutoresizingMaskIntoConstraints = false
                    let separatorViewHeight = NSLayoutConstraint(item: separatorView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1.0 / UIScreen.main.scale)
                    let separatorViewTop = NSLayoutConstraint(item: separatorView, attribute: .top, relatedBy: .equal, toItem: topButton, attribute: .bottom, multiplier: 1.0, constant: 2.5)
                    let separatorViewtrailing = NSLayoutConstraint(item: separatorView, attribute: .trailing, relatedBy: .equal, toItem: buttonsContainerView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
                    let separatorViewLeading = NSLayoutConstraint(item: separatorView, attribute: .leading, relatedBy: .equal, toItem: buttonsContainerView, attribute: .leading, multiplier: 1.0, constant: 0.0)

                    separatorView.addConstraint(separatorViewHeight)
                    allConstraints.append(separatorViewTop)
                    allConstraints.append(separatorViewLeading)
                    allConstraints.append(separatorViewtrailing)
                }

                if alertStyle == .actionSheet && count == buttons.count - 1 {
                    let bottomButton = NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: buttonsContainerView, attribute: .bottom, multiplier: 1.0, constant: -5.0)
                    allConstraints.append(bottomButton)
                }

                buttonsContainerView.addConstraints(allConstraints)
            }

            let button = buttons[0]

            var currentView: UIView?
            var cancelButtonView: UIView?

            var offset: CGFloat = 0.0

            if alertStyle == .actionSheet {
                offset = kYmargin

                cancelButtonView = UIView()
                cancelButtonView?.backgroundColor = UIColor.white
                cancelButtonView?.layer.cornerRadius = kCornerRadius * 2.0
                cancelButtonView?.clipsToBounds = true

                actionSheetContainerView.addSubview(cancelButtonView!)
                currentView = cancelButtonView

                cancelButtonView?.translatesAutoresizingMaskIntoConstraints = false

                let cancelButtonTop = NSLayoutConstraint(item: cancelButtonView!, attribute: .top, relatedBy: .equal, toItem: alertContainerView, attribute: .bottom, multiplier: 1.0, constant: 5.0)
                let cancelButtonBottom = NSLayoutConstraint(item: cancelButtonView!, attribute: .bottom, relatedBy: .equal, toItem: actionSheetContainerView, attribute: .bottom, multiplier: 1.0, constant: -5.0)
                let cancelButtonLeading = NSLayoutConstraint(item: cancelButtonView!, attribute: .leading, relatedBy: .equal, toItem: alertContainerView, attribute: .leading, multiplier: 1.0, constant: 0.0)
                let cancelButtonTrailing = NSLayoutConstraint(item: cancelButtonView!, attribute: .trailing, relatedBy: .equal, toItem: alertContainerView, attribute: .trailing, multiplier: 1.0, constant: 0.0)

                actionSheetContainerView.addConstraints([cancelButtonTop, cancelButtonBottom, cancelButtonTrailing, cancelButtonLeading])

            } else {
                currentView = buttonsContainerView
            }

            currentView!.addSubview(button)

            button.translatesAutoresizingMaskIntoConstraints = false

            let buttonLeading = NSLayoutConstraint(item: button, attribute: .leading, relatedBy: .equal, toItem: currentView!, attribute: .leading, multiplier: 1.0, constant: 30.0)

            let buttonTrailing = NSLayoutConstraint(item: button, attribute: .trailing, relatedBy: .equal, toItem: currentView!, attribute: .trailing, multiplier: 1.0, constant: -30.0)

            let buttonHeight = NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: kButtonsHeight)

            let buttonBottom = NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: currentView!, attribute: .bottom, multiplier: 1.0, constant: -offset)

            var buttonTop: NSLayoutConstraint?

            if buttons.count == 1 || alertStyle == .actionSheet {
                buttonTop = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: currentView!, attribute: .top, multiplier: 1.0, constant: offset)

            } else {
                let topButton = buttons[buttons.count - 1]
                buttonTop = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: topButton, attribute: .bottom, multiplier: 1.0, constant: 5.0)
            }

            currentView!.addConstraints([buttonLeading, buttonTrailing, buttonHeight, buttonBottom, buttonTop!])

        } else {
            // if button Count is equal to two
            let buttonYMargin:CGFloat = 5.0
            let buttonWidth:CGFloat = kAlertContainerViewWidth / 2.0 - kXMargin - buttonYMargin/2.0
            var count = 0

            for button in buttons {
                buttonsContainerView.addSubview(button)

                button.translatesAutoresizingMaskIntoConstraints = false

                let buttonHeight = NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: kButtonsHeight)
                let buttonWidth = NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: buttonWidth)

                let buttonTop = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: buttonsContainerView, attribute: .top, multiplier: 1.0, constant: 0.0)

                let buttonBottom = NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: buttonsContainerView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
                let buttonLeading: NSLayoutConstraint?

                if count == 0 {
                    buttonLeading = NSLayoutConstraint(item: button, attribute: .leading, relatedBy: .equal, toItem: buttonsContainerView, attribute: .leading, multiplier: 1.0, constant: 0.0)

                } else {
                    buttonLeading = NSLayoutConstraint(item: button, attribute: .leading, relatedBy: .equal, toItem: buttons[0], attribute: .trailing, multiplier: 1.0, constant: buttonYMargin)
                }

                buttonsContainerView.addConstraints([buttonHeight, buttonWidth, buttonTop, buttonBottom, buttonLeading!])
                count += 1
            }
        }

        if textFields.count > 0 {

            var count = 0

            for textField in textFields {
                textFieldsContainerView.addSubview(textField)

                textField.translatesAutoresizingMaskIntoConstraints = false

                let textFieldLeading = NSLayoutConstraint(item: textField, attribute: .leading, relatedBy: .equal, toItem: textFieldsContainerView, attribute: .leading, multiplier: 1.0, constant: 0.0)

                let textFieldTrailing = NSLayoutConstraint(item: textField, attribute: .trailing, relatedBy: .equal, toItem: textFieldsContainerView, attribute: .trailing, multiplier: 1.0, constant: 0.0)

                let textFieldHeight = NSLayoutConstraint(item: textField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: kTextFieldsHeight)
                var yMargin: CGFloat = 5.0

                var allConstraints = [textFieldLeading, textFieldTrailing, textFieldHeight]

                if count == 0 {
                    let textFieldTop = NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: textFieldsContainerView, attribute: .top, multiplier: 1.0, constant: 0.0)
                    allConstraints.append(textFieldTop)

                } else {
                    let topButton = textFields[count - 1]
                    let textFieldTop = NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: topButton, attribute: .bottom, multiplier: 1.0, constant: yMargin)

                    allConstraints.append(textFieldTop)

                }

                // Devloper's Note: Applies to both conditions i.e count = 0 & Count > 0

                if count == textFields.count - 1 {
                    yMargin = 0.0

                    let textFieldBottom = NSLayoutConstraint(item: textField, attribute: .bottom, relatedBy: .equal, toItem: textFieldsContainerView, attribute: .bottom, multiplier: 1.0, constant: yMargin)
                    allConstraints.append(textFieldBottom)
                }

                count += 1

                textFieldsContainerView.addConstraints(allConstraints)
            }
        }
    }

    // MARK: - UITextFieldDelegate

    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextFild = textField
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // TODO: Implement KeyBoardReturn Types specifically Next
        textField.resignFirstResponder()

        return true
    }

    // MARK: - UIKeyboardNotification handlers

    @objc func keyboardDidShow(_ sender: Notification) {

        if activeTextFild == nil {
            return
        }

        if let info = sender.userInfo {

            if let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let height: CGFloat = keyboardSize.height
                var aRect = view.frame
                aRect.size.height -= height

                let someRect = textFieldsContainerView.convert(activeTextFild!.frame, to: view)

                if !aRect.contains(CGPoint(x: someRect.minX, y: someRect.maxY)) {
                    alertContainerViewVerticalConstraint?.constant -= height / 2.0
                    view.layoutIfNeeded()
                }
            }
        }
    }

    @objc func keyboardWillHide(_ sender: Notification) {
        alertContainerViewVerticalConstraint?.constant = 0.0
        view.layoutIfNeeded()
    }

    // MARK: - UIButtons actions

    @objc func actionButtonTapped(_ sender: UIButton) {
        let action = actions[sender.tag - 1]

        action.handler(action)

        dismiss(animated: true, completion: nil)
    }

    // MARK: - Public methods

    func addAction(_ action: VTAlertAction) {
        // TODO: Always insert action with style .Cancel at position 0
        var tag = 0
        var textColor = UIColor.black
        var buttonBackgroundColor = UIColor.white

        if action.style == .cancel {
            textColor = UIColor.orange
            _ = actions.index {
                let action = $0 as VTAlertAction

                if action.style == .cancel {
                    assert(false,"AlertViewController can have only one action with .Cancel style")
                    return true
                }
                return false
            }

            actions.insert(action, at: 0)
            tag = 1

            for button in buttons {
                button.tag += 1
            }

        } else {
            actions.append(action)
            tag = actions.count
        }

        let button = UIButton()

        if alertStyle == .alert {
            textColor = UIColor.white
            buttonBackgroundColor =  UIColor.appThemeColor()
            //button.layer.cornerRadius = kButtonsHeight / 2

        } else {

            if action.style != .cancel {
                button.contentHorizontalAlignment = .left
                button.titleEdgeInsets = UIEdgeInsetsMake(0.0, 15.0, 0.0, 0.0)
            }
        }

        button.setTitle(action.title, for: UIControlState())
        button.setTitleColor(textColor, for: UIControlState())
        // if action.style == .Cancel {
        button.titleLabel?.font = UIFont.appThemeFontWithSize(15.0)

        //        } else {
        //            button.titleLabel?.font = UIFont.appThemeFontWithSize(15.0)
        //        }

        button.clipsToBounds = true
        button.setBackgroundImage(UIImage(color: buttonBackgroundColor), for: UIControlState())
        button.tag = tag
        button.addTarget(self, action: #selector(VTAlertViewController.actionButtonTapped(_:)), for: .touchUpInside)

        if action.style == .cancel {
            buttons.insert(button, at: 0)

        } else {
            buttons.append(button)
        }
    }

    func addTextFieldWithConfigurationHandler(_ handler: (_ textField: UITextField) -> Void) {

        assert(alertStyle == .alert, "AlertViewController with style .ActionSheet cannot have textFields")

        let textField = UITextField()
        textField.layer.cornerRadius = kCornerRadius * 2.0
        if textFields.count < 2 {
            textFields.append(textField)

        } else {
            textFields[2] = textField
        }

        textField.delegate = self
        textField.tag = textFields.count

        handler(textField)
    }

    // MARK: Private methods

    func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(VTAlertViewController.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(VTAlertViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func unRegisterNotifications() {
        NotificationCenter.default.removeObserver(self)
    }

}

extension VTAlertViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        let alertPresentAnimationController = VTAlertPresentAnimationController()

        return alertPresentAnimationController
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let alertDismissAnimationController = VTAlertDismissAnimationController()

        return alertDismissAnimationController
    }

}
