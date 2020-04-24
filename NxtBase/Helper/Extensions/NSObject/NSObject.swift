//
//  NSObject.swift
//  NxtBase
//
//  Created by mac on 04/04/2020.
//  Copyright © 2020 Private. All rights reserved.
//

import UIKit
import AVFoundation


extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
    
    var appDelegate : AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}
