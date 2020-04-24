//
//  Splash.swift
//  NxtBase
//
//  Created by mac on 04/04/2020.
//  Copyright © 2020 Private. All rights reserved.
//

import UIKit

class Splash: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkLogin()
    }
    
    
    //MARK:- Custom
    func checkLogin() {
        let isLogin = UserDefaults.standard.bool(forKey: "isLogin")
        if isLogin {
            let user_id = UserDefaults.standard.integer(forKey: "user_id")
            SharedManager.shared.user_id = user_id
            appDelegate.moveToChat()
        } else {
            appDelegate.moveToLogin()
        }
    }
}
