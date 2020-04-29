//
//  CallManager.swift
//  kalam
//
//  Created by apple on 3/17/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit
import Starscream
import WebRTC
import UIKit
import CallKit
//import SwiftySound
//import Reachability

class CallManager:NSObject  {
    
    static let sharedInstance = CallManager()

    //MARK: - Properties
    
//    let reachability = try! Reachability()
    var iceArray:[RTCIceCandidate]? = []
    var callscreen:CallViewController
//    var socket: WebSocket!
//    var tryToConnectWebSocket: Timer!
    var cameraSession: CameraSession?
    
    // You can create video source from CMSampleBuffer :)
    var useCustomCapturer: Bool = true
    var cameraFilter: CameraFilter?
    
    // Constants
//    let wsStatusMessageBase = "WebSocket: "
//    let webRTCStatusMesasgeBase = "WebRTC: "
//    let likeStr: String = "Like"
    
    var counter = 0
    var timer = Timer()
    var callcounter = 0
    var calltimer = Timer()

    var isIncomingCall = false
    var isCallHandled = false
    var isCallConnected = false

    var callIdGlobal = ""
    var connectedUserId:Int = 0
    var incomingCallUserId:Int = 0
    var connectedUserName = ""
    var connectedUserPhoto = ""
    var connectedUserPhone = ""

    var showHelpingLabel = false

    var isSpeakerEnabled = false
    var isAudioMute = false
    var isFrontCamera = false
    var headphonesConnected = false
    
    var isVideoEnabled = false
//    let audioSession = AVAudioSession.sharedInstance()
    var audioPlayer: AVAudioPlayer?
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    // MARK: - callmanager init methods

    override init() {
        callscreen = storyboard.instantiateViewController(withIdentifier: CallViewController.className) as! CallViewController
        callscreen.modalPresentationStyle = .overFullScreen
    }
    deinit {
//        reachability.stopNotifier()
    }

    func minimiserCall()  {
        
        print("minimiserCall")
        CallMinimiser.sharedInstance.showCallBar(name: connectedUserName )
        callscreen.dismiss(animated: true) {}
    
    }
    func maximiseCall()  {
        print("maximiseCall")
        CallMinimiser.sharedInstance.hideCallBar()
        if callscreen == nil {
            callscreen = storyboard.instantiateViewController(withIdentifier: CallViewController.className) as! CallViewController
            callscreen.modalPresentationStyle = .overFullScreen
        }
//        if let tabController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
//            tabController.presentVC(callscreen)
//        }
        callscreen.setupCallAgain()
    }

    func playCallTone(){
        print("playCallTone")
        do {
            _ = Bundle.main.path(forResource: "dial_tone", ofType: "mp3")
            
            if Bundle.main.path(forResource: "dial_tone", ofType: "mp3") != nil {
                print("Continue processing")
            } else {
                print("Error: No file with specified name exists")
            }
            
            do {
                if let fileURL = Bundle.main.path(forResource: "dial_tone", ofType: "mp3") {
                    self.audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL))
                    self.audioPlayer?.prepareToPlay()
                    self.audioPlayer?.volume = 1.0
                    self.audioPlayer?.numberOfLoops = -1
                    self.audioPlayer?.play()
                } else {
                    print("No file with specified name exists")
                }
            } catch let error {
                print("Can't play the audio file failed with an error \(error.localizedDescription)")
            }
            
            
            self.audioPlayer?.play()
        }
        
    }
    func stopAudioPlayer(){
        print("stopAudioPlayer")

        if audioPlayer != nil {
            if audioPlayer!.isPlaying {
                audioPlayer?.stop()
                audioPlayer = nil
            }
        }
        
    }
    
    
    func switchAudiotoVideo(){
        /*
        if (isVideoEnabled) {
            isVideoEnabled = false
            
        }else{
            isVideoEnabled = true
            addVideoViews()
        }
        */
    }
    func switchCameraOrientation(){
        if (isVideoEnabled) {
            if isFrontCamera {
                isFrontCamera = false

            }else
            {
                isFrontCamera = true
            }
            self.cameraSession?.swapCamera()

        }

    }

    func toggleMute(){
        if(isAudioMute == false){
            isAudioMute = true
            WebRTCClient.sharedInstance.localAudioTrack.isEnabled = isAudioMute
            callscreen.mutecallbtn.setImage(UIImage(named: "callmute"), for: .normal)
            
        }else{
            isAudioMute = false
            WebRTCClient.sharedInstance.localAudioTrack.isEnabled = isAudioMute
            callscreen.mutecallbtn.setImage(UIImage(named: "callunmute"), for: .normal)
            
        }

    }
    func toggleSpeaker(){
        if (isSpeakerEnabled){
            switchToEarPieceAudio()
        }else{
            switchToSpeakerAudio()
        }

    }

    //MARK: - helper functions
    
    func setupAudioRouteNotifications() {
        // Get the default notification center instance.
        let nc = NotificationCenter.default
        nc.addObserver(self,
                       selector: #selector(handleRouteChange),
                       name: AVAudioSession.routeChangeNotification,
                       object: nil)
    }

    @objc func handleRouteChange(notification: Notification) {

        print("============================================================================")
        print(notification.userInfo as Any)
        guard let userInfo = notification.userInfo,
            let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
            let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else {
                return
        }

        // Switch over the route change reason.
        switch reason {

        case .newDeviceAvailable: // New device found.
            let session = AVAudioSession.sharedInstance()
            headphonesConnected = hasHeadphones(in: session.currentRoute)

        case .oldDeviceUnavailable: // Old device removed.
            if let previousRoute =
                userInfo[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription {
                headphonesConnected = hasHeadphones(in: previousRoute)
            }

        default: ()
        }
        
        print("===================================")
        print(headphonesConnected)
    }
    func hasHeadphones(in routeDescription: AVAudioSessionRouteDescription) -> Bool {
        // Filter the outputs to only those with a port type of headphones.
        return !routeDescription.outputs.filter({$0.portType == .headphones}).isEmpty
    }
    func bluetoothAudioConnected() -> Bool{
      let outputs = AVAudioSession.sharedInstance().currentRoute.outputs
      for output in outputs{
        if output.portType == AVAudioSession.Port.bluetoothA2DP || output.portType == AVAudioSession.Port.bluetoothHFP || output.portType == AVAudioSession.Port.bluetoothLE{
          return true
        }
      }
      return false
    }
    // called every time interval from the timer
    @objc func timerAction() {
        counter += 1
        callscreen.calltimerlabel.text = "\(seconds2Timestamp(intSeconds: counter))"
        CallMinimiser.sharedInstance.updateTimerLabeltext(time: callscreen.calltimerlabel.text ?? "00:00")
    }
    func seconds2Timestamp(intSeconds:Int)->String {
        let mins:Int = intSeconds/60
        let hours:Int = mins/60
        let secs:Int = intSeconds%60
        
        let strTimestamp:String = ((hours<10) ? "0" : "") + String(hours) + ":" + ((mins<10) ? "0" : "") + String(mins) + ":" + ((secs<10) ? "0" : "") + String(secs)
        return strTimestamp
    }

    func isHeadphonesConnected() -> Bool{
        //        let routes = AVAudioSession.sharedInstance().currentRoute
        //        return routes.outputs.contains(where: { (port) -> Bool in
        //            port.portType == AVAudioSession.Port.headphones
        //        })
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            return false; /* Device is iPad */
        }
        else
        {
            return true
        }
        
    }
    public func switchToEarPieceAudio(){
        
        let sharedSession = AVAudioSession.sharedInstance()
        do {
            
            try sharedSession.setCategory(AVAudioSession.Category.playAndRecord,options: [ .allowBluetooth, .allowBluetoothA2DP])
            try sharedSession.setMode(AVAudioSession.Mode.voiceChat)
            try sharedSession.setPreferredIOBufferDuration(TimeInterval(0.005))
            try sharedSession.setPreferredSampleRate(44100.0)
            try sharedSession.overrideOutputAudioPort(AVAudioSession.PortOverride.none)
            try sharedSession.setActive(true)
            isSpeakerEnabled = false
            callscreen.speakerBtn.setImage(UIImage(named: "callspeaker-on"), for: .normal)
            print("-------------------------------------------")
            print("EAR PIECE")
            print("-------------------------------------------")
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
    }
    public func switchToSpeakerAudio() {
        
        let sharedSession = AVAudioSession.sharedInstance()
        do {
            try sharedSession.setCategory(AVAudioSession.Category.playAndRecord,options: [ .allowBluetooth, .allowBluetoothA2DP])
            try sharedSession.setMode(AVAudioSession.Mode.voiceChat)
            try sharedSession.setPreferredIOBufferDuration(TimeInterval(0.005))
            try sharedSession.setPreferredSampleRate(44100.0)
            try sharedSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            try sharedSession.setActive(true)
            isSpeakerEnabled = true
            callscreen.speakerBtn.setImage(UIImage(named: "callspeaker-off"), for: .normal)
            print("-------------------------------------------")
            print("SPEAKER")
            print("-------------------------------------------")
            
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
    }
    func initiateCallLogic(){
        if !WebRTCClient.sharedInstance.isConnected {
            self.sendNewCallEvent()
            callscreen.calltimerlabel.text = "Calling"
            //            callcounter = 0
            //            calltimer.invalidate() // just in case this button is tapped multiple times
            //            calltimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(calltimerAction), userInfo: nil, repeats: true)
            
        }
        
    }
    
    func endCallLogic() {
        if(SocketIOManager.sharedInstance.manager?.status == .connected){
            var dic = [String:String]()
            dic["type"] = "reject"
            dic["callId"] = self.callIdGlobal
//            if WebRTCClient.sharedInstance.isConnected {
//                dic["connectedUserId"] = self.connectedUserId.description
//                print("REJECT SENT to connected user")
//
//            }else{
                dic["connectedUserId"] = self.incomingCallUserId.description
                print("REJECT SENT to incoming user")
//            }
            print("\(dic)")
            SocketIOManager.sharedInstance.sendReject(dictionary: dic)
        }
        
        #if targetEnvironment(simulator)
        // we're on the simulator - calculate pretend movement
        #else
        ATCallManager.shared.provider?.invalidate()
        #endif
        if  UIApplication.shared.topMostViewController() is CallViewController {
            callscreen.dismissVC(completion: nil)
        }
        
        CallMinimiser.sharedInstance.hideCallBar()
        stopWebrtc()
    }
    func resetManager(){
        
        WebRTCClient.sharedInstance.closePeerConnection()
        iceArray?.removeAll()
        counter = 0
        callcounter = 0
        isIncomingCall = false
        isCallHandled = false
        callIdGlobal = ""
        connectedUserId = 0
        incomingCallUserId = 0
        connectedUserName = ""
        connectedUserPhoto = ""
        connectedUserPhone = ""
        showHelpingLabel = false
        isSpeakerEnabled = false
        isAudioMute = false
        isFrontCamera = false
        headphonesConnected = false
        isVideoEnabled = false
        isCallConnected = false
        cameraSession = nil
        useCustomCapturer = true
        cameraFilter = nil
        timer.invalidate()
        calltimer.invalidate()
        audioPlayer = nil
        NotificationCenter.default.post(name: NSNotification.Name("update"), object: nil, userInfo: nil)
    }
    
//    @objc func calltimerAction() {
//        print("calltimerAction")
//        callcounter += 1
//        if callcounter == 20 {
//            print("calltimerAction ENDED")
//            calltimer.invalidate()
//            callscreen.calltimerlabel.text = "No answer"
//            callscreen.cancelBtn.isHidden = false
//            callscreen.callagainBtn.isHidden = false
//            callscreen.endcallbtn.isHidden = true
//            callscreen.acceptcallbtn.isHidden = true
//            callscreen.endcallbtn.sendActions(for: .touchUpInside)
//        }
//    }
    
    func sendNewCallEvent(){
        
        if(SocketIOManager.sharedInstance.manager?.status == .connected){
            var dic = [String:Any]()
            dic["type"] = "newcall"
            dic["isVideo"] = true
            dic["connectedUserId"] = self.incomingCallUserId.description
            SocketIOManager.sharedInstance.sendNewCall(dictionary: dic)
        }
    }
    
    
    func acceptCalllogic(){
        self.connectedUserId = self.incomingCallUserId
        WebRTCClient.sharedInstance.makeAnswer(onCreateAnswer: {(answerSDP: RTCSessionDescription) -> Void in
            self.sendSDP(sessionDescription: answerSDP, conUID: self.connectedUserId,callId: self.callIdGlobal)
        })
        callscreen.acceptcallbtn.isHidden = true
//        callscreen.endcallbtn.center.x = callscreen.view.center.x
    }
    
    
    //MARK: - view methods
    
     func startWebrtc() {
        #if targetEnvironment(simulator)
        // simulator does not have camera
        self.useCustomCapturer = false
        #endif
        SocketIOManager.sharedInstance.delegate = self
        WebRTCClient.sharedInstance.delegate = self
        WebRTCClient.sharedInstance.setup(videoTrack: true, audioTrack: true, dataChannel: true, customFrameCapturer: useCustomCapturer)
        
        if useCustomCapturer {
            print("--- use custom capturer ---")
            self.cameraSession = CameraSession()
            self.cameraSession?.delegate = self
            self.cameraSession?.setupSession()
            self.cameraFilter = CameraFilter()
        }
        setupAudioRouteNotifications()
    }
    
    func showCallScreen() {
//        if let tabController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
//            tabController.presentVC(callscreen)
//        }
        
         callscreen = storyboard.instantiateViewController(withIdentifier: CallViewController.className) as! CallViewController
               callscreen.modalPresentationStyle = .overFullScreen
        UIApplication.shared.keyWindow?.rootViewController?.presentVC(callscreen)
        
        callscreen.setupUI()
    }
    
    func stopWebrtc() {
        callscreen.remoteVideoViewContainter.removeFromSuperview()
        callscreen.localVideoView.removeFromSuperview()

        if WebRTCClient.sharedInstance.isConnected {
            WebRTCClient.sharedInstance.disconnect()
        }
//        Sound.stopAll()
        self.stopAudioPlayer()
        resetManager()
        
    }
    
    // MARK: - WebRTC Signaling
    private func sendSDP(sessionDescription: RTCSessionDescription,conUID:Int,callId:String){
        var type = ""
        if sessionDescription.type == .offer {
            type = "offer"
        } else if sessionDescription.type == .answer {
            type = "answer"
            
        }
        
        let sdp = SDP.init(sdp: sessionDescription.sdp)
        let signalingMessage = SignalingMessage.init(type: type, offer: sdp, candidate: nil,phone: "",photoUrl:"",name: "",connectedUserId: conUID,isVideo: isVideoEnabled,callId: callId)
        do {
            let data = try JSONEncoder().encode(signalingMessage)
            let message = String(data: data, encoding: String.Encoding.utf8)!
            SocketIOManager.sharedInstance.sendSDP(dictionary: message.convertToDictionary() ?? [:])
        }catch{
            print(error)
        }
    }
    
    private func sendCandidate(iceCandidate: RTCIceCandidate,conUID:Int){
        
        let candidate = Candidate.init(sdp: iceCandidate.sdp, sdpMLineIndex: iceCandidate.sdpMLineIndex, sdpMid: iceCandidate.sdpMid!)
        let signalingMessage = SignalingMessage.init(type: "candidate", offer: nil, candidate: candidate,phone: "",photoUrl:"",name: "",connectedUserId: conUID,isVideo: isVideoEnabled,callId: "")
        
        do {
            let data = try JSONEncoder().encode(signalingMessage)
            let message = String(data: data, encoding: String.Encoding.utf8)!
            SocketIOManager.sharedInstance.sendCandidates(dictionary: message.convertToDictionary() ?? [:])
        } catch {
            print(error)
        }
    }
}

// MARK: - Socket IO Delegate

extension CallManager :SocketDelegate{
    func didReceiveNewMessage(data: ChatsData) {
        
    }
    
    func didReceiveActiveStatus(data: [Any]) {
        
    }
    
    func didReceiveOfflineStatus(data: [String : Any]) {
        
    }
    
    func didReceiveChatId(data: [Any]) {
        
    }
    
    func didReceiveFriendRequestAck(data: Any) {
        
    }
    
    func didReceiveDeleteChatsAck(data: [String : Any]) {
        
    }
    
    func didReceivePrivacySettingAck(data: [String : Any]) {
        
    }
    
    func didReceivePrivacySetting(data: [String : Any]) {
        
    }
    
    
    func didReceiveForwardMessageAck(data: Any) {
        
    }
    
    func didSocketConnected(data: [Any]) {
        print("-- websocket did connect --")
        
        if(isCallConnected == true){
//            WebRTCClient.sharedInstance.connectWitoutOffer()
            for candidate in self.iceArray!{
                self.sendCandidate(iceCandidate: candidate, conUID: self.connectedUserId)
            }

            
//            WebRTCClient.sharedInstance.connect(reconnect: true ,onSuccess: { (offerSDP: RTCSessionDescription) -> Void in
//                self.sendSDP(sessionDescription: offerSDP, conUID: (self.connectedUserId),callId: self.callIdGlobal)
//            })
            

            
        }
    }
    
    func didSocketDisConnected(data: [Any]) {
        print("-- websocket did disconnect --")
//        if(showHelpingLabel){
//            wsStatusLabel.text = wsStatusMessageBase + "disconnected"
//            wsStatusLabel.textColor = .red
//        }

    }
    
    func didReceiveStartTypingEvent(data: [String : Any]) {
        
    }
    
    func didReceiveStopTypingEvent(data: [String : Any]) {
        
    }
    
    func didReceiveStartChatEvent(data: [String : Any]) {
        
    }
    
    func didReceiveMessageStatus(data: [String : Any]) {
        
    }
    
    func didReceiveMessagesDelivered(data: [String : Any]) {
        
    }
    
    func didReceiveAllMessagesRead(data: [String : Any]) {
        
    }
    
    func didReceiveSeenMessage(data: [String : Any]) {
        
    }
    
    func didReceiveOnlinestatus(data: [String : Any]) {
        
    }
    
    func didReceiveOnlinestatusAck(data: [String : Any]) {
        
    }
    
    func didReceiveOnlinestatusAllUserAck(data: [[String : Any]]) {
        
    }
    
    func didReceiveNickName(data: [String : Any]) {
        
    }
    
    func didReceiveLiveLocation(data: [String : Any]) {
        
    }
    
    func didReceivemessageDeleted(data: [String : Any]) {
        
    }
    
    func didReceivemessageDeleteAck(data: [String : Any]) {
        
    }
    
    func didReceiveEditMessageAck(data: [String : Any]) {
        
    }
    
    func didReceiveReject(data: [String : Any]) {
        print("-----------------------reject received--------\(data)---------------------------")
        #if targetEnvironment(simulator)
        // we're on the simulator - calculate pretend movement
        #else
        ATCallManager.shared.provider?.invalidate()
        //        ATCallManager.shared.provider?.reportCall(with: <#T##UUID#>, endedAt: <#T##Date?#>, reason: <#T##CXCallEndedReason#>)
        #endif
        if  UIApplication.shared.topMostViewController() is CallViewController {
            callscreen.dismissVC(completion: nil)
        }
        CallMinimiser.sharedInstance.hideCallBar()
        stopWebrtc()
        
    }
    
    func didReceiveOffer(data: SignalingMessage) {
        print("-----------------------offer received---------------\(data)--------------------")
        let offersdp = RTCSessionDescription(type: .offer, sdp: (data.offer?.sdp)!)
        WebRTCClient.sharedInstance.receiveOffer(offerSDP: offersdp)
//        callscreen.calltimerlabel.text = ""
        self.incomingCallUserId = data.connectedUserId ?? 0
        self.callIdGlobal = data.callId ?? ""
        RTCAudioSession.sharedInstance().useManualAudio = true
        self.isVideoEnabled = data.isVideo ?? false
        self.connectedUserName = data.name!
        self.connectedUserPhoto = data.photoUrl!
        showCallScreen()
    }
    
    func sendReadyforcallEvent(available:Available){
        if SocketIOManager.sharedInstance.manager?.status == .connected {
            var dic = [String:String]()
            dic["type"] = "readyforcall"
            dic["connectedUserId"] = available.connectedUserId?.description
            SocketIOManager.sharedInstance.sendReadyForCall(dictionary: dic)
        }
    }
    
    func didReceiveAvailable(data: Available) {
        print("new call received---------\(data)-----")
        self.sendReadyforcallEvent(available: data)
    }
    
    func didReceiveReadyforcall(data: Available) {
        callscreen.calltimerlabel.text = "Ringing"
        WebRTCClient.sharedInstance.connect { (RTCSessionDescription) in
            self.sendSDP(sessionDescription: RTCSessionDescription, conUID: data.connectedUserId!, callId: "")
        }
        if (isHeadphonesConnected()) {
            switchToEarPieceAudio()
        } else {
            switchToSpeakerAudio()
        }
        playCallTone()
    }
    
    func didReceiveAnswer(data: SignalingMessage) {
        //        calltimer.invalidate()
        print("-----------------------didReceiveAnswer---------------\(data)--------------------")
        print(data.type)
        self.connectedUserId = data.connectedUserId ?? 0
        self.callIdGlobal = data.callId ?? ""
//        Sound.stopAll()
        self.stopAudioPlayer()
        WebRTCClient.sharedInstance.receiveAnswer(answerSDP: RTCSessionDescription(type: .answer, sdp: (data.offer?.sdp)!))
        #if targetEnvironment(simulator)
            // we're on the simulator - calculate pretend movement
        #else
            ATCallManager.shared.outgoingCall(from: data.name ?? "", connectAfter: 0, isVideo: data.isVideo ?? false)
        #endif

        
        
    }
    func didReceiveCandidate(data: SignalingMessage) {
        print("-----------------------didReceiveCandidate-------------------\(data)----------------")
//        print(data.type)
        
        let candidate = data.candidate!
        WebRTCClient.sharedInstance.receiveCandidate(candidate: RTCIceCandidate(sdp: candidate.sdp, sdpMLineIndex: candidate.sdpMLineIndex, sdpMid: candidate.sdpMid))
        
    }
    func didReceiveData(_ data: Data) {
        let str = String(decoding: data, as: UTF8.self)
        print("socket received data = " + str)
        
    }
}



// MARK: - WebRTCClient Delegate
extension CallManager :WebRTCClientDelegate{
    func didGenerateCandidate(iceCandidate: RTCIceCandidate) {
        print("----------------------------------------------------------")
        print("didGenerateCandidate")
        iceArray?.append(iceCandidate)
        print("ice array\(iceArray as Any)")
        self.sendCandidate(iceCandidate: iceCandidate, conUID: self.incomingCallUserId)
    }
    
    func didIceConnectionStateChanged(iceConnectionState: RTCIceConnectionState) {
        var state = ""
        
        switch iceConnectionState {
        case .checking:
            state = "connecting..."
            callscreen.calltimerlabel.text = state

        case .closed:
            state = "closed"
            callscreen.calltimerlabel.text = state

        case .completed:
            state = "completed"
            callscreen.calltimerlabel.text = state

        case .connected:
            state = "connected"
            isCallConnected = true
            callscreen.calltimerlabel.text = state

            self.stopAudioPlayer()
//            Sound.stopAll()
            timer.invalidate() // just in case this button is tapped multiple times
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            isAudioMute = false
            callscreen.endcallbtn.isHidden = false
            callscreen.speakerBtn.isHidden = false
            callscreen.mutecallbtn.isHidden = false
//            callscreen.videoswitcBtn.isHidden = true
            callscreen.optionsbtnView.isHidden = false
            callscreen.callActionsStackView.isHidden = false
            callscreen.minimiseBtn.isHidden = false

            if self.isVideoEnabled {
                callscreen.remoteVideoViewContainter.isHidden = false
                callscreen.localVideoView.isHidden = false
                callscreen.cameraSwitchBtn.isHidden = false

                callscreen.view.bringSubviewToFront(callscreen.remoteVideoViewContainter)
                callscreen.view.bringSubviewToFront(callscreen.localVideoView)
                callscreen.view.bringSubviewToFront(callscreen.optionsbtnView)
                callscreen.view.bringSubviewToFront(callscreen.callActionsStackView)
                callscreen.view.bringSubviewToFront(callscreen.endcallbtn)
                callscreen.view.bringSubviewToFront(callscreen.mutecallbtn)
                callscreen.view.bringSubviewToFront(callscreen.speakerBtn)
                callscreen.view.bringSubviewToFront(callscreen.cameraSwitchBtn)
                callscreen.view.bringSubviewToFront(callscreen.minimiseBtn)
            } else {
                callscreen.cameraSwitchBtn.isHidden = true
                callscreen.view.bringSubviewToFront(callscreen.optionsbtnView)
                callscreen.view.bringSubviewToFront(callscreen.callActionsStackView)
                callscreen.view.bringSubviewToFront(callscreen.endcallbtn)
                callscreen.view.bringSubviewToFront(callscreen.mutecallbtn)
                callscreen.view.bringSubviewToFront(callscreen.speakerBtn)
                callscreen.view.bringSubviewToFront(callscreen.minimiseBtn)
            }
            if (isHeadphonesConnected()) {
                if self.isVideoEnabled {
                    switchToEarPieceAudio()
                    switchToSpeakerAudio()
                } else {
                    switchToSpeakerAudio()
                    switchToEarPieceAudio()
                }
            } else {
                switchToEarPieceAudio()
                switchToSpeakerAudio()
            }
        case .count:
            state = "count..."
        case .disconnected:
            state = "disconnected"
            callscreen.calltimerlabel.text = "reconnecting..."
            timer.invalidate()
//            startReachibility()

        case .failed:
            state = "failed"
            callscreen.calltimerlabel.text = state
            if(isIncomingCall){
                endCallLogic()
            }else{
                ATCallManager.shared.provider?.invalidate()
                if  UIApplication.shared.topMostViewController() is CallViewController {
                    callscreen.dismissVC(completion: nil)
                }
                CallMinimiser.sharedInstance.hideCallBar()
                stopWebrtc()

            }

        case .new:
            state = "new..."
        }
        print("WEBRTC STATE = \(state)")
//        if showHelpingLabel {
//            self.webRTCStatusLabel.text = self.webRTCStatusMesasgeBase + state
//        }
        
    }
    
    func didConnectWebRTC() {
        print("----------------------------")
        print("didConnectWebRTC")
        

    }
    
    func didDisconnectWebRTC() {
        print("----------------------------")
        print("didDisconnectWebRTC")
    }
    
    func didOpenDataChannel() {
        print("did open data channel")
    }
    
    func didReceiveData(data: Data) {
//        if data == likeStr.data(using: String.Encoding.utf8) {
//            self.startLikeAnimation()
//        }
    }
    
    func didReceiveMessage(message: String) {
        callscreen.webRTCMessageLabel.text = message
    }
}

// MARK: - CameraSessionDelegate
extension CallManager :CameraSessionDelegate{
    func didOutput(_ sampleBuffer: CMSampleBuffer) {
        if self.useCustomCapturer {
            if let cvpixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer){
                if let buffer = self.cameraFilter?.apply(cvpixelBuffer){
                    WebRTCClient.sharedInstance.captureCurrentFrame(sampleBuffer: buffer)
                }else{
                    print("no applied image")
                }
            }else{
                print("no pixelbuffer")
            }
            //            self.webRTCClient.captureCurrentFrame(sampleBuffer: buffer)
        }
    }
}
