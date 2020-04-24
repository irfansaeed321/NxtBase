//
//  AppDelegate.swift
//  NxtBase
//
//  Created by mac on 04/04/2020.
//  Copyright © 2020 Private. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let keyboardManager = IQKeyboardManager.shared
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        keyboardManager.enable = true
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
       
    }   

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    
    }

    func applicationWillTerminate(_ application: UIApplication) {
        SocketIOManager.sharedInstance.closeConnection()
    }
}

extension AppDelegate {
    func moveToLogin() {
        let loginVC = storyboard.instantiateViewController(withIdentifier: LoginController.className) as! LoginController
        let nvc = UINavigationController(rootViewController: loginVC)
        window?.rootViewController = nvc
        window?.makeKeyAndVisible()
    }
    
    func moveToChat() {
        let loginVC = storyboard.instantiateViewController(withIdentifier: ChatController.className) as! ChatController
        let nvc = UINavigationController(rootViewController: loginVC)
        window?.rootViewController = nvc
        window?.makeKeyAndVisible()
    }
}
