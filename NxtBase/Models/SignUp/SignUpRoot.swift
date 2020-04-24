//
//  SignUpRoot.swift
//  NxtBase
//
//  Created by mac on 04/04/2020.
//  Copyright © 2020 Private. All rights reserved.
//

import Foundation

struct SignUpRoot{

    var action : String!
    var code : Int!
    var data : SignUpData!
    var message : String!
    var status : Bool!


    init(fromDictionary dictionary: [String:Any]){
        action = dictionary["action"] as? String
        code = dictionary["code"] as? Int
        if let dataData = dictionary["data"] as? [String:Any]{
            data = SignUpData(fromDictionary: dataData)
        }
        message = dictionary["message"] as? String
        status = dictionary["status"] as? Bool
    }

    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        if action != nil{
            dictionary["action"] = action
        }
        if code != nil{
            dictionary["code"] = code
        }
        if data != nil{
            dictionary["data"] = data.toDictionary()
        }
        if message != nil{
            dictionary["message"] = message
        }
        if status != nil{
            dictionary["status"] = status
        }
        return dictionary
    }

}
