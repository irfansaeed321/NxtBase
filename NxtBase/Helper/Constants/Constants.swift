//
//  Constants.swift
//  NxtBase
//
//  Created by mac on 04/04/2020.
//  Copyright © 2020 Private. All rights reserved.
//

import UIKit

class Constants {
    
    static let appName = "NxtBase"
    
    
    struct URL {
        static let baseUrl = "http://64.225.62.253:5006/"
        
        static let login = "api/user/signin"
        static let signUp = "api/user/signup"
        static let getChats = "api/chat/get_chat_messages"
    }
    
    struct DateFormat {
           static let fullDate = "MMM dd, yyyy hh:mm a"
           static let time = "hh:mm a"
           static let partialDate = "dd/MM/yyyy hh:mm a"
           static let dateFormat = "MMM dd, hh:mma"
       }
    
    static func showBasicAlertGlobal (message: String) -> UIAlertController{
        let alert = UIAlertController(title: Constants.appName, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        return alert
    }
    
    struct NetworkError {
        static let timeOutInterval: TimeInterval = 20
        
        static let error = "Error"
        static let internetNotAvailable = "Internet Not Available"
        static let pleaseTryAgain = "Please Try Again"
        
        static let generic = 4000
        static let genericError = "Please Try Again."
        
        static let serverErrorCode = 5000
        static let serverNotAvailable = "Server Not Available"
        static let serverError = "Server Not Availabe, Please Try Later."
        
        static let timout = 4001
        static let timoutError = "Network Time Out, Please Try Again."
        
        static let login = 4003
        static let loginMessage = "Unable To Login"
        static let loginError = "Please Try Again."
        
        static let internet = 4004
        static let internetError = "Internet Not Available"
    }
    
    struct activitySize {
          static let size = CGSize(width: 40, height: 40)
      }
      
      enum loaderMessages : String {
          case loadingMessage = ""
      }
      
}

