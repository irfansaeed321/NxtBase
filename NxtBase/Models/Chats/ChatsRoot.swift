//
//  ChatsRoot.swift
//  NxtBase
//
//  Created by mac on 05/04/2020.
//  Copyright © 2020 Private. All rights reserved.
//

import Foundation

struct ChatsRoot{

    var action : String!
    var code : Int!
    var data : [ChatsData]!
    var message : String!
    var status : Bool!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        action = dictionary["action"] as? String
        code = dictionary["code"] as? Int
        data = [ChatsData]()
        if let dataArray = dictionary["data"] as? [[String:Any]]{
            for dic in dataArray{
                let value = ChatsData(fromDictionary: dic)
                data.append(value)
            }
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
            var dictionaryElements = [[String:Any]]()
            for dataElement in data {
                dictionaryElements.append(dataElement.toDictionary())
            }
            dictionary["data"] = dictionaryElements
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
