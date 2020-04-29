//
//  CallViewController.swift
//  SimpleWebRTC
//
//  Created by n0 on 2019/01/05.
//  Copyright © 2019年 n0. All rights reserved.
//

import UIKit
import Starscream
import WebRTC
import UIKit
import CallKit

class CallViewController: UIViewController {
    
    //MARK: - Iboutlets
    
    @IBOutlet weak var callActionsStackView: UIStackView!
    @IBOutlet weak var minimiseBtn: UIButton!
    @IBOutlet weak var optionsbtnView: UIView!
//    @IBOutlet weak var cancelBtn: UIButton!
//    @IBOutlet weak var callagainBtn: UIButton!
//    @IBOutlet weak var callbtn: UIButton!
//    @IBOutlet weak var speakercallbtn: UIButton!
//    @IBOutlet weak var msgcallbtn: UIButton!
//    @IBOutlet weak var holdcallbtn: UIButton!
    @IBOutlet weak var mutecallbtn: UIButton!
    @IBOutlet weak var endcallbtn: UIButton!
    @IBOutlet weak var acceptcallbtn: UIButton!
    @IBOutlet weak var callerImage: UIImageView!{
        didSet {
            callerImage.circularView()
        }
    }
//    @IBOutlet weak var videoswitcBtn: UIButton!
    @IBOutlet weak var calltypelabel: UILabel!
    @IBOutlet weak var calltimerlabel: UILabel!
    @IBOutlet weak var callername: UILabel!
    @IBOutlet weak var speakerBtn: UIButton!
    @IBOutlet weak var cameraSwitchBtn: UIButton!
    
    //MARK: - Properties
    
    // UI
    var wsStatusLabel: UILabel!
    var webRTCStatusLabel: UILabel!
    var webRTCMessageLabel: UILabel!
    var likeImage: UIImage!
    var likeImageViewRect: CGRect!
    
    var callButton = UIButton()
    var hangupButton = UIButton()
    var remoteVideoViewContainter = UIView()
    var localVideoView = UIView()
    
    
    
    @IBAction func callMinimise(_ sender: UIButton) {
        CallManager.sharedInstance.minimiserCall()
    }
    @IBAction func switchVideoAudioTapped(_ sender: UIButton) {
        CallManager.sharedInstance.switchAudiotoVideo()
    }
    @IBAction func cameraBtnTapped(_ sender: UIButton) {
        CallManager.sharedInstance.switchCameraOrientation()
    }
    @IBAction func muteTapped(_ sender: UIButton) {
        CallManager.sharedInstance.toggleMute()
    }
    @IBAction func speakerToggleTapped(_ sender: UIButton) {
        CallManager.sharedInstance.toggleSpeaker()
    }
    @IBAction func acceptcalltapped(_ sender: Any) {
        CallManager.sharedInstance.acceptCalllogic()
    }
    @IBAction func endcallTapped(_ sender: Any) {
        CallManager.sharedInstance.endCallLogic()
    }
    //MARK: - view methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
   
    override func viewDidDisappear(_ animated: Bool) {
  
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UI
    func addVideoViews(){
        remoteVideoViewContainter = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSizeUtil.width(), height: ScreenSizeUtil.height()))
        remoteVideoViewContainter.backgroundColor = .gray
        self.view.addSubview(remoteVideoViewContainter)
        
        let remoteVideoView = WebRTCClient.sharedInstance.remoteVideoView()
        WebRTCClient.sharedInstance.setupRemoteViewFrame(frame: CGRect(x: 0, y: 0, width: ScreenSizeUtil.width()*0.7, height: ScreenSizeUtil.height()))
        remoteVideoView.center = remoteVideoViewContainter.center
        remoteVideoViewContainter.addSubview(remoteVideoView)
        remoteVideoViewContainter.isHidden = true
        
        localVideoView = WebRTCClient.sharedInstance.localVideoView()
        WebRTCClient.sharedInstance.setupLocalViewFrame(frame: CGRect(x: 0, y: 0, width: ScreenSizeUtil.width()/4, height: ScreenSizeUtil.height()/6))
        localVideoView.frame.origin.y = 20
        localVideoView.frame.origin.x = ScreenSizeUtil.width() - localVideoView.frame.size.width
        //            localVideoView.frame.origin.x = 0
        localVideoView.subviews.last?.isUserInteractionEnabled = true
        self.view.addSubview(localVideoView)
        localVideoView.isHidden = true
        
        let localVideoViewButton = UIButton(frame: CGRect(x: 0, y: 0, width: localVideoView.frame.width, height: localVideoView.frame.height))
        localVideoViewButton.backgroundColor = UIColor.clear
        //            localVideoViewButton.addTarget(self, action: #selector(self.localVideoViewTapped(_:)), for: .touchUpInside)
        localVideoView.addDraggability(withinView: self.view)
        localVideoView.addSubview(localVideoViewButton)
        
        self.view.bringSubviewToFront(remoteVideoViewContainter)
        self.view.bringSubviewToFront(localVideoView)
    }
    
    func setupCallAgain(){
        
        endcallbtn.isHidden = false
        speakerBtn.isHidden = false
        minimiseBtn.isHidden = false
        mutecallbtn.isHidden = false
//        videoswitcBtn.isHidden = true
        optionsbtnView.isHidden = false
        callActionsStackView.isHidden = false
        
        if(CallManager.sharedInstance.isAudioMute == false) {
            mutecallbtn.setImage(UIImage(named: "callunmute"), for: .normal)
        } else {
            mutecallbtn.setImage(UIImage(named: "callmute"), for: .normal)
        }
        if (CallManager.sharedInstance.isSpeakerEnabled){
            speakerBtn.setImage(UIImage(named: "callspeaker-off"), for: .normal)
        } else {
            speakerBtn.setImage(UIImage(named: "callspeaker-on"), for: .normal)
        }
        
        if CallManager.sharedInstance.isVideoEnabled {
            
            addVideoViews()
            
            remoteVideoViewContainter.isHidden = false
            localVideoView.isHidden = false
            cameraSwitchBtn.isHidden = false
            
            
            view.bringSubviewToFront(remoteVideoViewContainter)
            view.bringSubviewToFront(localVideoView)
            view.bringSubviewToFront(optionsbtnView)
            view.bringSubviewToFront(callActionsStackView)
            view.bringSubviewToFront(endcallbtn)
            view.bringSubviewToFront(mutecallbtn)
            view.bringSubviewToFront(speakerBtn)
            view.bringSubviewToFront(cameraSwitchBtn)
            view.bringSubviewToFront(minimiseBtn)
            //                self.view.bringSubviewToFront(self.videoswitcBtn)
            
        }else{
            remoteVideoViewContainter.isHidden = true
            localVideoView.isHidden = true
            cameraSwitchBtn.isHidden = true
            view.bringSubviewToFront(optionsbtnView)
            view.bringSubviewToFront(callActionsStackView)
            view.bringSubviewToFront(endcallbtn)
            view.bringSubviewToFront(mutecallbtn)
            view.bringSubviewToFront(speakerBtn)
            view.bringSubviewToFront(minimiseBtn)
            //                self.view.bringSubviewToFront(self.videoswitcBtn)
            
        }
    }
    
    func setupUI(){
        
        print("name = \(CallManager.sharedInstance.connectedUserName)")
        print("photo = \(CallManager.sharedInstance.connectedUserPhoto)")
        print("id = \(CallManager.sharedInstance.connectedUserId)")
        if(CallManager.sharedInstance.isVideoEnabled){
            addVideoViews()
            self.calltypelabel.text = "KalamTime video call"
        }else{
            self.calltypelabel.text = "KalamTime audio call"
        }
        calltimerlabel.text = ""
        self.callername.text = CallManager.sharedInstance.connectedUserName
//        self.callerImage.setImage(url: URL(string: CallManager.sharedInstance.connectedUserPhoto ))
        
        if CallManager.sharedInstance.isIncomingCall {
            
            //incoming
            self.acceptcallbtn.isHidden = false
            self.endcallbtn.isHidden = false
            
//            self.cancelBtn.isHidden = true
//            self.callagainBtn.isHidden = true
            
            self.mutecallbtn.isHidden = true
            self.speakerBtn.isHidden  = true
            self.cameraSwitchBtn.isHidden    = true
            
            self.optionsbtnView.isHidden = true
//            self.videoswitcBtn.isHidden = true
            self.minimiseBtn.isHidden = true
            
            
            
        }else{
            //outgoing call
            CallManager.sharedInstance.initiateCallLogic()
            self.acceptcallbtn.isHidden = true
            self.endcallbtn.isHidden = false
//            self.endcallbtn.center.x = self.view.center.x
//            self.cancelBtn.isHidden = true
//            self.callagainBtn.isHidden = true
            self.mutecallbtn.isHidden   = true
            self.speakerBtn.isHidden    = true
            self.cameraSwitchBtn.isHidden      = true
            self.optionsbtnView.isHidden = true
//            self.videoswitcBtn.isHidden = true
            self.minimiseBtn.isHidden = true
            
        }
    }
}
