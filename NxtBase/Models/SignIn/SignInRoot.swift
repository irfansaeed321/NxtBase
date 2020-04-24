//
//  SignInRoot.swift
//  NxtBase
//
//  Created by mac on 04/04/2020.
//  Copyright © 2020 Private. All rights reserved.
//

import Foundation

struct SignInRoot{

    var action : String!
    var code : Int!
    var data : SignInData!
    var message : String!
    var status : Bool!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        action = dictionary["action"] as? String
        code = dictionary["code"] as? Int
        if let dataData = dictionary["data"] as? [String:Any]{
                data = SignInData(fromDictionary: dataData)
            }
        message = dictionary["message"] as? String
        status = dictionary["status"] as? Bool
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
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
