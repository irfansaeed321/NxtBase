//
//  ChatsData.swift
//  NxtBase
//
//  Created by mac on 05/04/2020.
//  Copyright © 2020 Private. All rights reserved.
//

import Foundation

struct ChatsData {

    var chatId : String!
    var createdAt : String!
    var id : Int!
    var message : String!
    var receiverId : String!
    var senderId : String!
    var unixTime : Int!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        chatId = dictionary["chat_id"] as? String
        createdAt = dictionary["created_at"] as? String
        id = dictionary["id"] as? Int
        message = dictionary["message"] as? String
        receiverId = dictionary["receiver_id"] as? String
        senderId = dictionary["sender_id"] as? String
        unixTime = dictionary["unix_time"] as? Int
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if chatId != nil{
            dictionary["chat_id"] = chatId
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if id != nil{
            dictionary["id"] = id
        }
        if message != nil{
            dictionary["message"] = message
        }
        if receiverId != nil{
            dictionary["receiver_id"] = receiverId
        }
        if senderId != nil{
            dictionary["sender_id"] = senderId
        }
        if unixTime != nil{
            dictionary["unix_time"] = unixTime
        }
        return dictionary
    }

}
