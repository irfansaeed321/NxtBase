//
//  LoginController.swift
//  NxtBase
//
//  Created by mac on 04/04/2020.
//  Copyright © 2020 Private. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var txtEmail: UITextField!{
        didSet {
            txtEmail.delegate = self
        }
    }
    @IBOutlet weak var txtPassword: UITextField!{
        didSet {
            txtPassword.delegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
    }
    
    //MARK:- Custom
    func validateFields() {
        guard let email = txtEmail.text else {return}
        guard let password = txtPassword.text else {return}
        
        if email == "" {
            let alert =  Constants.showBasicAlertGlobal(message: "Enter Email")
            presentVC(alert)
        } else if !email.isValidEmail {
            let alert =  Constants.showBasicAlertGlobal(message: "Enter valid Email")
            presentVC(alert)
        } else if password == "" {
            let alert =  Constants.showBasicAlertGlobal(message: "Enter Password")
            presentVC(alert)
        } else {
            let param: [String:Any] = ["email": email, "password": password]
            print(param)
            loginUser(params: param)
        }
    }

    //MARK:- IBActions
    @IBAction func actionLogin(_ sender: UIButton) {
        validateFields()
    }
    
    
    @IBAction func actionSignUp(_ sender: UIButton) {
        let signupVC = storyboard?.instantiateViewController(withIdentifier: SignUp.className) as! SignUp
        navigationController?.pushViewController(signupVC, animated: true)
    }
    
    
    //MARK:- API Calls
    func loginUser(params: [String:Any]) {
        //        showSpinner()
        UserHandler.signIn(params: params, success: {[weak self] (successResponse) in
            guard let self = self else {return}
            self.hideSpinner()
            if successResponse.status && successResponse.code == 200 {
                UserDefaults.standard.set(true, forKey: "isLogin")
                UserDefaults.standard.set(successResponse.data.id, forKey: "user_id")
                UserDefaults.standard.synchronize()
                SharedManager.shared.user_id = successResponse.data.id
                self.appDelegate.moveToChat()
            } else {
                let alert = Constants.showBasicAlertGlobal(message: successResponse.message)
                self.presentVC(alert)
            }
        }) {[weak self] (error) in
            guard let self = self else {return}
            self.hideSpinner()
            let alert = Constants.showBasicAlertGlobal(message: error.message)
            self.presentVC(alert)
        }
    }
}

extension LoginController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txtEmail:
            txtPassword.becomeFirstResponder()
        case txtPassword:
            txtPassword.resignFirstResponder()
            validateFields()
        default:
            break
        }
        return true
    }
}
