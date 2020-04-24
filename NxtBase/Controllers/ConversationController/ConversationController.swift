//
//  ConversationController.swift
//  NxtBase
//
//  Created by mac on 04/04/2020.
//  Copyright © 2020 Private. All rights reserved.
//

import UIKit
import WebRTC

class ConversationController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.tableFooterView = UIView()
            tableView.register(UINib(nibName: SenderCell.className, bundle: nil), forCellReuseIdentifier: SenderCell.className)
            tableView.register(UINib(nibName: ReceiverCell.className, bundle: nil), forCellReuseIdentifier: ReceiverCell.className)
        }
    }
    
    @IBOutlet weak var txtMessage: UITextView!{
        didSet {
            txtMessage.text = "Type Here"
            txtMessage.delegate = self
            txtMessage.roundCorners(radius: 20, bordorColor: .lightGray, borderWidth: 0.5)
        }
    }
    
    //MARK:- Properties
    var receiver_id = 0
    var chat_id = 0
    var dataArray = [ChatsData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SocketIOManager.sharedInstance.delegate = self
        getChatId()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    
    //MARK:- Custom
    func getChatId() {
        let param: [String:Any] = ["user_id": SharedManager.shared.user_id.description, "receiver_id": receiver_id.description]
        print(param)
        SocketIOManager.sharedInstance.emitStartChat(dictionary: param)
    }
    
    func addNewRow(with chatMessage: ChatsData) {
        tableView.beginUpdates()
        dataArray.append(chatMessage)
        let indexPath = IndexPath(row: dataArray.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .none)
        tableView.endUpdates()
        tableView.scrollToBottomRow()
    }
    
    func initiateCall(isVideoEnabled:Bool) {
        if(WebRTCClient.sharedInstance.isConnected){return}
        
        CallManager.sharedInstance.incomingCallUserId = receiver_id
//        CallManager.sharedInstance.connectedUserName = receivedchat.firstname
//        CallManager.sharedInstance.connectedUserPhoto = receivedchat.profileImage
        
        RTCAudioSession.sharedInstance().useManualAudio = true
        CallManager.sharedInstance.isIncomingCall = false
        CallManager.sharedInstance.isVideoEnabled = isVideoEnabled
        CallManager.sharedInstance.startWebrtc()
        CallManager.sharedInstance.showCallScreen()
    }

    //MARK:- IBActions
    @IBAction func actionSend(_ sender: UIButton) {
        guard let message = txtMessage.text else {
            return
        }
        if message == "" || message == "Type Here" {
            return
        }
        let param: [String:Any] = [
            "message": message,
            "sender_id": SharedManager.shared.user_id.description,
            "receiver_id": receiver_id.description,
            "chat_id": chat_id.description,
            "unixTime": Date().timeIntervalSince1970
        ]
        print(param)
        let object = ChatsData(fromDictionary: param)
        addNewRow(with: object)
        SocketIOManager.sharedInstance.sendMessage(message: object)
        txtMessage.text.removeAll()
    }
    
    @IBAction func actionVideoCall(_ sender: UIButton) {
        initiateCall(isVideoEnabled: true)
    }
    
    
    //MARK:- API Calls
    func getChats(params: [String:Any]) {
        showLoader()
        UserHandler.getChats(params: params, success: {[weak self] (successResponse) in
            guard let self = self else {return}
            self.stopAnimating()
            if successResponse.status && successResponse.code == 200 {
                self.dataArray = successResponse.data
                self.tableView.reloadData()
                if self.dataArray.isEmpty {
                    self.tableView.setEmptyMessage("No messages")
                } else {
                    self.tableView.restore()
                    self.tableView.scrollToBottomRow()
                }
            } else {
                let alert = Constants.showBasicAlertGlobal(message: successResponse.message)
                self.presentVC(alert)
            }
        }) {[weak self] (error) in
            guard let self = self else {return}
            self.stopAnimating()
            let alert = Constants.showBasicAlertGlobal(message: error.message)
            self.presentVC(alert)
        }
    }
}

extension ConversationController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let objData = dataArray[indexPath.row]
        if objData.senderId != SharedManager.shared.user_id.description {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReceiverCell.className, for: indexPath) as! ReceiverCell
            if let message = objData.message {
                cell.lblMessage.text = message
            }
            if let time = objData.unixTime {
                let dbl = Double(time)
                let unixTime = Date(timeIntervalSince1970: dbl)
                let timeToShow = SharedManager.timeToShow(date: unixTime, format: Constants.DateFormat.time)
                cell.lblTime.text = timeToShow
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SenderCell.className, for: indexPath) as! SenderCell
            if let message = objData.message {
                cell.lblMessage.text = message
            }
            if let time = objData.unixTime {
                let dbl = Double(time)
                let unixTime = Date(timeIntervalSince1970: dbl)
                let timeToShow = SharedManager.timeToShow(date: unixTime, format: Constants.DateFormat.time)
                cell.lblTime.text = timeToShow
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ConversationController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Type Here" {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Type Here"
            textView.textColor = .lightGray
        }
    }
}

extension ConversationController: SocketDelegate {
    func didReceiveOffer(data: SignalingMessage) {
        
    }
    
    func didReceiveAnswer(data: SignalingMessage) {
        
    }
    
    func didReceiveCandidate(data: SignalingMessage) {
        
    }
    
    func didReceiveReject(data: [String : Any]) {
        
    }
    
    func didReceiveAvailable(data: Available) {
        
    }
    
    func didReceiveReadyforcall(data: Available) {
        
    }
    
    func didReceiveNewMessage(data: ChatsData) {
        print(data)
        addNewRow(with: data)
    }
    
    func didSocketConnected(data: [Any]) {
        
    }
    
    func didSocketDisConnected(data: [Any]) {
        
    }
    
    func didReceiveActiveStatus(data: [Any]) {
        
    }
    
    func didReceiveOfflineStatus(data: [String : Any]) {
        
    }
    
    func didReceiveChatId(data: [Any]) {
        guard let id = data.first as? Int else {return}
        let param: [String:Any] = ["chat_id": id]
        chat_id = id
        print(param)
        getChats(params: param)
    }
}
