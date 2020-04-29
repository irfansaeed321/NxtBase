//
//  ATCallManager.swift
//  ATCallKit
//
//  Created by Dejan on 19/05/2019.
//  Copyright © 2019 agostini.tech. All rights reserved.
//

import UIKit
import CallKit
import AVFoundation
import WebRTC

class ATCallManager: NSObject {
    
    static let shared: ATCallManager = ATCallManager()
    
    public var provider: CXProvider?
    
    private override init() {
        super.init()
        self.configureProvider()
    }
    
    private func configureProvider() {
        print("configureProvider")
        let config = CXProviderConfiguration(localizedName: "Video Call")
        config.supportsVideo = true
        config.includesCallsInRecents = true
        config.iconTemplateImageData = UIImage(named: "CallKitIconApp")!.pngData()
/*
        config.ringtoneSound = "ringtone.caf"
*/
        config.supportedHandleTypes = [.emailAddress]
//        config.maximumCallGroups = 1
//        config.maximumCallsPerCallGroup = 3
        provider = CXProvider(configuration: config)
        
        provider?.setDelegate(self, queue: DispatchQueue.main)
    }
    
    public func incommingCall(from: String, delay: TimeInterval) {
        print("incommingCall")
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .emailAddress, value: from)
        let bgTaskID = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        self.provider?.reportNewIncomingCall(with: UUID(), update: update, completion: { (_) in
            self.configureAudioSession()
        })
        UIApplication.shared.endBackgroundTask(bgTaskID)
    }
    
    public func outgoingCall(from: String, connectAfter: TimeInterval,isVideo:Bool) {
        print("outgoingCall")
        let controller = CXCallController()
        let fromHandle = CXHandle(type: .emailAddress, value: from)
        let startCallAction = CXStartCallAction(call: UUID(), handle: fromHandle)
        startCallAction.isVideo = isVideo
        let startCallTransaction = CXTransaction(action: startCallAction)
        controller.request(startCallTransaction) { (error) in }
        
//        self.provider?.reportOutgoingCall(with: startCallAction.callUUID, startedConnectingAt: nil)
        
        let bgTaskID = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + connectAfter) {
            self.provider?.reportOutgoingCall(with: startCallAction.callUUID, connectedAt: nil)
            UIApplication.shared.endBackgroundTask(bgTaskID)
        }
    }
    
    func configureAudioSession() {
        let sharedSession = AVAudioSession.sharedInstance()
        do {
            try sharedSession.setCategory(AVAudioSession.Category.playAndRecord)
            try sharedSession.setMode(AVAudioSession.Mode.voiceChat)
            try sharedSession.setPreferredIOBufferDuration(TimeInterval(0.005))
            try sharedSession.setPreferredSampleRate(44100.0)
            print("---------------------------------------")
            print("voiceChat audio session")
            print("---------------------------------------")
        } catch {
            debugPrint("Failed to configure `AVAudioSession`")
        }
    }
}

extension ATCallManager: CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        print("provider did reset")
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        print("call answered \(action.uuid)")
        action.fulfill()
        self.configureAudioSession()
//        if let tabController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
//            if let vc:CallViewController = tabController.presentedViewController as? CallViewController{
                CallManager.sharedInstance.acceptCalllogic()
//            }
//        }
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        print("call ended \(action.uuid)")
        action.fulfill(withDateEnded: Date.init(timeIntervalSinceNow: NSTimeIntervalSince1970))
        provider.invalidate()
        
//        if let tabController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
//            if let vc:CallViewController = tabController.presentedViewController as? CallViewController{
//                if(vc.connectedUserId != 0){
                    CallManager.sharedInstance.endCallLogic()
//                }
//                else{
//                    vc.dismissVC {
//
//                    }
//                }
//            }
//        }
    }
    
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        print("call started \(action.uuid)")
        self.configureAudioSession()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            action.fulfill()
        }
    }
    func provider(  _ provider: CXProvider, perform action: CXSetHeldCallAction) {
        print("call held \(action.uuid)")
    }
    
    func provider( _  provider: CXProvider, timedOutPerforming action: CXAction) {
        print("call timedOutPerforming \(action.uuid)")

    }
    
    func provider(  _ provider: CXProvider, perform action: CXPlayDTMFCallAction) {
        print("call CXPlayDTMFCallAction \(action.uuid)")

    }
    
    func provider(  _ provider: CXProvider, perform action: CXSetGroupCallAction) {
        print("call CXSetGroupCallAction \(action.uuid)")

    }
    
    func provider(  _ provider: CXProvider, perform action: CXSetMutedCallAction) {
        print("call CXSetMutedCallAction \(action.uuid)")
//        if let tabController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
//            if let vc:CallSetupController = tabController.presentedViewController as? CallViewController{
//                CallManager.sharedInstance.isAudioMute = action.isMuted
//                vc.mutecallbtn.sendActions(for: .touchUpInside)
//            }
//        }
    }
    
    internal func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        print("--------------------------------")
        print("didActivate audioSession")
        RTCAudioSession.sharedInstance().audioSessionDidActivate(audioSession)
        RTCAudioSession.sharedInstance().isAudioEnabled = true
    }
    
    internal func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        print("--------------------------------")
        print("didDeactivate audioSession")
        RTCAudioSession.sharedInstance().audioSessionDidDeactivate(audioSession)
        RTCAudioSession.sharedInstance().isAudioEnabled = false
    }
}

