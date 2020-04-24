//
//  CallSetupController.swift
//  NxtBase
//
//  Created by mac on 12/04/2020.
//  Copyright © 2020 Private. All rights reserved.
//

import UIKit

class CallSetupController: UIViewController {
    
    
    //MARK:- Outlets
//    @IBOutlet weak var viewVideo: UIView!
//    @IBOutlet weak var callActionsStackView: UIStackView!
//    @IBOutlet weak var btnAccept: UIButton!
//    @IBOutlet weak var btnReject: UIButton!
//    @IBOutlet weak var btnSwitchCamera: UIButton!
//    @IBOutlet weak var btnSpeaker: UIButton!
//    @IBOutlet weak var btnMute: UIButton!
//    @IBOutlet weak var lblCallType: UILabel!
//    @IBOutlet weak var lblName: UILabel!
//    @IBOutlet weak var lblTimer: UILabel!
//    @IBOutlet weak var btnMinimize: UIButton!
//    @IBOutlet weak var imgLogo: UIImageView!
//    @IBOutlet weak var imgPicture: UIImageView!
//    @IBOutlet weak var optionsbtnView: UIStackView!
   
   
    @IBOutlet weak var lblTimer: UILabel!
    
    //MARK: - Properties
    var wsStatusLabel: UILabel!
    var webRTCStatusLabel: UILabel!
    var webRTCMessageLabel: UILabel!
    var likeImage: UIImage!
    var likeImageViewRect: CGRect!
    
    var callButton = UIButton()
    var hangupButton = UIButton()
    var remoteVideoViewContainter = UIView()
    var localVideoView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    
    // MARK: - Custom
    func addVideoViews() {
//        viewVideo = WebRTCClient.sharedInstance.remoteVideoView()
//        print("localllllllll \(WebRTCClient.sharedInstance.localVideoView())")
//        print("Liveeeeeeeeee \(WebRTCClient.sharedInstance.remoteVideoView())")
        remoteVideoViewContainter = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSizeUtil.width(), height: ScreenSizeUtil.height()))
        remoteVideoViewContainter.backgroundColor = .gray
        self.view.addSubview(remoteVideoViewContainter)
        
        let remoteVideoView = WebRTCClient.sharedInstance.remoteVideoView()
        WebRTCClient.sharedInstance.setupRemoteViewFrame(frame: CGRect(x: 0, y: 0, width: ScreenSizeUtil.width()*0.7, height: ScreenSizeUtil.height()))
        remoteVideoView.center = remoteVideoViewContainter.center
        remoteVideoViewContainter.addSubview(remoteVideoView)
        
        localVideoView = WebRTCClient.sharedInstance.localVideoView()
        WebRTCClient.sharedInstance.setupLocalViewFrame(frame: CGRect(x: 0, y: 0, width: ScreenSizeUtil.width()/4, height: ScreenSizeUtil.height()/6))
        localVideoView.frame.origin.y = 20
        localVideoView.frame.origin.x = ScreenSizeUtil.width() - localVideoView.frame.size.width
        //            localVideoView.frame.origin.x = 0
        localVideoView.subviews.last?.isUserInteractionEnabled = true
        view.addSubview(localVideoView)
//        localVideoView.isHidden = true
        
        let localVideoViewButton = UIButton(frame: CGRect(x: 0, y: 0, width: localVideoView.frame.width, height: localVideoView.frame.height))
        localVideoViewButton.backgroundColor = UIColor.clear
        //            localVideoViewButton.addTarget(self, action: #selector(self.localVideoViewTapped(_:)), for: .touchUpInside)
        localVideoView.addDraggability(withinView: self.view)
        localVideoView.addSubview(localVideoViewButton)
        view.bringSubviewToFront(localVideoView)
        view.bringSubviewToFront(remoteVideoViewContainter)
    }
    
    func setupCallAgain() {
        addVideoViews()
        remoteVideoViewContainter.isHidden = false
        localVideoView.isHidden = false
        view.bringSubviewToFront(remoteVideoViewContainter)
        view.bringSubviewToFront(localVideoView)
    }
    
    func setupUI() {
        addVideoViews()
        if CallManager.sharedInstance.isIncomingCall {
            
        } else {
            //outgoing call
            CallManager.sharedInstance.initiateCallLogic()
        }
    }
    
    //MARK:- IBActions
    @IBAction func actionAccept(_ sender: UIButton) {
        CallManager.sharedInstance.acceptCalllogic()
    }
    
    @IBAction func actionReject(_ sender: UIButton) {
        CallManager.sharedInstance.endCallLogic()
    }
    
    @IBAction func actionSwitchCamera(_ sender: UIButton) {
        CallManager.sharedInstance.switchCameraOrientation()
    }
    
    @IBAction func actionSpeaker(_ sender: UIButton) {
        CallManager.sharedInstance.toggleSpeaker()
    }
    
    @IBAction func actionMute(_ sender: UIButton) {
        CallManager.sharedInstance.toggleMute()
    }
    
}
