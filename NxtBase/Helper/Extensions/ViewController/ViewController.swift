//
//  ViewController.swift
//  NxtBase
//
//  Created by mac on 04/04/2020.
//  Copyright © 2020 Private. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

fileprivate var aView: UIView?

extension UIViewController {
    
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}

extension UIViewController: NVActivityIndicatorViewable {
    func showLoader(message: String = Constants.loaderMessages.loadingMessage.rawValue) {
        startAnimating(Constants.activitySize.size, message: message ,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballRotateChase)
    }
}

extension UIViewController {
    func showSpinner() {
       let aView = UIView(frame: view.bounds)
        aView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.center = aView.center
        indicator.startAnimating()
        aView.addSubview(indicator)
        self.view.addSubview(aView)
    }
    
    func hideSpinner() {
        aView?.removeFromSuperview()
        aView = nil
    }
}

extension UIViewController {
    func showNavigationActivity() {
//        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let activityIndicator = UIActivityIndicatorView()
//        if #available(iOS 13, *) {
//            activityIndicator.style = .large
//        } else {
        activityIndicator.style = .gray
//        }
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)
        activityIndicator.startAnimating()
    }
    
    func hideNavigationActivity() {
        navigationItem.rightBarButtonItem = nil
    }
}

extension UIViewController {
    func hideBackButton() {
        self.navigationItem.hidesBackButton = true
    }
    
    func showBackButton(isFromBottom: Bool = false) {
        self.hideBackButton()
        let backButton = UIButton(type: .custom)
        if #available(iOS 11, *) {
            backButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
            backButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        } else {
            backButton.frame = CGRect(x: 0, y: 0, width: 25, height: 20)
        }
        let image = UIImage(named: "back-arrow")?.withRenderingMode(.alwaysTemplate)
        backButton.setBackgroundImage(image, for: .normal)
        backButton.tintColor = .white
        if isFromBottom {
            backButton.addTarget(self, action: #selector(hideFromBottom), for: .touchUpInside)
        } else {
            backButton.addTarget(self, action: #selector(onBackButtonClciked), for: .touchUpInside)
        }
        let backBarButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backBarButton
    }
    
    @objc func onBackButtonClciked() {
        navigationController?.popViewController(animated: true)
    }
}

extension UIViewController {
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        if let navController = self.navigationController {
            navController.view.endEditing(true)
        }
    }
}

extension UIViewController {
    func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        })
    }
}
extension UIViewController {

    var topbarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        } else {
            let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
            return topBarHeight
        }
    }
    var statusbarheight: CGFloat {
        if #available(iOS 13.0, *) {
            return view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0
        } else {
            let topBarHeight = UIApplication.shared.statusBarFrame.size.height
            return topBarHeight
        }
    }
    var navbarheight: CGFloat {
        if #available(iOS 13.0, *) {
            return self.navigationController?.navigationBar.frame.height ?? 0.0
        } else {
            let topBarHeight = self.navigationController?.navigationBar.frame.height ?? 0.0
            return topBarHeight
        }
    }

}

extension UIViewController {
    
    open func presentVC(_ vc: UIViewController) {
        present(vc, animated: true, completion: nil)
    }
    
    open func presentVC(_ vc: UIViewController, completion: (() -> Swift.Void)?) {
        present(vc, animated: true, completion: completion)
    }
    
    open func dismissVC(completion: (() -> Void)? ) {
        dismiss(animated: true, completion: completion)
    }
    
    open func addAsChildViewController(_ vc: UIViewController, toView: UIView) {
        self.addChild(vc)
        toView.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    open func pushFromBottom(_ vc: UIViewController) {
        let navigationController = self.navigationController
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc open func hideFromBottom() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        navigationController?.view.layer.add(transition, forKey: nil)
        _ = navigationController?.popViewController(animated: false)
    }
}

extension UIViewController {
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: 50, y: self.view.frame.size.height-100, width: self.view.frame.width - 100, height: 35))
        toastLabel.backgroundColor = UIColor.darkGray.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.3, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

extension UIViewController {
    ///EZSE: Adds an NotificationCenter with name and Selector
    open func addNotificationObserver(_ name: String, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: NSNotification.Name(rawValue: name), object: nil)
    }
    
    ///EZSE: Removes an NSNotificationCenter for name
    open func removeNotificationObserver(_ name: String) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: name), object: nil)
    }
    
    ///EZSE: Removes NotificationCenter'd observer
    open func removeNotificationObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    #if os(iOS)
    
    ///EZSE: Adds a NotificationCenter Observer for keyboardWillShowNotification()
    ///
    /// ⚠️ You also need to implement ```keyboardWillShowNotification(_ notification: Notification)```
    open func addKeyboardWillShowNotification() {
        self.addNotificationObserver(UIResponder.keyboardWillShowNotification.rawValue, selector: #selector(UIViewController.keyboardWillShowNotification(_:)))
    }
    
    ///EZSE:  Adds a NotificationCenter Observer for keyboardDidShowNotification()
    ///
    /// ⚠️ You also need to implement ```keyboardDidShowNotification(_ notification: Notification)```
    public func addKeyboardDidShowNotification() {
        self.addNotificationObserver(UIResponder.keyboardDidShowNotification.rawValue, selector: #selector(UIViewController.keyboardDidShowNotification(_:)))
    }
    
    ///EZSE:  Adds a NotificationCenter Observer for keyboardWillHideNotification()
    ///
    /// ⚠️ You also need to implement ```keyboardWillHideNotification(_ notification: Notification)```
    open func addKeyboardWillHideNotification() {
        self.addNotificationObserver(UIResponder.keyboardWillHideNotification.rawValue, selector: #selector(UIViewController.keyboardWillHideNotification(_:)))
    }
  
    open func addKeyboardDidHideNotification() {
        self.addNotificationObserver(UIResponder.keyboardDidHideNotification.rawValue, selector: #selector(UIViewController.keyboardDidHideNotification(_:)))
    }
    
    open func removeKeyboardWillShowNotification() {
        self.removeNotificationObserver(UIResponder.keyboardWillShowNotification.rawValue)
    }
    
    open func removeKeyboardDidShowNotification() {
        self.removeNotificationObserver(UIResponder.keyboardDidShowNotification.rawValue)
    }
    
    open func removeKeyboardWillHideNotification() {
        self.removeNotificationObserver(UIResponder.keyboardWillHideNotification.rawValue)
    }
    
    ///EZSE: Removes keyboardDidHideNotification()'s NotificationCenter Observer
    open func removeKeyboardDidHideNotification() {
        self.removeNotificationObserver(UIResponder.keyboardDidHideNotification.rawValue)
    }
    
    @objc open func keyboardDidShowNotification(_ notification: Notification) {
        if let nInfo = (notification as NSNotification).userInfo, let value = nInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let frame = value.cgRectValue
            keyboardDidShowWithFrame(frame)
        }
    }
    
    @objc open func keyboardWillShowNotification(_ notification: Notification) {
        if let nInfo = (notification as NSNotification).userInfo, let value = nInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let frame = value.cgRectValue
            keyboardWillShowWithFrame(frame)
        }
    }
    
    @objc open func keyboardWillHideNotification(_ notification: Notification) {
        if let nInfo = (notification as NSNotification).userInfo, let value = nInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let frame = value.cgRectValue
            keyboardWillHideWithFrame(frame)
        }
    }
    
    @objc open func keyboardDidHideNotification(_ notification: Notification) {
        if let nInfo = (notification as NSNotification).userInfo, let value = nInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let frame = value.cgRectValue
            keyboardDidHideWithFrame(frame)
        }
    }
    
    open func keyboardWillShowWithFrame(_ frame: CGRect) {
        
    }
    
    open func keyboardDidShowWithFrame(_ frame: CGRect) {
        
    }
    
    open func keyboardWillHideWithFrame(_ frame: CGRect) {
        
    }
    
    open func keyboardDidHideWithFrame(_ frame: CGRect) {
        
    }
    
    //EZSE: Makes the UIViewController register tap events and hides keyboard when clicked somewhere in the ViewController.
    open func hideKeyboardWhenTappedAround(cancelTouches: Bool = false) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = cancelTouches
        view.addGestureRecognizer(tap)
    }
    
    #endif
    
    ///EZSE: Returns Tab Bar's height
    open var tabBarHeight: CGFloat {
        if let me = self as? UINavigationController, let visibleViewController = me.visibleViewController {
            return visibleViewController.tabBarHeight
        }
        if let tab = self.tabBarController {
            return tab.tabBar.frame.size.height
        }
        return 0
    }
    
    ///EZSE: Returns Navigation Bar's color
    open var navigationBarColor: UIColor? {
        get {
            if let me = self as? UINavigationController, let visibleViewController = me.visibleViewController {
                return visibleViewController.navigationBarColor
            }
            return navigationController?.navigationBar.tintColor
        } set(value) {
            navigationController?.navigationBar.barTintColor = value
        }
    }
    
    ///EZSE: Returns current Navigation Bar
    open var navBar: UINavigationBar? {
        return navigationController?.navigationBar
    }
    
    /// EZSwiftExtensions
    
    
    // MARK: - VC Flow
    open func pushVC(_ vc: UIViewController, completion: (() -> Swift.Void)?) {
        CATransaction.begin()
        navigationController?.pushViewController(vc, animated: true)
        
        CATransaction.setCompletionBlock({
            completion?()
        })
        CATransaction.commit()
    }
    
    open func popVC(completion: (() -> Swift.Void)?) {
        CATransaction.begin()
        _ = navigationController?.popViewController(animated: true)
        
        CATransaction.setCompletionBlock({
            completion?()
        })
        CATransaction.commit()
    }
    
    ///EZSE: Pushes a view controller onto the receiver’s stack and updates the display.
    open func pushVC(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    ///EZSE: Pops the top view controller from the navigation stack and updates the display.
    open func popVC() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    /// EZSE: Hide or show navigation bar
    public var isNavBarHidden:Bool {
        get {
            return (navigationController?.isNavigationBarHidden)!
        }
        set {
            navigationController?.isNavigationBarHidden = newValue
        }
    }
    
    /// EZSE: Added extension for popToRootViewController
    open func popToRootVC() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    
    open func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.24
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        present(viewControllerToPresent, animated: false)
    }
    
    open func dismissDetail() {
        let transition = CATransition()
        transition.duration = 0.24
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false)
    }
    
    ///EZSE: Adds image named: as a UIImageView in the Background
    open func setBackgroundImage(_ named: String) {
        let image = UIImage(named: named)
        let imageView = UIImageView(frame: view.frame)
        imageView.image = image
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
    }
    
    ///EZSE: Adds UIImage as a UIImageView in the Background
    @nonobjc func setBackgroundImage(_ image: UIImage) {
        let imageView = UIImageView(frame: view.frame)
        imageView.image = image
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
    }
    
    #if os(iOS)
    @available(*, deprecated)
    public func hideKeyboardWhenTappedAroundAndCancelsTouchesInView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    #endif
}


extension UIViewController {
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController()
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController!.topMostViewController()
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}
