//
//  SignInData.swift
//  NxtBase
//
//  Created by mac on 04/04/2020.
//  Copyright © 2020 Private. All rights reserved.
//

import Foundation

struct SignInData{

    var email : String!
    var id : Int!
    var name : String!
    var profileImage : String!
    var token : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        email = dictionary["email"] as? String
        id = dictionary["id"] as? Int
        name = dictionary["name"] as? String
        profileImage = dictionary["profile_image"] as? String
        token = dictionary["token"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if email != nil{
            dictionary["email"] = email
        }
        if id != nil{
            dictionary["id"] = id
        }
        if name != nil{
            dictionary["name"] = name
        }
        if profileImage != nil{
            dictionary["profile_image"] = profileImage
        }
        if token != nil{
            dictionary["token"] = token
        }
        return dictionary
    }

}
