//
//  SocketManager.swift
//  NxtBase
//
//  Created by mac on 04/04/2020.
//  Copyright © 2020 Private. All rights reserved.
//

import Foundation
import SocketIO


protocol SocketDelegateAppdelegate: class {
    func didSocketConnectedAppdelegate(data: [Any])
}


protocol SocketDelegate: class {
    func didSocketConnected(data: [Any])
    func didSocketDisConnected(data: [Any])
    func didReceiveActiveStatus(data: [Any])
    func didReceiveOfflineStatus(data: [String: Any])
    func didReceiveChatId(data: [Any])
    func didReceiveNewMessage(data: ChatsData)
    
    ////////////call
    func didReceiveOffer(data: SignalingMessage)
    func didReceiveAnswer(data: SignalingMessage)
    func didReceiveCandidate(data: SignalingMessage)
    func didReceiveReject(data :[String :Any])
    func didReceiveAvailable(data: Available)
    func didReceiveReadyforcall(data: Available)
}

class SocketIOManager: NSObject {
    
    static let serverUrl = Constants.URL.baseUrl
    static let sharedInstance = SocketIOManager()
    
    var socket:SocketIOClient!
    var name: String?
    var resetAck: SocketAckEmitter?
    weak var delegate: SocketDelegate?
    weak var delegateAppdelegate: SocketDelegateAppdelegate?
    var manager: SocketManager?
    
    // MARK: - socket init methods
    override init() {
        super.init()
    }
    
    func establishConnection() {
        manager = SocketManager(socketURL: URL(string: SocketIOManager.serverUrl)!, config: [.log(true), .connectParams(["token" : SharedManager.shared.user_id.description as String])])
        
        socket = manager?.defaultSocket
        addHandlers()
        manager?.forceNew = true
        manager?.reconnects = true
        manager?.reconnectWaitMax = 0
        manager?.reconnectWait = 0
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
        socket.removeAllHandlers()
        manager = nil
        socket = nil
    }
    
    // MARK: - socket listeners methods
    func addHandlers() {
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        
        socket.on(clientEvent: .disconnect) {data, ack in
            print("socket disconnected")
            self.delegate?.didSocketDisConnected(data: data)
        }
        
        socket.on(clientEvent: .error) {data, ack in
            print("error on socket")
        }
        
        socket.on(clientEvent: .reconnect) {data, ack in
            print("socket reconnected")
        }
        
        socket.on("new_active_users") { (data, ack) in
            self.delegate?.didReceiveActiveStatus(data: data)
        }
        
        socket.on("user_online_status") { (data, ack) in
            let dictionary : [String : Any] = data.first as! [String : Any]
            self.delegate?.didReceiveOfflineStatus(data: dictionary)
        }
        
        socket.on("new_message") { (data, ack) in
            let dictionary : [String : Any] = data.first as! [String : Any]
            let message = ChatsData(fromDictionary: dictionary)
            self.delegate?.didReceiveNewMessage(data: message)
        }
        
        socket.onAny {_ in
            
        }
        
        socket.on("newcall") {[weak self] data, ack in
            let dictionary : [String : Any] = data.first as! [String : Any]
            let signalingMessage = Available.init(type: dictionary["type"] as! String, connectedUserId: dictionary["connectedUserId"] as? Int, isAvailable: dictionary["isAvailable"] as? Bool, reason: dictionary["reason"] as? String, name: dictionary["name"] as? String)
            if(WebRTCClient.sharedInstance.isConnected) {
                var dic = [String:Any]()
                dic["type"] = "reject"
                dic["connectedUserId"] = signalingMessage.connectedUserId
                self?.sendReject(dictionary: dic)
            } else {
                self?.sendReadyForCallEvent(data: signalingMessage)
            }
        }
        
        socket.on("readyforcall") {[weak self] data, ack in
            let dictionary : [String : Any] = data.first as! [String : Any]
            let signalingMessage = Available.init(type: dictionary["type"] as! String, connectedUserId: dictionary["connectedUserId"] as? Int, isAvailable: dictionary["isAvailable"] as? Bool, reason: dictionary["reason"] as? String, name: dictionary["name"] as? String)
            self?.delegate?.didReceiveReadyforcall(data: signalingMessage)
        }
        
        socket.on("offer") { data, ack in
            let dictionary : [String : Any] = data.first as! [String : Any]
            let offerDic = dictionary["offer"] as! [String:Any]
            let sdp = SDP.init(sdp: offerDic["sdp"] as! String)
            print(sdp)
            let signalingMessage = SignalingMessage.init(type: dictionary["type"] as! String, offer: sdp, candidate: dictionary["candidate"] as? Candidate, phone: dictionary["phone"] as? String, photoUrl: dictionary["photoUrl"] as? String, name: dictionary["name"] as? String, connectedUserId: dictionary["connectedUserId"] as? Int, isVideo: true ,callId: "")
            
            if(CallManager.sharedInstance.isCallHandled == false) {
                #if targetEnvironment(simulator)
                // we're on the simulator - calculate pretend movement
                #else
                /////// ATCallManager.shared.incommingCall(from: signalingMessage.name!, delay: 0) ///////////////////////////////////
                #endif
            }
            CallManager.sharedInstance.isCallHandled = false
            CallManager.sharedInstance.isIncomingCall = true
            CallManager.sharedInstance.startWebrtc()
            CallManager.sharedInstance.didReceiveOffer(data: signalingMessage)
        }
        
        socket.on("answer") {[weak self] data, ack in
            let dictionary : [String : Any] = data.first as! [String : Any]
            let offerDic = dictionary["offer"] as! [String:Any]
            print(offerDic)
            let sdp = SDP.init(sdp: offerDic["sdp"] as! String)
            print(sdp)
            do {
                let signalingMessage = try SignalingMessage.init(type: dictionary["type"] as! String, offer: sdp, candidate: dictionary["candidate"] as? Candidate, phone: dictionary["phone"] as? String, photoUrl: dictionary["photoUrl"] as? String, name: dictionary["name"] as? String, connectedUserId: dictionary["connectedUserId"] as? Int, isVideo: dictionary["isVideo"] as? Bool,callId: "")
                try self?.delegate?.didReceiveAnswer(data: signalingMessage)
                
            }
            catch{
                print("crash")
            }
        }
        
        socket.on("candidate") {[weak self] data, ack in
            let dictionary : [String : Any] = data.first as! [String : Any]
            let candidate = dictionary["candidate"]  as! [String:Any]
            let candidate1 = Candidate.init(sdp: candidate["sdp"] as! String, sdpMLineIndex: candidate["sdpMLineIndex"] as! Int32, sdpMid: candidate["sdpMid"] as! String)
            
            let signalingMessage = SignalingMessage.init(type: dictionary["type"] as! String, offer: nil, candidate: candidate1, phone: dictionary["phone"] as? String, photoUrl: dictionary["photoUrl"] as? String, name: dictionary["name"] as? String, connectedUserId: dictionary["connectedUserId"] as? Int, isVideo: dictionary["isVideo"] as? Bool, callId: "")
            self?.delegate?.didReceiveCandidate(data: signalingMessage)
        }
        
        socket.on("reject") {[weak self] data, ack in
            let dictionary : [String : Any] = data.first as! [String : Any]
            self?.delegate?.didReceiveReject(data: dictionary)
        }
    }
    
    // MARK: - Socket emit methods
    func emitStartChat(dictionary:[String:Any]) {
        socket.emitWithAck("startChat", with: [SharedManager.shared.returnJsonObject(dictionary: dictionary)]).timingOut(after: 0) { (data) in
            self.delegate?.didReceiveChatId(data: data)
        }
    }
    
    func sendMessage(message: ChatsData) {
        print(message)
        var messageDic = [String: Any]()
        messageDic["message"] = message.message
        messageDic["sender_id"] = message.senderId
        messageDic["receiver_id"] = message.receiverId
        messageDic["chat_id"] = message.chatId
        print(messageDic)
        socket.emit("send_message", with: [SharedManager.shared.returnJsonObject(dictionary: messageDic)])
    }
    
    // MARK: - socket call methods
    func sendReject(dictionary:[String:Any]) {
        self.socket.emit(dictionary["type"] as! String, with: [SharedManager.shared.returnJsonObject(dictionary: dictionary)])
    }
    
    func sendSDP(dictionary:[String:Any]) {
        self.socket.emit(dictionary["type"] as! String, with: [SharedManager.shared.returnJsonObject(dictionary: dictionary)])
    }
    func sendCandidates(dictionary:[String:Any]) {
        self.socket.emit(dictionary["type"] as! String, with: [SharedManager.shared.returnJsonObject(dictionary: dictionary)])
    }
    
    func sendReadyForCall(dictionary:[String:Any]) {
        self.socket.emit(dictionary["type"] as! String, with: [SharedManager.shared.returnJsonObject(dictionary: dictionary)])
    }
    
    func sendNewCall(dictionary :[String:Any])  {
        self.socket.emit(dictionary["type"] as! String, with: [SharedManager.shared.returnJsonObject(dictionary: dictionary)])
    }
    
    
    func sendReadyForCallEvent(data:Available) {
        if SocketIOManager.sharedInstance.manager?.status == .connected {
            var dic = [String:Any]()
            dic["type"] = "readyforcall"
            dic["connectedUserId"] = data.connectedUserId
            SocketIOManager.sharedInstance.sendReadyForCall(dictionary: dic)
        }
    }
}

