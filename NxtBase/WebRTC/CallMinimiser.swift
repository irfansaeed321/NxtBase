//
//  CallMinimiser.swift
//  NxtBase
//
//  Created by mac on 11/04/2020.
//  Copyright © 2020 Private. All rights reserved.
//


import Foundation
import UIKit


class CallMinimiser: NSObject {
    
    static let sharedInstance = CallMinimiser()
    var newView:UIView?
    var labelTap:UITapGestureRecognizer?
    var labelTimer:UILabel?


    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        CallManager.sharedInstance.maximiseCall()
    }
        func hideCallBar()  {
    //        SwiftEntryKit.dismiss(.all)
    //        customView?.removeFromSuperview()
//            newView?.removeGestureRecognizer(labelTap!)
            newView?.removeFromSuperview()

        }

    func updateTimerLabeltext(time:String){
        labelTimer?.text = time
    }
    func showCallBar(name:String) {
        
        let app = UIApplication.shared
        let statusbarheight = app.statusBarFrame.size.height

        
        if let tabController = appDelegate.window?.rootViewController as? UITabBarController {
        
            print(tabController)
            if let navController = tabController.selectedViewController as? UINavigationController {
             print(navController)

                let rootViewController = navController.viewControllers.first

                print(rootViewController as Any)
                var size2 = rootViewController?.navbarheight
                print("size \(size2)")
                print("y_pos \(statusbarheight)")
                newView = UIView()
                newView?.frame = CGRect(x:0,y:statusbarheight, width: ScreenSizeUtil.width(), height: rootViewController?.navbarheight ?? 44)
                newView?.backgroundColor = UIColor(displayP3Red: 27.0/255.0, green: 191.0/255.0, blue: 122.0/255.0, alpha: 1.0)
                
                var imageView : UIImageView
                imageView  = UIImageView(frame:CGRect(x: 10, y: 12, width: 20, height: 20));
                imageView.image = UIImage(named:"audio-call")
                newView?.addSubview(imageView)
                
                
                let label = UILabel()
//                label.frame = newView!.bounds
                label.frame = CGRect(x:imageView.frame.maxX+10,y:0, width: 100, height: rootViewController?.navbarheight ?? 44)
                label.textAlignment = .left
                label.textColor = .white
                label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
                label.text = "Return to call"
                let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
                label.isUserInteractionEnabled = true

                newView?.addSubview(label)

                labelTimer = UILabel()
                labelTimer?.frame = CGRect(x:label.frame.maxX+50,y:0, width: 100, height: rootViewController?.navbarheight ?? 44)
                labelTimer?.textAlignment = .left
                labelTimer?.textColor = .white
                labelTimer?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
                labelTimer?.text = "00:00"
                labelTimer?.isUserInteractionEnabled = true
//                labelTimer.addGestureRecognizer(labelTap)
                
                newView?.addSubview(labelTimer!)
                
                let namelabel = UILabel()
                namelabel.frame = CGRect(x:(newView?.frame.size.width ?? ScreenSizeUtil.width()) - 150 ,y:0, width: 140, height: rootViewController?.navbarheight ?? 44)
                namelabel.textAlignment = .right
                namelabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
                namelabel.textColor = .white
                namelabel.text = name
                newView?.addSubview(namelabel)

                newView?.addGestureRecognizer(labelTap)

                UIApplication.shared.keyWindow?.addSubview(newView!)

            }
            
        }
        
        //                customView = callbar().loadNib()
        //                customView?.frame = CGRect(x:0,y:statusbarheight, width: ScreenSizeUtil.width(), height: rootViewController?.navbarheight ?? 44)
        ////                customView?.callername.text = name

        
//        let logo = UIImage(named: "topbar")
//        let imageView = UIImageView(image:logo)
//        imageView.contentMode = .scaleAspectFit
//
//        appDelegate.window?.rootViewController?.navigationItem.titleView = imageView
//        appDelegate.window?.rootViewController?.navigationController?.navigationBar.prefersLargeTitles = false

        
        
        /*
        // Create a basic toast that appears at the top
        var attributes = EKAttributes.topFloat

        // Set its background to white
        attributes.entryBackground = .color(color: .init(red: 41, green: 190, blue: 124))
        attributes.displayDuration = .infinity

        // Animate in and out using default translation
        attributes.entranceAnimation = .translation
        attributes.exitAnimation = .translation
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .disabled
        let action = {
            print("CALLLLLLLLLLLLL maximised")
            CallManager.sharedInstance.maximiseCall()

        }
        attributes.entryInteraction.customTapActions.append(action)
*/

        /*
        var customview = UIView(frame: CGRect(x: 0, y: 64, width: ScreenSizeUtil.width(), height: 20))
        customview.backgroundColor = UIColor.green


        var label = UILabel(frame: CGRect(x: 12, y: 8, width: customview.frame.size.width-90, height: 50))
        label.text = "Connection error please try again later!!"
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        customview.addSubview(label)

        var button = UIButton(frame: CGRect(x: customview.frame.size.width-87, y: 8, width: 86, height: 50))
        button.setTitle("OK", for: .normal)
        button.setTitleColor(UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0), for: .normal)
        //        button.addTarget(self, action: "hideSnackBar:", forSelector("hideSnackBar:"),.touchUpInside)

        customview.addSubview(button)

        
        let title = EKProperty.LabelContent(text: "Tap to return to call", style: .init(font: UIFont(name: "Arial", size: 15)!, color: .white))
        let description = EKProperty.LabelContent(text: name, style: .init(font: UIFont(name: "Arial-BoldMT", size: 13)!, color: .white))
        let image = EKProperty.ImageContent(image: UIImage(named: "call-recieve")!, size: CGSize(width: 35, height: 35))
        let simpleMessage = EKSimpleMessage(image: nil, title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        let contentView = EKNotificationMessageView(with: notificationMessage)


        SwiftEntryKit.display(entry: contentView, using: attributes)
        */
        
//        var attributes = EKAttributes.topFloat
//        attributes.entryBackground = .gradient(gradient: .init(colors: [EKColor(.red), EKColor(.green)], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
//        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
//        attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
//        attributes.statusBar = .dark
//        attributes.displayDuration = .infinity
//        attributes.scroll = .disabled
//        attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.min), height: .intrinsic)
//
//        let title = EKProperty.LabelContent(text: "call", style: .init(font: UIFont(name: "Arial", size: 10)!, color: .black))
//        let description = EKProperty.LabelContent(text: "press", style: .init(font: UIFont(name: "Arial", size: 10)!, color: .black))
//        let image = EKProperty.ImageContent(image: UIImage(named: "call-recieve")!, size: CGSize(width: 35, height: 35))
//        let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
//        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
//
//        let contentView = EKNotificationMessageView(with: notificationMessage)
//        SwiftEntryKit.display(entry: contentView, using: attributes)
        
    }
}
