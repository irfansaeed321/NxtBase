//
//  UserHandler.swift
//  NxtBase
//
//  Created by mac on 04/04/2020.
//  Copyright © 2020 Private. All rights reserved.
//

import Foundation

class UserHandler {
    
    static let shared = UserHandler()
    
    //MARK:- Sign Up
    class func signUp(params: [String:Any], success: @escaping(SignUpRoot)->Void, failure: @escaping(NetworkError)->Void) {
        let url = Constants.URL.baseUrl+Constants.URL.signUp
        print(url)
        NetworkHandler.postRequest(url: url, parameters: params, success: { (successResponse) in
            let dictionary = successResponse as! [String:Any]
            let obj = SignUpRoot(fromDictionary: dictionary)
            success(obj)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Sign In
    class func signIn(params: [String:Any], success: @escaping(SignInRoot)->Void, failure: @escaping(NetworkError)->Void) {
        let url = Constants.URL.baseUrl+Constants.URL.login
        print(url)
        NetworkHandler.postRequest(url: url, parameters: params, success: { (successResponse) in
            let dictionary = successResponse as! [String:Any]
            let obj = SignInRoot(fromDictionary: dictionary)
            success(obj)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Get Chats
    class func getChats(params: [String:Any], success: @escaping(ChatsRoot)->Void, failure: @escaping(NetworkError)->Void) {
        let url = Constants.URL.baseUrl+Constants.URL.getChats
        print(url)
        NetworkHandler.postRequest(url: url, parameters: params, success: { (successResponse) in
            let dictionary = successResponse as! [String:Any]
            let obj = ChatsRoot(fromDictionary: dictionary)
            success(obj)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
}
