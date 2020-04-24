//
//  SignUp.swift
//  NxtBase
//
//  Created by mac on 04/04/2020.
//  Copyright © 2020 Private. All rights reserved.
//

import UIKit

class SignUp: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var txtName: UITextField!{
        didSet {
            txtName.delegate = self
        }
    }
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
        title = "Sign Up"
    }
    
    //MARK:- Custom
    func validateFields() {
        guard let name = txtName.text else {return}
        guard let email = txtEmail.text else {return}
        guard let password = txtPassword.text else {return}
        if name == "" {
            let alert =  Constants.showBasicAlertGlobal(message: "Enter name")
            presentVC(alert)
        } else if email == "" {
            let alert =  Constants.showBasicAlertGlobal(message: "Enter Email")
            presentVC(alert)
        } else if !email.isValidEmail {
            let alert =  Constants.showBasicAlertGlobal(message: "Enter valid Email")
            presentVC(alert)
        } else if password == "" {
            let alert =  Constants.showBasicAlertGlobal(message: "Enter Password")
            presentVC(alert)
        } else {
            let param: [String:Any] = ["name": name, "email": email, "password": password]
            print(param)
            signUpUser(params: param)
        }
    }
    
    //MARK:- IBActions
    @IBAction func actionSignUp(_ sender: UIButton) {
        validateFields()
    }
    
    //MARK:- API Calls
    func signUpUser(params: [String:Any]) {
        //        showSpinner()
        UserHandler.signUp(params: params, success: {[weak self] (successResponse) in
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

extension SignUp: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txtName:
            txtName.becomeFirstResponder()
        case txtName:
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
