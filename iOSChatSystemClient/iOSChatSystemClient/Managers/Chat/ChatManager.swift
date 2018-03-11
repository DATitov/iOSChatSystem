//
//  ChatManager.swift
//  iOSChatSystemClient
//
//  Created by Dmitrii Titov on 11.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import SwiftyJSON
import RxSwift
import QMChatViewController

enum RoomState {
    case Connected
    case Unconnected
}

class ChatManager: NSObject {

    var room: Room!
    var otherUserID: String!
    var otherUserName: String!
    
    let newMessages = Variable<[Message]>([Message]())
    let roomState = Variable<RoomState>(RoomState.Unconnected)
    
    var messages = [Message]()
    
    var pingTimer: Timer!
    
    init(room: Room) {
        super.init()
        
        self.room = room
        otherUserID = room.user1ID == LocalServer.shared.serverURLString.value
            ? room.user2ID
            : room.user1ID
        otherUserName = UsersManager.shared.user(forID: otherUserID)?.name
        
        loadLocalRooms()
        
        pingTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { _ in
            self.sendPing()
        })
    }
    
    func loadLocalRooms() {
        let realm = try! Realm()
        let messages = realm.objects(Message.self).filter({ $0.roomID == self.room.id })
        var newMessages = [Message]()
        for message in messages {
            let newMessage = Message()
            newMessage.id = message.id
            newMessage.text = message.text
            newMessage.senderID = message.senderID
            newMessage.date = message.date
            
            newMessages.append(newMessage)
        }
        self.newMessages.value = newMessages
    }
    
    func sendMessage(message: Message) {
        let params = ["method": ClientsMethod.Room.ReceiveMessage.rawValue,
                      "text": message.text,
                      "date": message.dateString(),
                      "roomID": message.roomID,
                      "id": message.id,
                      "senderID": message.senderID]
        ChatSocketManager.sharedCSM.write(urlString: otherUserID, params: params, completion: nil) 
    }
    
    func sendPing() {
        let params = ["method": ClientsMethod.Room.Ping.rawValue]
        
        ChatSocketManager.sharedCSM.write(urlString: otherUserID, params: params) { (json) in
            guard let json = json else {
                return
            }
            print("")
        }
    }
    
    func receiveMessage(message: Message) {
        newMessages.value = [message]
    }
    
    static func qbMessage(fromMessage message: Message) -> QBChatMessage {
        let qbMessage = QBChatMessage()
        
        qbMessage.text = message.text
        qbMessage.createdAt = message.date
        qbMessage.dateSent = message.date
        qbMessage.senderID = message.senderID == LocalServer.shared.serverURLString.value
        ? 2
        : 1
        
        return qbMessage
    }
    
}
