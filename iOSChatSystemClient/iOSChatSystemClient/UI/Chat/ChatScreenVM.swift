//
//  ChatScreenVM.swift
//  iOSChatSystemClient
//
//  Created by Dmitrii Titov on 11.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import UIKit
import RxSwift
import QMChatViewController
import Realm
import RealmSwift

class ChatScreenVM: NSObject {
    
    let disposeBag = DisposeBag()

    var messages = [QBChatMessage]()
    let newMessages = Variable<[QBChatMessage]>([QBChatMessage]())
    
    var room: Room!
    var chatManager: ChatManager!
    
    init(withRoom room: Room) {
        super.init()
        
        self.room = room
        
        chatManager = RoomsManager.shared.manager(forID: room.id)
        
        chatManager.newMessages.asObservable()
            .map({ $0.map({ ChatManager.qbMessage(fromMessage: $0) }) })
            .bind(to: self.newMessages)
            .disposed(by: self.disposeBag)
        
        chatManager.requestStoredMessages()
    }
    
    func generateMessages() {
        let realm = try! Realm()
        let newMessages = Array(realm.objects(Message.self)
            .filter({ $0.roomID == self.room.id })
            .map({ ChatManager.qbMessage(fromMessage: $0) }))
        self.newMessages.value = newMessages
        self.messages.append(contentsOf: newMessages)
    }
    
    func sendMessage(text: String) -> Message {
        let message = Message()
        message.senderID = LocalServer.shared.serverURLString.value
        message.text = text
        message.roomID = room.id
                
        chatManager.sendMessage(message: message)
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(message)
        }
        
        return message
    }
    
}
