//
//  SocketModel.swift
//  NxtBase
//
//  Created by mac on 04/04/2020.
//  Copyright © 2020 Private. All rights reserved.
//

import Foundation

struct OnlineUsersObject {

    var name: String!
    var user_id: Int!

    init(fromDictionary dictionary: [String:Any]) {
        name = dictionary["name"] as? String
        user_id = dictionary["user_id"] as? Int
    }
}
