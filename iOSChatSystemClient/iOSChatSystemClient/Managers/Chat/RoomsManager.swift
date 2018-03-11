//
//  RoomsManager.swift
//  iOSChatSystemClient
//
//  Created by Dmitrii Titov on 09.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import UIKit
import RxSwift
import Realm
import RealmSwift
import SwiftyJSON

class RoomsManager: NSObject {
    
    static let shared: RoomsManager = {
        let instance = RoomsManager()
        return instance
    }()
    
    let roomsManagers = Variable<[ChatManager]>([ChatManager]())
    
    func addRooms(rooms: [Room]) {
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(rooms)
        }
        
        var managers = [ChatManager]()
        for room in realm.objects(Room.self) {
            let newRoom = Room(room: room)
            managers.append(ChatManager(room: room))
        }
        self.roomsManagers.value = managers
    }
    
    func updateRooms() {
        let params = ["method": ServerMethod.Socket.LoadRooms.rawValue,
                      "sender": LocalServer.shared.serverURLString.value,
                      "user_id": LocalServer.shared.serverURLString.value]
        
        SocketManager.shared.write(urlString: ServerInteractor.shared.serverURLString.value,
                                   params: params,
                                   completion: { json in
                                    guard let json = json else {
                                        return
                                    }
                                    
                                    self.joinRawRooms(rawRooms: json["rooms"].arrayValue)
        })
    }
    
    func createRoom(withUSer user: User, completion: @escaping ((Room?) -> ())) {
        RemoteServerInteractor.shared.executeRequest(urlString: ServerInteractor.shared.serverURLString.value,
                                                     params: [
                                                        "method": ServerMethod.CreateRoom.rawValue,
                                                        "user1": UsersManager.shared.getCurrentUser().toJSONString()!,
                                                        "user2": user.toJSONString()!
        ]) { (data, response, error) in
            guard let data = data,
                let string = String(data: data, encoding: .utf8) else {
                    return completion(nil)
            }
            let json = JSON(parseJSON: string)
            let room = Room(withJSON: json)
            return completion(room)
        }
    }
    
    func joinRawRooms(rawRooms: [JSON]) {
        var rooms = [ChatManager]()
        for rawRoom in rawRooms {
            let room = Room(withJSON: rawRoom)
            let manager = ChatManager(room: room)
            rooms.append(manager)
        }
        
        self.roomsManagers.value = rooms
    }
    
    func receiveMessage(message: Message) {
        guard let manager = roomsManagers.value.filter({ $0.room.id == message.roomID }).first else {
            return
        }
        manager.receiveMessage(message: message)
    }
    
    func manager(forID id: String) -> ChatManager {
        return roomsManagers.value.filter({ $0.room.id == id }).first!
    }
    
}
