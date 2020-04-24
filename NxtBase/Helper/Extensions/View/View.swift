//
//  View.swift
//  NxtBase
//
//  Created by mac on 04/04/2020.
//  Copyright © 2020 Private. All rights reserved.
//

import UIKit

extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func roundCorners(radius: CGFloat = 5, bordorColor: UIColor = .white, borderWidth: CGFloat = 0.5) {
        layer.cornerRadius = radius
        layer.borderColor = bordorColor.cgColor
        layer.borderWidth = borderWidth
        layer.masksToBounds = true
    }
    
    func circularView(bordorColor: UIColor = UIColor.white, borderWidth: CGFloat = 0.5) {
        layer.cornerRadius = frame.size.width/2
        clipsToBounds = true
        layer.masksToBounds = true
        layer.borderColor = bordorColor.cgColor
        layer.borderWidth = borderWidth
    }
    
    func addShadow(scale: Bool = true) {
        self.layer.cornerRadius = 5
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 5
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension UIView {
    func addShadowToView(cornerRadius:CGFloat = 7, color: UIColor = UIColor.lightGray) {
        backgroundColor = UIColor.white
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 5
        layer.cornerRadius = cornerRadius
    }
}

extension UIView {
    
    var top : CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            var frame       = self.frame
            frame.origin.y  = newValue
            self.frame      = frame
        }
    }
    
    var bottom : CGFloat{
        get{
            return frame.origin.y + frame.size.height
        }
        set{
            var frame       = self.frame
            frame.origin.y  = newValue - self.frame.size.height
            self.frame      = frame
        }
    }
    
    var right : CGFloat{
        get{
            return self.frame.origin.x + self.frame.size.width
        }
        set{
            var frame       = self.frame
            frame.origin.x  = newValue - self.frame.size.width
            self.frame      = frame
        }
    }
    
    var left : CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            var frame       = self.frame
            frame.origin.x  = newValue
            self.frame      = frame
        }
    }
}
