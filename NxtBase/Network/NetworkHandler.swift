//
//  NetworkHandler.swift
//  NxtBase
//
//  Created by mac on 04/04/2020.
//  Copyright © 2020 Private. All rights reserved.
//

import Foundation
import Alamofire

class NetworkHandler {
    
    class func postRequest(url: String, parameters: Parameters?, success: @escaping (Any) -> Void, failure: @escaping (NetworkError) -> Void) {
        if Network.isAvailable {
            var headers: HTTPHeaders
            if let userToken = UserDefaults.standard.value(forKey: "userAuthToken") as? String {
                headers = [
                    "Accept": "application/json",
                    "Authorization" : "\(userToken)"
                ]
            } else {
                headers = [
                    "Accept": "application/json"
                ]
            }
            print(headers)
            let manager = Alamofire.Session.default
            manager.session.configuration.timeoutIntervalForRequest = Constants.NetworkError.timeOutInterval
            manager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) -> Void in
                print(response)
                if let userToken = response.response?.allHeaderFields["Authorization"] as? String {
                    UserDefaults.standard.setValue(userToken, forKey: "userAuthToken")
                    debugPrint("\(UserDefaults.standard.value(forKey: "userAuthToken")!)")
                }
                
                if let verifyToken = response.response?.allHeaderFields["verification_code"] as? String {
                    UserDefaults.standard.setValue(verifyToken, forKey: "authCode")
                }
                
                guard let statusCode = response.response?.statusCode else {
                    var networkError = NetworkError()
                    
                    networkError.status = Constants.NetworkError.timout
                    networkError.message = Constants.NetworkError.timoutError
                    
                    failure(networkError)
                    return
                    
                }
                
                if statusCode == 422 {
                    var networkError = NetworkError()
//                     let response = response.result.value!
                    let response = response.value
                    let dictionary = response as! [String: AnyObject]
                    
                    guard let message = dictionary["error"] as! String? else {
                        networkError.status = statusCode
                        networkError.message = "Validation Error"
                        
                        failure(networkError)
                        
                        return
                    }
                    networkError.status = statusCode
                    networkError.message = message
                    
                    failure(networkError)
                    
                    
                }else{
                    switch (response.result) {
                    case .success:
                        let responseData = response.value
                        success(responseData!)
                        break
                    case .failure(let error):
                        var networkError = NetworkError()
                        if error._code == NSURLErrorTimedOut {
                            networkError.status = Constants.NetworkError.timout
                            networkError.message = Constants.NetworkError.timoutError
                            
                            failure(networkError)
                        } else {
                            networkError.status = Constants.NetworkError.generic
                            networkError.message = Constants.NetworkError.genericError
                            
                            failure(networkError)
                        }
                        break
                    }
                }
            }
        } else {
            let networkError = NetworkError(status: Constants.NetworkError.internet, message: Constants.NetworkError.internetError)
            failure(networkError)
        }
    }
    
    
    class func getRequest(url: String, parameters: Parameters?, success: @escaping (Any?) -> Void, failure: @escaping (NetworkError) -> Void) {
    
        let manager = Alamofire.Session.default
        manager.session.configuration.timeoutIntervalForRequest = Constants.NetworkError.timeOutInterval
        
        var headers: HTTPHeaders
        if let userToken = UserDefaults.standard.value(forKey: "userAuthToken") as? String {
            headers = [
                "Accept": "application/json",
                "Authorization" : "\(userToken)"
            ]
        } else {
            headers = [
                "Accept": "application/json"
            ]
        }
        print(headers)
        manager.request(url, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON
            { (response) -> Void in
                print(response)
            switch response.result{
            //Case 1
            case .success:
                let responseData = response.value
                success(responseData)
                break
            case .failure (let error):
                 print(error)
                var networkError = NetworkError()
                
                if error._code == NSURLErrorTimedOut {
                    networkError.status = Constants.NetworkError.timout
                    networkError.message = Constants.NetworkError.timoutError
                    
                    failure(networkError)
                } else {
                    networkError.status = Constants.NetworkError.generic
                    networkError.message = Constants.NetworkError.genericError
                    
                    failure(networkError)
                }
                break
            }
        }
    }
}

struct NetworkError {
    var status: Int = Constants.NetworkError.generic
    var message: String = Constants.NetworkError.genericError
}

struct NetworkSuccess {
    var status: Int = Constants.NetworkError.generic
    var message: String = Constants.NetworkError.genericError
}


