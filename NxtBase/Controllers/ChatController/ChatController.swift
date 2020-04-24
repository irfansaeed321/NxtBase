//
//  ChatController.swift
//  NxtBase
//
//  Created by mac on 04/04/2020.
//  Copyright © 2020 Private. All rights reserved.
//

import UIKit

class ChatController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.register(UINib(nibName: ChatCell.className, bundle: nil), forCellReuseIdentifier: ChatCell.className)
        }
    }
    
    //MARK:- Properties
    var dataArray = [OnlineUsersObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Online Users"
        if SocketIOManager.sharedInstance.manager?.status != .connected && SocketIOManager.sharedInstance.manager?.status != .connecting {
            SocketIOManager.sharedInstance.establishConnection()
        }
        SocketIOManager.sharedInstance.delegate = self
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            SocketIOManager.sharedInstance.closeConnection()
            self.appDelegate.moveToLogin()
        }
    }
}

extension ChatController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.className, for: indexPath) as! ChatCell
        let objData = dataArray[indexPath.row]
        if let name = objData.name {
            cell.lblName.text = name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objData = dataArray[indexPath.row]
        let conVC = storyboard?.instantiateViewController(withIdentifier: ConversationController.className) as! ConversationController
        conVC.receiver_id = objData.user_id
        navigationController?.pushViewController(conVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension ChatController: SocketDelegate {
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
        
    }
    
    func didReceiveChatId(data: [Any]) {
        
    }
    
    func didReceiveOfflineStatus(data: [String : Any]) {
        guard let user_id = data["user_id"] as? Int else {return}
        var currentIndex = 0
        for user in dataArray {
            if user.user_id == user_id {
                dataArray.remove(at: currentIndex)
                tableView.beginUpdates()
                tableView.deleteRows(at: [IndexPath(row: currentIndex, section: 0)], with: .fade)
                tableView.endUpdates()
                break
            }
            currentIndex += 1
        }
    }

    func didSocketConnected(data: [Any]) {
        
    }
    
    func didSocketDisConnected(data: [Any]) {

    }
    
    func didReceiveActiveStatus(data: [Any]) {
        print("Active status \(data)")
        let dictionary : [String : Any] = data.first as! [String : Any]
        guard let user_id =  dictionary["user_id"] as? Int else {return}
        if dataArray.count != 0 {
            for item in dataArray {
                if item.user_id == user_id {
                    break
                } else {
                    let obj = OnlineUsersObject(fromDictionary: dictionary)
                    dataArray.insert(obj, at: 0)
                    tableView.reloadData()
                }
            }
        } else {
            let obj = OnlineUsersObject(fromDictionary: dictionary)
            dataArray.insert(obj, at: 0)
            tableView.reloadData()
        }
        
    }
}
