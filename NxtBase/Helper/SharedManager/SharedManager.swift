//
//  SharedManager.swift
//  NxtBase
//
//  Created by mac on 04/04/2020.
//  Copyright © 2020 Private. All rights reserved.
//

import Foundation


class SharedManager: NSObject {
    
    static let shared = SharedManager()
    
    private override init() {
        
    }
    
    var isIncomingCall = true
    var user_id = 0
    
    func returnJsonObject(dictionary:[String:Any]) -> String{
        var jsobobj:String = ""
        if #available(iOS 11.0, *) {
            let jsonData = try! JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.sortedKeys)
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            jsobobj = jsonString
        } else {
            
        }
        let valid = JSONSerialization.isValidJSONObject(jsobobj)
        if(valid){print("valid json")}
        return jsobobj
    }
    
    static func timeToShow(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: date) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = format
        formatter.locale = Locale.current
        // again convert your date to string
        let timeString = formatter.string(from: yourDate!)
        return timeString
    }
}



//let date = Date(timeIntervalSince1970: TimeInterval(time))
//                     let dateFormatter = DateFormatter()
//                     dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//                     dateFormatter.locale = NSLocale.current
//                     dateFormatter.dateFormat = "HH:mm"
//                     let strDate = dateFormatter.string(from: date)
//                     cell.lblTime.text = strDate
