//
//  CallSetupController.swift
//  NxtBase
//
//  Created by mac on 12/04/2020.
//  Copyright © 2020 Private. All rights reserved.
//

import UIKit
/*
class CallSetupController: UIViewController {
    
    
    //MARK:- Outlets
   
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
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUI()
    }
    
    // MARK: - Custom
    func addVideoViews() {
        remoteVideoViewContainter = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSizeUtil.width(), height: ScreenSizeUtil.height()))
        remoteVideoViewContainter.backgroundColor = .white
        self.view.addSubview(remoteVideoViewContainter)
        
        let remoteVideoView = WebRTCClient.sharedInstance.remoteVideoView()
        WebRTCClient.sharedInstance.setupRemoteViewFrame(frame: CGRect(x: 0, y: 0, width: ScreenSizeUtil.width()*0.7, height: ScreenSizeUtil.height()))
        remoteVideoView.center = remoteVideoViewContainter.center
        remoteVideoViewContainter.addSubview(remoteVideoView)
        
        localVideoView = WebRTCClient.sharedInstance.localVideoView()
        WebRTCClient.sharedInstance.setupLocalViewFrame(frame: CGRect(x: 0, y: 0, width: ScreenSizeUtil.width()/4, height: ScreenSizeUtil.height()/6))
        localVideoView.frame.origin.y = 20
        localVideoView.frame.origin.x = ScreenSizeUtil.width() - localVideoView.frame.size.width
        localVideoView.subviews.last?.isUserInteractionEnabled = true
        view.addSubview(localVideoView)
        let localVideoViewButton = UIButton(frame: CGRect(x: 0, y: 0, width: localVideoView.frame.width, height: localVideoView.frame.height))
        localVideoViewButton.backgroundColor = UIColor.clear
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
*/
